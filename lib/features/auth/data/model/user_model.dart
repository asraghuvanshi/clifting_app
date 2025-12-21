class UserModel {
  final bool success;
  final String message;
  final UserResponse? data;

  UserModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] != null
          ? UserResponse.fromJson(json['data'] as Map<String, dynamic>)
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
}

class UserResponse {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final String? profileImage;
  final String? coverImage;
  final String? bio;
  final String? city;
  final String? country;
  final String? profession;
  final String? education;
  final String? gender;
  final String? genderPreference;
  final String? lookingFor;
  final int? minAgePreference;
  final int? maxAgePreference;
  final int? distancePreference;
  final bool? showDistance;
  final bool? showOnlineStatus;
  final bool? pushNotifications;
  final bool? emailNotifications;
  final bool? verified;
  final bool? isActive;
  final String? phoneNumber;
  final double? latitude;
  final double? longitude;
  final String? instagramHandle;
  final String? twitter;
  final int? likesReceived;
  final int? profileViews;
  final int? matchesCount;
  final int? unreadCount;
  final DateTime? lastActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> interests;
  final int? age;

  UserResponse({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    this.profileImage,
    this.coverImage,
    this.bio,
    this.city,
    this.country,
    this.profession,
    this.education,
    this.gender,
    this.genderPreference,
    this.lookingFor,
    this.minAgePreference,
    this.maxAgePreference,
    this.distancePreference,
    this.showDistance,
    this.showOnlineStatus,
    this.pushNotifications,
    this.emailNotifications,
    this.verified,
    this.isActive,
    this.phoneNumber,
    this.latitude,
    this.longitude,
    this.instagramHandle,
    this.twitter,
    this.likesReceived,
    this.profileViews,
    this.matchesCount,
    this.unreadCount,
    this.lastActive,
    required this.createdAt,
    required this.updatedAt,
    required this.interests,
    this.age,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'] as int,
      email: json['email'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      dateOfBirth: DateTime.parse(json['date_of_birth'] as String),
      profileImage: json['profile_image'] as String?,
      coverImage: json['cover_image'] as String?,
      bio: json['bio'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      profession: json['profession'] as String?,
      education: json['education'] as String?,
      gender: json['gender'] as String?,
      genderPreference: json['gender_preference'] as String?,
      lookingFor: json['looking_for'] as String?,
      minAgePreference: json['min_age_preference'] as int?,
      maxAgePreference: json['max_age_preference'] as int?,
      distancePreference: json['distance_preference'] as int?,
      showDistance: json['show_distance'] as bool?,
      showOnlineStatus: json['show_online_status'] as bool?,
      pushNotifications: json['push_notifications'] as bool?,
      emailNotifications: json['email_notifications'] as bool?,
      verified: json['verified'] as bool?,
      isActive: json['is_active'] as bool?,
      phoneNumber: json['phone'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      instagramHandle: json['instagram'] as String?,
      twitter: json['twitter'] as String?,
      likesReceived: json['likes_received'] as int?,
      profileViews: json['profile_views'] as int?,
      matchesCount: json['matches_count'] as int?,
      unreadCount: json['unread_count'] as int?,
      lastActive: json['last_active'] != null 
          ? DateTime.parse(json['last_active'] as String) 
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      interests: (json['interests'] as List<dynamic>).cast<String>(),
      age: json['age'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'date_of_birth': dateOfBirth.toIso8601String(),
      'profile_image': profileImage,
      'cover_image': coverImage,
      'bio': bio,
      'city': city,
      'country': country,
      'profession': profession,
      'education': education,
      'gender': gender,
      'gender_preference': genderPreference,
      'looking_for': lookingFor,
      'min_age_preference': minAgePreference,
      'max_age_preference': maxAgePreference,
      'distance_preference': distancePreference,
      'show_distance': showDistance,
      'show_online_status': showOnlineStatus,
      'push_notifications': pushNotifications,
      'email_notifications': emailNotifications,
      'verified': verified,
      'is_active': isActive,
      'phone': phoneNumber,
      'latitude': latitude,
      'longitude': longitude,
      'instagram': instagramHandle,
      'twitter': twitter,
      'likes_received': likesReceived,
      'profile_views': profileViews,
      'matches_count': matchesCount,
      'unread_count': unreadCount,
      'last_active': lastActive?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'interests': interests,
      'age': age,
    };
  }

  String get fullName => '$firstName $lastName';
  
  bool get hasProfileImage => profileImage != null && profileImage!.isNotEmpty;
  
  bool get hasCoverImage => coverImage != null && coverImage!.isNotEmpty;
  
  String? get displayLocation {
    if (city != null && country != null) return '$city, $country';
    if (city != null) return city;
    if (country != null) return country;
    return null;
  }
  
  List<String> get displayInterests => interests.take(3).toList();
}