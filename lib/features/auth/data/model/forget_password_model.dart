class ResetPasswordRequest {
  final String email;

  ResetPasswordRequest({
    required this.email,
  });

  Map<String, dynamic> toJson() => {
    'email': email
  };
}

class ResetPasswordOTPRequest {
  final String email;
  final String otp;
  ResetPasswordOTPRequest({
    required this.email,
    required this.otp
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'otp': otp
  };
}

class ForgotPasswordResponse {
  final bool success;
  final String message;
  final ForgotPasswordData? data;

  ForgotPasswordResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null 
          ? ForgotPasswordData.fromJson(json['data']) 
          : null,
    );
  }
}

class ForgotPasswordData {
  final String email;
  final String expiresIn;
  final String resendAfter;

  ForgotPasswordData({
    required this.email,
    required this.expiresIn,
    required this.resendAfter,
  });

  factory ForgotPasswordData.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordData(
      email: json['email'] ?? '',
      expiresIn: json['expires_in'] ?? '10 minutes',
      resendAfter: json['resend_after'] ?? '60 seconds',
    );
  }
}
