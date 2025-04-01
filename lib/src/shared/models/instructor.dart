class Instructor {
  final int instructorId;
  final String? bio;
  final String? specialization;
  final String? websiteUrl;
  final String? linkedinUrl;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String instructorName;
  final String? photoUrl;

  // Constructor
  Instructor({
    required this.instructorId,
    this.bio,
    this.specialization,
    this.websiteUrl,
    this.linkedinUrl,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
    required this.instructorName,
    this.photoUrl,
  });

  // fromJson: Convert a JSON map into an Instructor object
  factory Instructor.fromJson(Map<String, dynamic> json) {
    return Instructor(
      instructorId: json['instructorId'],
      bio: json['bio'],
      specialization: json['specialization'],
      websiteUrl: json['websiteUrl'],
      linkedinUrl: json['linkedinUrl'],
      isVerified: json['isVerified'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      instructorName: json['instructorName'],
      photoUrl: json['photoUrl'],
    );
  }

  // toJson: Convert an Instructor object into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'instructorId': instructorId,
      'bio': bio,
      'specialization': specialization,
      'websiteUrl': websiteUrl,
      'linkedinUrl': linkedinUrl,
      'isVerified': isVerified,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'instructorName': instructorName,
      'photoUrl': photoUrl,
    };
  }
}
