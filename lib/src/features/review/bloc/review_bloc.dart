import 'package:bloc/bloc.dart';
import 'package:learning_app/src/data/repositories/course_repository.dart';
import 'package:learning_app/src/data/repositories/rating_repository.dart';
import 'package:learning_app/src/shared/models/course.dart';
import 'package:learning_app/src/shared/models/rating.dart';
import 'package:learning_app/src/shared/models/rating_total.dart';
import 'package:meta/meta.dart';

part 'review_event.dart';
part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final RatingRepository _ratingRepository;
  final CourseRepository _courseRepository;
  ReviewBloc(
     RatingRepository ratingRepository,
      CourseRepository courseRepository
) : _ratingRepository = ratingRepository,
        _courseRepository = courseRepository,super(ReviewInitial()) {
    on<ReviewFetchData>(_onFetchDataReview);
  }
  Future<void> _onFetchDataReview(ReviewFetchData event,Emitter<ReviewState> emit )async{
    emit(ReviewLoading());
    final result = await Future.wait([
      _ratingRepository.getAllRating(event.courseId),
      _courseRepository.getCourseById(event.courseId),
      _ratingRepository.getRatingTotalCourseId(event.courseId)
    ]);
    final ratings = result[0] as List<Rating>;
    final course = result[1] as Course;
    final ratingTotal = result[2] as RatingTotal;
    emit(ReviewLoaded(course: course, ratings: ratings,ratingTotal: ratingTotal));
  }
}
