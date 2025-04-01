import 'dart:convert';

class Skill {
  int skillId;
  String skillName;
  String description;
  DateTime createdAt;
  DateTime updatedAt;

  // Constructor
  Skill({
    required this.skillId,
    required this.skillName,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });
  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      skillId: json['skillId'],
      skillName: json['skillName'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'skillId': skillId,
      'skillName': skillName,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

