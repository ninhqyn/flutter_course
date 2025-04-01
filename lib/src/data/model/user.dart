class User {
  int userId;
  String email;
  String? phoneNumber;
  String? displayName;
  String? photoUrl;
  bool? emailVerified;
  bool? phoneVerified;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;

  User({
    required this.userId,
    required this.email,
    this.phoneNumber,
    this.displayName,
    this.photoUrl,
    this.emailVerified,
    this.phoneVerified,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  // Factory method to create a UserModel from a JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] as int,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      emailVerified: json['emailVerified'] as bool?,
      phoneVerified: json['phoneVerified'] as bool?,
      isActive: json['isActive'] as bool?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  // Method to convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'phoneNumber': phoneNumber,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'emailVerified': emailVerified,
      'phoneVerified': phoneVerified,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
