import 'ascend_ref_object.dart';

class Appointment {
  Appointment({
    required this.id,
    required this.start,
    this.end,
    this.created,
    this.confirmed,
    required this.needsFollowUp,
    this.followedUpOn,
    required this.needsPremedicate,
    required this.status,
    this.note,
    this.other,
    required this.bookedOnline,
    this.leftMessage,
    this.bookingType,
    this.duration,
    this.lastModified,
    this.labCaseDentalLab,
    this.labCaseStatus,
    this.labCaseDueDate,
    this.labCaseNote,
    this.patientProcedures,
    this.visits,
    required this.provider,
    this.otherProvider,
    this.location,
    required this.locationUid,
    required this.patient,
    required this.operatory,
  });

  final int id;
  final DateTime start;
  final DateTime? end;
  final DateTime? created;
  final DateTime? confirmed;
  final bool needsFollowUp;
  final DateTime? followedUpOn;
  final bool needsPremedicate;
  final String status;
  final String? note;
  final String? other;
  final bool bookedOnline;
  final DateTime? leftMessage;
  final String? bookingType;
  final int? duration;
  final DateTime? lastModified;
  final dynamic labCaseDentalLab;
  final String? labCaseStatus;
  final DateTime? labCaseDueDate;
  final String? labCaseNote;
  final String locationUid;
  final List? patientProcedures;
  final List? visits;
  final AscendRefObject provider;
  final AscendRefObject? otherProvider;
  final AscendRefObject? location;
  final AscendRefObject patient;
  final AscendRefObject operatory;

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      start: DateTime.parse(json['start']),
      end: json['end'] == null ? null : DateTime.parse(json['end']),
      created: json['created'] == null ? null : DateTime.parse(json['created']),
      confirmed:
          json['confirmed'] == null ? null : DateTime.parse(json['confirmed']),
      needsFollowUp: json['needsFollowUp'] = true,
      followedUpOn: json['followedUpOn'] == null
          ? null
          : DateTime.parse(json['followedUpOn']),
      needsPremedicate: json['needsPremedicate'] == true,
      status: json['status'],
      note: json['note'],
      locationUid: json['location_uid'],
      other: json['other'],
      bookedOnline: json['bookedOnline'] == true,
      leftMessage: json['leftMessage'] == null
          ? null
          : DateTime.parse(json['leftMessage']),
      bookingType: json['bookingType'],
      duration: json['duration'],
      lastModified: json['lastModified'] == null
          ? null
          : DateTime.parse(json['lastModified']),
      labCaseDentalLab: json['labCaseDentalLab'],
      labCaseStatus: json['labCaseStatus'],
      labCaseDueDate: json['labCaseDueDate'] == null
          ? null
          : DateTime.parse(json['labCaseDueDate']),
      labCaseNote: json['labCaseNote'],
      patientProcedures: json['patientProcedures'],
      visits: json['visits'],
      provider: AscendRefObject.fromJson(json['provider']),
      otherProvider: json['otherProvider'] == null
          ? null
          : AscendRefObject.fromJson(json['otherProvider']),
      location: json['location'] == null
          ? null
          : AscendRefObject.fromJson(json['location']),
      patient: AscendRefObject.fromJson(json['patient']),
      operatory: AscendRefObject.fromJson(json['operatory']),
    );
  }
}
