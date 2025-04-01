class RatingTotal {
  int courseId;
  double ratingValue;
  int totalRating;

  RatingTotal({
    required this.courseId,
    required this.ratingValue,
    required this.totalRating,
  });

  factory RatingTotal.fromJson(Map<String, dynamic> json) {
    return RatingTotal(
      courseId: json['courseId'],
      ratingValue: json['ratingValue'],
      totalRating: json['totalRating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'ratingValue': ratingValue,
      'totalRating': totalRating,
    };
  }
}
