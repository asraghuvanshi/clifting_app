class User {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String? bio;
  final String? city;
  final String? country;
  final DateTime? createdAt;
  final DateTime? dateOfBirth;
  final String? education;
  final String? gender;
  final List<String>? interests;
  final DateTime? lastLoginAt;
  final String? lookingFor;
  final String? phone;
  final String? profession;
  final bool? verified;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.bio,
    this.city,
    this.country,
    this.createdAt,
    this.dateOfBirth,
    this.education,
    this.gender,
    this.interests,
    this.lastLoginAt,
    this.lookingFor,
    this.phone,
    this.profession,
    this.verified,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      bio: json['bio'],
      city: json['city'],
      country: json['country'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'])
          : null,
      education: json['education'],
      gender: json['gender'],
      interests: json['interests'] != null
          ? List<String>.from(json['interests'])
          : null,
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.parse(json['last_login_at'])
          : null,
      lookingFor: json['looking_for'],
      phone: json['phone'],
      profession: json['profession'],
      verified: json['verified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'bio': bio,
      'city': city,
      'country': country,
      'created_at': createdAt?.toIso8601String(),
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'education': education,
      'gender': gender,
      'interests': interests,
      'last_login_at': lastLoginAt?.toIso8601String(),
      'looking_for': lookingFor,
      'phone': phone,
      'profession': profession,
      'verified': verified,
    };
  }
}

class AuthResponse {
  final bool success;
  final String message;
  final AuthData data;

  AuthResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'],
      message: json['message'],
      data: AuthData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }
}

class AuthData {
  final String accessExpiresIn;
  final String accessToken;
  final String refreshExpiresIn;
  final String refreshToken;
  final String tokenType;
  final User user;

  AuthData({
    required this.accessExpiresIn,
    required this.accessToken,
    required this.refreshExpiresIn,
    required this.refreshToken,
    required this.tokenType,
    required this.user,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      accessExpiresIn: json['access_expires_in'],
      accessToken: json['access_token'],
      refreshExpiresIn: json['refresh_expires_in'],
      refreshToken: json['refresh_token'],
      tokenType: json['token_type'],
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_expires_in': accessExpiresIn,
      'access_token': accessToken,
      'refresh_expires_in': refreshExpiresIn,
      'refresh_token': refreshToken,
      'token_type': tokenType,
      'user': user.toJson(),
    };
  }
}

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}
