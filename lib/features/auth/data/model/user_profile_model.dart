import 'dart:convert';

UserProfileModel userProfileModelFromJson(String str) => UserProfileModel.fromJson(json.decode(str));

String userProfileModelToJson(UserProfileModel data) => json.encode(data.toJson());

class UserProfileModel {
    final bool? success;
    final String? message;
    final UserProfileResponse? data;

    UserProfileModel({
        this.success,
        this.message,
        this.data,
    });

    factory UserProfileModel.fromJson(Map<String, dynamic> json) => UserProfileModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : UserProfileResponse.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
    };
}

class UserProfileResponse {
    final User? user;

    UserProfileResponse({
        this.user,
    });

    factory UserProfileResponse.fromJson(Map<String, dynamic> json) => UserProfileResponse(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
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
    final int? distancePreference;
    final String? education;
    final String? email;
    final bool? emailNotifications;
    final String? firstName;
    final String? gender;
    final String? genderPreference;
    final int? id;
    final String? instagram;
    final List<String>? interests;
    final bool? isActive;
    final DateTime? lastActive;
    final String? lastName;
    final int? latitude;
    final int? likesReceived;
    final int? longitude;
    final String? lookingFor;
    final int? matchesCount;
    final int? maxAgePreference;
    final int? minAgePreference;
    final String? phone;
    final String? profession;
    final String? profileImage;
    final int? profileViews;
    final bool? pushNotifications;
    final bool? showDistance;
    final bool? showOnlineStatus;
    final String? twitter;
    final int? unreadCount;
    final DateTime? updatedAt;
    final bool? verified;

    User({
        this.age,
        this.bio,
        this.city,
        this.country,
        this.coverImage,
        this.createdAt,
        this.dateOfBirth,
        this.distancePreference,
        this.education,
        this.email,
        this.emailNotifications,
        this.firstName,
        this.gender,
        this.genderPreference,
        this.id,
        this.instagram,
        this.interests,
        this.isActive,
        this.lastActive,
        this.lastName,
        this.latitude,
        this.likesReceived,
        this.longitude,
        this.lookingFor,
        this.matchesCount,
        this.maxAgePreference,
        this.minAgePreference,
        this.phone,
        this.profession,
        this.profileImage,
        this.profileViews,
        this.pushNotifications,
        this.showDistance,
        this.showOnlineStatus,
        this.twitter,
        this.unreadCount,
        this.updatedAt,
        this.verified,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        age: json["age"],
        bio: json["bio"],
        city: json["city"],
        country: json["country"],
        coverImage: json["cover_image"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        dateOfBirth: json["date_of_birth"] == null ? null : DateTime.parse(json["date_of_birth"]),
        distancePreference: json["distance_preference"],
        education: json["education"],
        email: json["email"],
        emailNotifications: json["email_notifications"],
        firstName: json["first_name"],
        gender: json["gender"],
        genderPreference: json["gender_preference"],
        id: json["id"],
        instagram: json["instagram"],
        interests: json["interests"] == null ? [] : List<String>.from(json["interests"]!.map((x) => x)),
        isActive: json["is_active"],
        lastActive: json["last_active"] == null ? null : DateTime.parse(json["last_active"]),
        lastName: json["last_name"],
        latitude: json["latitude"],
        likesReceived: json["likes_received"],
        longitude: json["longitude"],
        lookingFor: json["looking_for"],
        matchesCount: json["matches_count"],
        maxAgePreference: json["max_age_preference"],
        minAgePreference: json["min_age_preference"],
        phone: json["phone"],
        profession: json["profession"],
        profileImage: json["profile_image"],
        profileViews: json["profile_views"],
        pushNotifications: json["push_notifications"],
        showDistance: json["show_distance"],
        showOnlineStatus: json["show_online_status"],
        twitter: json["twitter"],
        unreadCount: json["unread_count"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
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
        "distance_preference": distancePreference,
        "education": education,
        "email": email,
        "email_notifications": emailNotifications,
        "first_name": firstName,
        "gender": gender,
        "gender_preference": genderPreference,
        "id": id,
        "instagram": instagram,
        "interests": interests == null ? [] : List<dynamic>.from(interests!.map((x) => x)),
        "is_active": isActive,
        "last_active": lastActive?.toIso8601String(),
        "last_name": lastName,
        "latitude": latitude,
        "likes_received": likesReceived,
        "longitude": longitude,
        "looking_for": lookingFor,
        "matches_count": matchesCount,
        "max_age_preference": maxAgePreference,
        "min_age_preference": minAgePreference,
        "phone": phone,
        "profession": profession,
        "profile_image": profileImage,
        "profile_views": profileViews,
        "push_notifications": pushNotifications,
        "show_distance": showDistance,
        "show_online_status": showOnlineStatus,
        "twitter": twitter,
        "unread_count": unreadCount,
        "updated_at": updatedAt?.toIso8601String(),
        "verified": verified,
    };
}
