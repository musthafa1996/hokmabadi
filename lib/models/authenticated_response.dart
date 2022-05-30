import 'package:hokmabadi/models/user.dart';


class AuthenticatedResponse {
  AuthenticatedResponse({
    this.platform,
    required this.user,
    required this.token,
  });

  final String? platform;
  final User user;
  final String token;

  factory AuthenticatedResponse.fromJson(Map<String, dynamic> json) {
    return AuthenticatedResponse(
      platform: json["platform"],
      user: User.fromJson(json["user"]),
      token: json["token"],
    );
  }

  Map<String, dynamic> toJson() => {
        "platform": platform,
        "user": user,
        "token": token,
      };
}
