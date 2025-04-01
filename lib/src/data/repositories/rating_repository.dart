

import 'package:learning_app/src/data/services/rating_service.dart';
import 'package:learning_app/src/shared/models/rating.dart';
import 'package:learning_app/src/shared/models/rating_total.dart';


class RatingRepository{
  final RatingService ratingService;
  RatingRepository({
    required this.ratingService
  });
  Future<RatingTotal> getRatingTotalCourseId(int courseId) async{
    final results = await ratingService.getRatingTotalByCourseId(courseId);
    return results;
  }
  Future<List<Rating>> getAllRating(int courseId,{int page = 1, int pageSize = 10}) async{
    final results = await  ratingService.getAllRatingByCourseId(courseId,page: page,pageSize: pageSize);
    return results;
  }

}