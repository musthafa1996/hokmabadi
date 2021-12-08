class Token {
  Token({
    required this.accessToken,
    required this.expiresIn,
    required this.tokenType,
  });

  final String accessToken;
  final String expiresIn;
  final String tokenType;

  factory Token.fromJson(Map<String, dynamic> json) => Token(
    accessToken: json["access_token"],
    expiresIn: json["expires_in"],
    tokenType: json["token_type"],
  );
}