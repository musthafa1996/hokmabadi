class AgoraToken {
  AgoraToken({
    required this.token,
  });

  final String token;

  factory AgoraToken.fromJson(Map<String, dynamic> json) {
    return AgoraToken(
      token: json['token'],
    );
  }
}
