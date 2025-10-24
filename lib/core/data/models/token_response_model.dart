class TokenResponse {
  final bool isSuccess;
  final String token;

  TokenResponse({required this.isSuccess, required this.token});

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
      isSuccess: json['basarili'],
      token: json['token'],
    );
  }
}
