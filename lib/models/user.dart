class User {
  User({
    required this.id,
    required this.name,
    required this.email,
    this.mobile,
    this.patientId,
    this.emailVerifiedAt,
    this.currentTeamId,
    this.profilePhotoPath,
    required this.createdAt,
    required this.updatedAt,
    this.profilePhotoUrl,
  });

  final int id;
  final String name;
  final String email;
  final String? mobile;
  final String? patientId;
  final DateTime? emailVerifiedAt;
  final String? currentTeamId;
  final String? profilePhotoPath;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? profilePhotoUrl;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        mobile: json["mobile"],
        patientId: json["patient_id"],
        emailVerifiedAt: json["email_verified_at"] == null
            ? null
            : DateTime.parse(json["email_verified_at"]),
        currentTeamId: json["current_team_id"],
        profilePhotoPath: json["profile_photo_path"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        profilePhotoUrl: json["profile_photo_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "mobile": mobile,
        "patient_id": patientId,
        "email_verified_at": emailVerifiedAt,
        "current_team_id": currentTeamId,
        "profile_photo_path": profilePhotoPath,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "profile_photo_url": profilePhotoUrl,
      };
}
