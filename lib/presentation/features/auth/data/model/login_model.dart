// lib/features/auth/data/models/auth_models.dart
import 'dart:convert';


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


class LoginModel {
    final bool? success;
    final String? message;
    final LoginResponse? data;

    LoginModel({
        this.success,
        this.message,
        this.data,
    });

    factory LoginModel.fromRawJson(String str) => LoginModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : LoginResponse.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
    };
}

class LoginResponse {
    final String? accessExpiresIn;
    final String? accessToken;
    final String? refreshExpiresIn;
    final String? refreshToken;
    final String? tokenType;
    final User? user;

    LoginResponse({
        this.accessExpiresIn,
        this.accessToken,
        this.refreshExpiresIn,
        this.refreshToken,
        this.tokenType,
        this.user,
    });

    factory LoginResponse.fromRawJson(String str) => LoginResponse.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        accessExpiresIn: json["access_expires_in"],
        accessToken: json["access_token"],
        refreshExpiresIn: json["refresh_expires_in"],
        refreshToken: json["refresh_token"],
        tokenType: json["token_type"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "access_expires_in": accessExpiresIn,
        "access_token": accessToken,
        "refresh_expires_in": refreshExpiresIn,
        "refresh_token": refreshToken,
        "token_type": tokenType,
        "user": user?.toJson(),
    };
}

class User {
    final int? age;
    final String? bio;
    final String? city;
    final String? country;
    final String? coverImage;
    final DateTime? createdAt;
    final DateTime? dateOfBirth;
    final String? education;
    final String? email;
    final String? firstName;
    final String? gender;
    final int? id;
    final List<String>? interests;
    final bool? isActive;
    final DateTime? lastActive;
    final String? lastName;
    final int? likesReceived;
    final String? lookingFor;
    final int? matchesCount;
    final String? phone;
    final String? profession;
    final String? profileImage;
    final int? profileViews;
    final bool? verified;

    User({
        this.age,
        this.bio,
        this.city,
        this.country,
        this.coverImage,
        this.createdAt,
        this.dateOfBirth,
        this.education,
        this.email,
        this.firstName,
        this.gender,
        this.id,
        this.interests,
        this.isActive,
        this.lastActive,
        this.lastName,
        this.likesReceived,
        this.lookingFor,
        this.matchesCount,
        this.phone,
        this.profession,
        this.profileImage,
        this.profileViews,
        this.verified,
    });

    factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory User.fromJson(Map<String, dynamic> json) => User(
        age: json["age"],
        bio: json["bio"],
        city: json["city"],
        country: json["country"],
        coverImage: json["cover_image"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        dateOfBirth: json["date_of_birth"] == null ? null : DateTime.parse(json["date_of_birth"]),
        education: json["education"],
        email: json["email"],
        firstName: json["first_name"],
        gender: json["gender"],
        id: json["id"],
        interests: json["interests"] == null ? [] : List<String>.from(json["interests"]!.map((x) => x)),
        isActive: json["is_active"],
        lastActive: json["last_active"] == null ? null : DateTime.parse(json["last_active"]),
        lastName: json["last_name"],
        likesReceived: json["likes_received"],
        lookingFor: json["looking_for"],
        matchesCount: json["matches_count"],
        phone: json["phone"],
        profession: json["profession"],
        profileImage: json["profile_image"],
        profileViews: json["profile_views"],
        verified: json["verified"],
    );

    Map<String, dynamic> toJson() => {
        "age": age,
        "bio": bio,
        "city": city,
        "country": country,
        "cover_image": coverImage,
        "created_at": createdAt?.toIso8601String(),
        "date_of_birth": dateOfBirth?.toIso8601String(),
        "education": education,
        "email": email,
        "first_name": firstName,
        "gender": gender,
        "id": id,
        "interests": interests == null ? [] : List<dynamic>.from(interests!.map((x) => x)),
        "is_active": isActive,
        "last_active": lastActive?.toIso8601String(),
        "last_name": lastName,
        "likes_received": likesReceived,
        "looking_for": lookingFor,
        "matches_count": matchesCount,
        "phone": phone,
        "profession": profession,
        "profile_image": profileImage,
        "profile_views": profileViews,
        "verified": verified,
    };
}
