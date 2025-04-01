class Category {
  int categoryId;
  String categoryName;
  String description;
  String? imageUrl;
  int? parentCategoryId;
  DateTime createdAt;
  DateTime updatedAt;

  Category({
    required this.categoryId,
    required this.categoryName,
    required this.description,
     this.imageUrl,
    this.parentCategoryId,
    required this.createdAt,
    required this.updatedAt,
  });

  // Hàm fromJson
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      parentCategoryId: json['parentCategoryId'] ,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Hàm toJson
  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'description': description,
      'imageUrl' : imageUrl,
      'parentCategoryId': parentCategoryId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
