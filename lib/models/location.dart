import 'package:hokmabadi/models/ascend_ref_object.dart';

class Location {
  Location({
    required this.id,
    required this.name,
    required this.abbreviation,
    required this.taxPercentage,
    required this.timeZone,
    required this.website,
    required this.email,
    required this.phone,
    required this.address1,
    required this.address2,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.image,
    required this.provider,
    required this.feeSchedule,
    this.lastModified,
  });

  final String id;
  final String name;
  final String? abbreviation;
  final num taxPercentage;
  final String timeZone;
  final String? website;
  final String email;
  final String phone;
  final String address1;
  final String? address2;
  final String city;
  final String state;
  final String postalCode;
  final AscendRefObject? image;
  final AscendRefObject? provider;
  final AscendRefObject feeSchedule;
  final DateTime? lastModified;

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json["id"],
      name: json["name"],
      abbreviation: json["abbreviation"] ?? "",
      taxPercentage: json["taxPercentage"],
      timeZone: json["timeZone"],
      website: json["website"],
      email: json["email"],
      phone: json["phone"],
      address1: json["address1"],
      address2: json["address2"],
      city: json["city"],
      state: json["state"],
      postalCode: json["postalCode"],
      image: json["image"] == null
          ? null
          : AscendRefObject.fromJson(Map<String, dynamic>.from(json["image"])),
      provider: json["provider"] == null
          ? null : AscendRefObject.fromJson(Map<String, dynamic>.from(json["provider"])),
      feeSchedule: AscendRefObject.fromJson(
          Map<String, dynamic>.from(json["feeSchedule"])),
      lastModified: json["lastModified"] == null
          ? null
          : DateTime.parse(json["lastModified"]),
    );
  }
}
