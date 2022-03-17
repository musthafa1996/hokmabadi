class Patient {
  Patient({
    required this.id,
    this.title,
    required this.firstName,
    this.middleInitial,
    required this.lastName,
    this.nameSuffix,
    this.preferredName,
    this.gender,
    required this.dateOfBirth,
    required this.contactMethod,
    required this.languageType,
    required this.patientStatus,
    this.emailAddress,
    this.chartNumber,
    this.firstVisitDate,
    this.preferredDays,
    this.preferredTimes,
    required this.address1,
    this.address2,
    required this.city,
    required this.state,
    required this.postalCode,
    this.income,
    this.phones,
    this.referredByPatient,
    this.referredByReferral,
    this.primaryProvider,
    this.primaryGuarantor,
    this.secondaryGuarantor,
    this.primaryContact,
    this.secondaryContact,
    this.preferredLocation,
    this.discountPlan,
    this.referredPatients,
    this.lastModified,
  });

  final String id;
  final String? title;
  final String firstName;
  final String? middleInitial;
  final String lastName;
  final String? nameSuffix;
  final String? preferredName;
  final String? gender;
  final DateTime dateOfBirth;
  final String contactMethod;
  final String languageType;
  final String patientStatus;
  final String? emailAddress;
  final String? chartNumber;
  final DateTime? firstVisitDate;
  final List? preferredDays;
  final List? preferredTimes;
  final String address1;
  final String? address2;
  final String city;
  final String state;
  final String postalCode;
  final num? income;
  final List<PhoneNumber>? phones;
  final Map<String, dynamic>? referredByPatient;
  final Map<String, dynamic>? referredByReferral;
  final Map<String, dynamic>? primaryProvider;
  final Map<String, dynamic>? primaryGuarantor;
  final Map<String, dynamic>? secondaryGuarantor;
  final Map<String, dynamic>? primaryContact;
  final Map<String, dynamic>? secondaryContact;
  final Map<String, dynamic>? preferredLocation;
  final Map<String, dynamic>? discountPlan;
  final List? referredPatients;
  final DateTime? lastModified;

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      title: json['title'],
      firstName: json['firstName'],
      middleInitial: json['middleInitial'],
      lastName: json['lastName'],
      nameSuffix: json['nameSuffix'],
      preferredName: json['preferredName'],
      gender: json['gender'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      contactMethod: json['contactMethod'],
      languageType: json['languageType'],
      patientStatus: json['patientStatus'],
      emailAddress: json['emailAddress'],
      chartNumber: json['chartNumber'],
      firstVisitDate: json['firstVisitDate'] == null
          ? null
          : DateTime.parse(json['firstVisitDate']),
      preferredDays: json['preferredDays'],
      preferredTimes: json['preferredTimes'],
      address1: json['address1'],
      address2: json['address2'],
      city: json['city'],
      state: json['state'],
      postalCode: json['postalCode'],
      income: json['income'],
      phones: json['phones'] == null
          ? null
          : (json['phones'] as List)
              .map((e) => PhoneNumber.fromJson(Map<String, dynamic>.from(e)))
              .toList(),
      referredByPatient: json['referredByPatient'] == null
          ? null
          : Map<String, dynamic>.from(json['referredByPatient']),
      referredByReferral: json['referredByReferral'] == null
          ? null
          : Map<String, dynamic>.from(json['referredByReferral']),
      primaryProvider: json['primaryProvider'] == null
          ? null
          : Map<String, dynamic>.from(json['primaryProvider']),
      primaryGuarantor: json['primaryGuarantor'] == null
          ? null
          : Map<String, dynamic>.from(json['primaryGuarantor']),
      secondaryGuarantor: json['secondaryGuarantor'] == null
          ? null
          : Map<String, dynamic>.from(json['secondaryGuarantor']),
      primaryContact: json['primaryContact'] == null
          ? null
          : Map<String, dynamic>.from(json['primaryContact']),
      secondaryContact: json['secondaryContact'] == null
          ? null
          : Map<String, dynamic>.from(json['secondaryContact']),
      preferredLocation: json['preferredLocation'] == null
          ? null
          : Map<String, dynamic>.from(json['preferredLocation']),
      discountPlan: json['discountPlan'] == null
          ? null
          : Map<String, dynamic>.from(json['discountPlan']),
      referredPatients: json['referredPatients'],
      lastModified: json['lastModified'] == null
          ? null
          : DateTime.parse(json['lastModified']),
    );
  }
}

class PhoneNumber {
  PhoneNumber({
    required this.id,
    required this.phoneType,
    required this.number,
    this.type,
    required this.sequence,
  });

  final String id;
  final String phoneType;
  final String number;
  final String? type;
  final int sequence;

  factory PhoneNumber.fromJson(Map<String, dynamic> json) {
    return PhoneNumber(
      id: json["id"],
      phoneType: json["phoneType"],
      number: json["number"],
      type: json["type"],
      sequence: json["sequence"],
    );
  }
}
