class TokenResponse {
  final bool basarili;
  final String token;

  TokenResponse({required this.basarili, required this.token});

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
      basarili: json['basarili'],
      token: json['token'],
    );
  }
}
