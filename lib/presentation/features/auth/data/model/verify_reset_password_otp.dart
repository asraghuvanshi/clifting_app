class VerifyResetPasswordOtpResponse {
  final bool success;
  final String message;
  final ResetTokenData? data;

  VerifyResetPasswordOtpResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory VerifyResetPasswordOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyResetPasswordOtpResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] != null
          ? ResetTokenData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }

  @override
  String toString() {
    return 'VerifyResetPasswordOtpResponse{success: $success, message: $message, data: $data}';
  }
}

class ResetTokenData {
  final String expiresIn;
  final String resetToken;

  ResetTokenData({
    required this.expiresIn,
    required this.resetToken,
  });

  factory ResetTokenData.fromJson(Map<String, dynamic> json) {
    return ResetTokenData(
      expiresIn: json['expires_in'] as String,
      resetToken: json['reset_token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'expires_in': expiresIn,
      'reset_token': resetToken,
    };
  }

  @override
  String toString() {
    return 'ResetTokenData{expiresIn: $expiresIn, resetToken: $resetToken}';
  }
}