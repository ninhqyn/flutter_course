part of 'review_bloc.dart';

@immutable
sealed class ReviewState {}

final class ReviewInitial extends ReviewState {}
final class ReviewLoading extends ReviewState{}
final class ReviewLoaded extends ReviewState{
  final Course course;
  final List<Rating> ratings;
  final RatingTotal ratingTotal;

  ReviewLoaded({
    required this.course,
    required this.ratings,
    required this.ratingTotal
});
}
