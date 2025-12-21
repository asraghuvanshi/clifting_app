// lib/features/auth/data/models/auth_models.dart
import 'package:clifting_app/features/auth/data/model/verify_reset_password_otp.dart';

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
  };
}


class ChangePasswordRequest {
  final String token;
  final String password;

  ChangePasswordRequest({
    required this.token,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'reset_token': token,
    'new_password': password,
  };
}



class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String gender;
  final DateTime? dateOfBirth;
  final int? age;
  final String city;
  final String country;
  final String profession;
  final String education;
  final String bio;
  final String lookingFor;
  final List<String> interests;
  final String? profileImage;
  final String? coverImage;
  final bool verified;
  final bool isActive;
  final DateTime? lastActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    required this.gender,
    this.dateOfBirth,
    this.age,
    required this.city,
    required this.country,
    required this.profession,
    required this.education,
    required this.bio,
    required this.lookingFor,
    required this.interests,
    this.profileImage,
    this.coverImage,
    required this.verified,
    required this.isActive,
    this.lastActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      gender: json['gender'] ?? '',
      dateOfBirth: json['date_of_birth'] != null 
          ? DateTime.parse(json['date_of_birth']) 
          : null,
      age: json['age'],
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      profession: json['profession'] ?? '',
      education: json['education'] ?? '',
      bio: json['bio'] ?? '',
      lookingFor: json['looking_for'] ?? '',
      interests: (json['interests'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? [],
      profileImage: json['profile_image'],
      coverImage: json['cover_image'],
      verified: json['verified'] ?? false,
      isActive: json['is_active'] ?? true,
      lastActive: json['last_active'] != null 
          ? DateTime.parse(json['last_active']) 
          : null,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'phone': phone,
    'gender': gender,
    'date_of_birth': dateOfBirth?.toIso8601String(),
    'age': age,
    'city': city,
    'country': country,
    'profession': profession,
    'education': education,
    'bio': bio,
    'looking_for': lookingFor,
    'interests': interests,
    'profile_image': profileImage,
    'cover_image': coverImage,
    'verified': verified,
    'is_active': isActive,
    'last_active': lastActive?.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  String get fullName => '$firstName $lastName';
}

class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final String accessExpiresIn;
  final String refreshExpiresIn;
  final User user;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.accessExpiresIn,
    required this.refreshExpiresIn,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      tokenType: json['token_type'] ?? 'Bearer',
      accessExpiresIn: json['access_expires_in'] ?? '',
      refreshExpiresIn: json['refresh_expires_in'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
    );
  }
}