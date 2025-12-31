import 'dart:convert';

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

ForgotPasswordResponse forgotPasswordResponseFromJson(String str) => ForgotPasswordResponse.fromJson(json.decode(str));

String forgotPasswordResponseToJson(ForgotPasswordResponse data) => json.encode(data.toJson());

class ForgotPasswordResponse {
    final bool success;
    final String message;
    final ForgotPasswordData data;

    ForgotPasswordResponse({
        required this.success,
        required this.message,
        required this.data,
    });

    ForgotPasswordResponse copyWith({
        bool? success,
        String? message,
        ForgotPasswordData? data,
    }) => 
        ForgotPasswordResponse(
            success: success ?? this.success,
            message: message ?? this.message,
            data: data ?? this.data,
        );

    factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) => ForgotPasswordResponse(
        success: json["success"],
        message: json["message"],
        data: ForgotPasswordData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
    };
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

    ForgotPasswordData copyWith({
        String? email,
        String? expiresIn,
        String? resendAfter,
    }) => 
        ForgotPasswordData(
            email: email ?? this.email,
            expiresIn: expiresIn ?? this.expiresIn,
            resendAfter: resendAfter ?? this.resendAfter,
        );

    factory ForgotPasswordData.fromJson(Map<String, dynamic> json) => ForgotPasswordData(
        email: json["email"],
        expiresIn: json["expires_in"],
        resendAfter: json["resend_after"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "expires_in": expiresIn,
        "resend_after": resendAfter,
    };
}
