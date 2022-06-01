import 'dart:async';
import 'dart:convert';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hokmabadi/config/app_config.dart';
import 'package:hokmabadi/models/virtual_appointment_params.dart';
import 'package:pusher_client/pusher_client.dart';

const kPusherAppId = "6a62ad667f59b53db930";
const kPusherCluster = "mt1";
const kPusherChannelName = "thdc-virtuals";
const kPusherEventName = "patient-kicked";

class VirtualCall extends StatefulWidget {
  const VirtualCall({
    Key? key,
    required this.params,
    required this.onCallEnded,
    required this.onRemovedFromCall,
  }) : super(key: key);

  final VirtualAppointmentParams params;
  final VoidCallback onCallEnded;
  final VoidCallback onRemovedFromCall;

  @override
  _VirtualCallState createState() => _VirtualCallState();
}

class _VirtualCallState extends State<VirtualCall> {
  final _users = <Map<String, dynamic>>[];
  final _infoStrings = <String>[];

  final _showButtons = ValueNotifier(true);

  bool _muted = false;
  bool _restoredOrientation = false;

  late RtcEngine? _engine;
  late PusherClient? _pusher;
  late Channel? _pusherChannel;

  @override
  void initState() {
    initialize();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // Wakelock.enable();

    super.initState();
  }

  @override
  void dispose() {
    // Wakelock.disable();
    if (!_restoredOrientation) {
      _restoreOrientation();
    }

    // clear users
    _users.clear();
    // destroy sdk
    _engine?.leaveChannel();
    _engine?.destroy();

    // Unsubscribe and disconnect pusher
    _pusherChannel?.unbind(kPusherEventName);
    _pusher?.unsubscribe(kPusherChannelName);
    _pusher?.disconnect();

    super.dispose();
  }

  Future<void> initialize() async {
    _engine = await RtcEngine.create(AppConfig.agoraAppId);

    await _engine!.enableVideo();
    await _engine!.enableAudio();
    await _engine!.adjustRecordingSignalVolume(400);
    // await _engine!.enableLocalVideo(true);
    // await _engine!.enableLocalAudio(true);
    await _engine!.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine!.setRemoteUserPriority(0, UserPriority.High);
    await _engine!.setClientRole(
      widget.params.role,
      ClientRoleOptions(
        audienceLatencyLevel: AudienceLatencyLevelType.LowLatency,
      ),
    );
    _addAgoraEventHandlers();

    final configuration = VideoEncoderConfiguration(
        dimensions: VideoDimensions(height: 2173, width: 1080));
    await _engine!.setVideoEncoderConfiguration(configuration);
    await _engine!
        .joinChannel(widget.params.token, widget.params.channel, null, 0);

    // Initialize Pusher
    try {
      final options = PusherOptions(cluster: kPusherCluster, wsPort: 6001);

      _pusher = PusherClient(kPusherAppId, options, autoConnect: false);

      // connect at a later time than at instantiation.
      _pusher!.connect();

      _pusher!.onConnectionStateChange((state) {
        debugPrint(
            "previousState: ${state?.previousState}, currentState: ${state?.currentState}");
      });

      _pusher!.onConnectionError((error) {
        debugPrint("error: ${error?.message}");
      });

      _pusherChannel = _pusher!.subscribe(kPusherChannelName);
      await _pusherChannel!.bind(kPusherEventName, _handlePusherEvent);
    } catch (error) {
      debugPrint("Error: ${error.toString()}");
    }
  }

  void _handlePusherEvent(PusherEvent? event) {
    if (event?.data == null) return;

    try {
      final data = jsonDecode(event!.data!);
      if (data['appointment'] == widget.params.appointmentId &&
          data['message'] != null) {
        _restoreOrientation();
        widget.onRemovedFromCall();
      }
    } catch (e) {
      // Handle json decode error if any
    }
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    _engine!.setEventHandler(
      RtcEngineEventHandler(error: (code) {
        setState(() {
          final info = 'onError: $code';
          debugPrint("Agora error: $code");
          _infoStrings.add(info);
        });
      }, joinChannelSuccess: (channel, uid, elapsed) {
        setState(() {
          final info = 'onJoinChannel: $channel, uid: $uid';
          _infoStrings.add(info);
        });
      }, leaveChannel: (stats) {
        setState(() {
          _infoStrings.add('onLeaveChannel');
          _users.clear();
        });
      }, userJoined: (uid, elapsed) {
        setState(() {
          final info = 'userJoined: $uid';
          _infoStrings.add(info);
          _users.add({
            "uid": uid,
            "aspectRatio": 1.0,
          });
        });
      }, userOffline: (uid, elapsed) {
        setState(() {
          final info = 'userOffline: $uid';
          _infoStrings.add(info);
          _users.removeWhere((u) => u['uid'] == uid);
        });
      }, firstRemoteVideoFrame: (uid, width, height, elapsed) {
        setState(() {
          final user = List<Map<String, dynamic>?>.from(_users)
              .firstWhere((u) => u!['uid'] == uid, orElse: () => null);
          if (user != null) {
            setState(() {
              user["aspectRatio"] = width / height;
            });
          }

          final info = 'firstRemoteVideo: $uid ${width}x $height';
          _infoStrings.add(info);
        });
      }, videoSizeChanged: (uid, width, height, rotation) {
        setState(() {
          final user = List<Map<String, dynamic>?>.from(_users)
              .firstWhere((u) => u!['uid'] == uid, orElse: () => null);
          if (user != null) {
            setState(() {
              user["aspectRatio"] = width / height;
            });
          }
        });
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: <Widget>[
            _buildVideos(),
            GestureDetector(
              onTap: () {
                _showButtons.value = !_showButtons.value;
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                constraints: const BoxConstraints.expand(),
                child: ValueListenableBuilder<bool>(
                    valueListenable: _showButtons,
                    builder: (context, value, child) {
                      return AnimatedSlide(
                        duration: const Duration(milliseconds: 100),
                        offset: Offset(0, value ? 0 : 0.1),
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 100),
                          opacity: value ? 1 : 0,
                          child: _buildToolbar(),
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideos() {
    final List<Widget> views = [];
    if (widget.params.role == ClientRole.Broadcaster) {
      final child = AspectRatio(
        aspectRatio: 1200 / 900,
        child: rtc_local_view.SurfaceView(),
      );
      // final child = RtcLocalView.SurfaceView();
      views.add(child);
    }
    for (final user in _users) {
      final child = AspectRatio(
        aspectRatio: user['aspectRatio'],
        child: rtc_remote_view.SurfaceView(uid: user['uid']),
      );
      views.insert(0, child);
    }

    switch (views.length) {
      case 0:
        return Container();
      case 1:
        return Container(
          alignment: Alignment.center,
          child: views[0],
        );
      default:
        return Stack(
          alignment: Alignment.topLeft,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: views[0],
            ),
            Container(
              height: 90,
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 15,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: _buildSubVideos(views.sublist(1)),
            ),
          ],
        );
    }
  }

  /// Video view row wrapper
  Widget _buildSubVideos(List<Widget> views) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(views.length, (index) {
        return Padding(
          padding: EdgeInsets.only(left: index == 0 ? 0 : 8),
          child: views[index],
        );
      }),
    );
  }

  Widget _buildToolbar() {
    if (widget.params.role == ClientRole.Audience) return Container();
    return Container(
      alignment: Alignment.bottomCenter,
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          MaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              _muted ? Icons.mic_off : Icons.mic,
              color: _muted ? Colors.white : Colors.blueAccent,
              size: 24,
            ),
            shape: const CircleBorder(),
            elevation: 2.0,
            color: _muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
            minWidth: 0,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          const SizedBox(width: 25),
          MaterialButton(
            onPressed: () {
              _restoreOrientation();
              widget.onCallEnded();
            },
            child: const Icon(
              Icons.call_end,
              color: Colors.white,
              size: 24,
            ),
            shape: const CircleBorder(),
            color: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
            minWidth: 0,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          const SizedBox(width: 25),
          MaterialButton(
            onPressed: _onSwitchCamera,
            child: const Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 24,
            ),
            shape: const CircleBorder(),
            elevation: 2.0,
            color: Colors.white,
            minWidth: 0,
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }

  void _onToggleMute() {
    setState(() {
      _muted = !_muted;
    });
    _engine?.muteLocalAudioStream(_muted);
  }

  void _onSwitchCamera() {
    _engine?.switchCamera();
  }

  void _restoreOrientation() {
    _restoredOrientation = true;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }
}
