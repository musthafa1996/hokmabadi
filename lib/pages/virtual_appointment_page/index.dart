import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hokmabadi/models/agora_token.dart';
import 'package:hokmabadi/models/appointment.dart';
import 'package:hokmabadi/models/location.dart';
import 'package:hokmabadi/models/patient.dart';
import 'package:hokmabadi/models/virtual_appointment_params.dart';
import 'package:hokmabadi/pages/virtual_appointment_page/virtual_call.dart';
import 'package:hokmabadi/repositories/agora_repository.dart';
import 'package:hokmabadi/repositories/appointment_repository.dart';
import 'package:hokmabadi/repositories/location_repository.dart';
import 'package:hokmabadi/repositories/patient_repository.dart';
import 'package:hokmabadi/utils/snackbar_messenger.dart';
import 'package:permission_handler/permission_handler.dart';

enum CallEndState { ended, removed }

class VirtualAppointmentPage extends StatefulWidget {
  const VirtualAppointmentPage(
    this.patientId, {
    Key? key,
    this.patient,
  }) : super(key: key);

  final String patientId;
  final Patient? patient;

  @override
  State<VirtualAppointmentPage> createState() => _VirtualAppointmentPageState();
}

class _VirtualAppointmentPageState extends State<VirtualAppointmentPage> {
  Future<VirtualAppointmentParams?>? _appointmentFuture;
  CallEndState? _callEndState;

  @override
  void initState() {
    _appointmentFuture = _retrieveUpcomingAppointment();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_callEndState != null) {
      return _buildCallEnded();
    }

    return FutureBuilder<VirtualAppointmentParams?>(
      future: _appointmentFuture,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            break;
          case ConnectionState.done:
            if (snapshot.hasError) {
              return _buildError(snapshot.error!.toString());
            } else if (snapshot.data == null) {
              return _buildEmpty();
            } else {
              return VirtualCall(
                params: snapshot.data!,
                onCallEnded: _handleCallEnd,
                onRemovedFromCall: _handleRemovedFromCall,
              );
            }
        }

        return _buildLoading();
      },
    );
  }

  Widget _buildError(String? message) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upcoming appointment"),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.symmetric(
            vertical: 35,
            horizontal: 15,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints.tightFor(width: 280),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 100,
                ),
                const SizedBox(height: 20),
                Text(
                  "An error occurred",
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      ?.copyWith(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  message ??
                      "Something went wrong while entering virtual appointment.",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                ConstrainedBox(
                  constraints:
                      const BoxConstraints.tightFor(width: double.maxFinite),
                  child: ElevatedButton(
                    child: const Text(
                      "Retry",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: _retry,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upcoming appointment"),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.symmetric(
            vertical: 35,
            horizontal: 15,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints.tightFor(width: 280),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.warning_amber,
                  size: 100,
                ),
                const SizedBox(height: 20),
                Text(
                  "Nothing in here",
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      ?.copyWith(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                const Text(
                  "No upcoming appointments were found.",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upcoming appointment"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.symmetric(vertical: 35),
            child: const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  Widget _buildCallEnded() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upcoming appointment"),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.symmetric(
            vertical: 35,
            horizontal: 15,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints.tightFor(width: 280),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 6,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  child: const Icon(
                    Icons.call_end,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Appointment ended",
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      ?.copyWith(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  _callEndState == CallEndState.ended
                      ? "You have ended up the virtual appointment."
                      : "You were removed from the appointment by the doctor.",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                _callEndState == CallEndState.ended
                    ? ConstrainedBox(
                        constraints: const BoxConstraints.tightFor(
                            width: double.maxFinite),
                        child: ElevatedButton(
                          child: const Text(
                            "Join again",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: _retry,
                        ),
                      )
                    : ConstrainedBox(
                        constraints: const BoxConstraints.tightFor(
                            width: double.maxFinite),
                        child: ElevatedButton(
                          child: const Text(
                            "Go back",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () => Modular.to.pop(),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _retry() {
    setState(() {
      _callEndState = null;
      _appointmentFuture = _retrieveUpcomingAppointment();
    });
  }

  Future<VirtualAppointmentParams?> _retrieveUpcomingAppointment() async {
    Patient patient;
    if (widget.patient == null) {
      try {
        patient =
            await Modular.get<PatientRepository>().retrieve(widget.patientId);
      } catch (error) {
        throw "Something went wrong while fetching patient information.";
      }
    } else {
      patient = widget.patient!;
    }

    Appointment appointment;
    try {
      final appointments = await Modular.get<AppointmentRepository>().retrieveUpcoming(widget.patientId);
      if (appointments.isEmpty) return null;
      appointment = appointments.first;
    } catch (error) {
      throw "Something went wrong while fetching upcoming appointment.";
    }

    Location location;
    try {
      if (appointment.location?.id == null) {
        throw Exception("Location not assigned to appointment.");
      }
      location = await Modular.get<LocationRepository>().retrieve(appointment.location!.id);
    } catch (error) {
      throw "Something went wrong while identifying appointment location.";
    }

    final channel = "Appointment for ${appointment.id}";

    AgoraToken token;
    try {
      token = await Modular.get<AgoraRepository>().generateToken(
        appointmentId: appointment.id,
        channel: channel,
        location: location.name,
        patientId: patient.id,
        patientName: "${patient.firstName} ${patient.lastName}",
        providerId: appointment.provider.id,
        note: appointment.note,
      );
    } catch (error) {
      throw "Something went wong while joinin the appointment.";
    }

    // Request for camera nd mic permission
    final cameraPermissionStatus = await Permission.camera.request();
    if (!cameraPermissionStatus.isGranted) {
      throw "The camera permission was denied.";
    }
    final micPermissionStatus = await Permission.microphone.request();
    if (!micPermissionStatus.isGranted) {
      throw "The camera permission was denied.";
    }

    return VirtualAppointmentParams(
      channel: channel,
      role: ClientRole.Broadcaster,
      token: token.token,
      appointmentId: appointment.id,
    );
  }

  void _handleCallEnd() {
    setState(() {
      _callEndState = CallEndState.ended;
    });
  }

  void _handleRemovedFromCall() {
    setState(() {
      _callEndState = CallEndState.removed;
    });
    SnackBarMessenger.showWarning(context, "You were removed from the call.");
  }
}
