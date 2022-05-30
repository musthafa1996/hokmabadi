import 'package:agora_rtc_engine/rtc_engine.dart';

class VirtualAppointmentParams {
  VirtualAppointmentParams({
    required this.channel,
    required this.role,
    required this.token,
    required this.appointmentId,
  });

  final String channel;
  final ClientRole role;
  final String token;
  final int appointmentId;
}