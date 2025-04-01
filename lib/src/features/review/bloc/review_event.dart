part of 'review_bloc.dart';

@immutable
sealed class ReviewEvent {}
final class ReviewFetchData extends ReviewEvent{
  final int courseId;

  ReviewFetchData(this.courseId);
}
final class AddReview extends ReviewEvent{
  final String review;
  AddReview(this.review);
}
