part of 'explore_bloc.dart';

@immutable
sealed class ExploreState extends Equatable{}

final class ExploreInitial extends ExploreState {
  @override
  List<Object?> get props =>[];
}
final class ExploreLoading extends ExploreState{
  @override
  List<Object?> get props => [];
}
final class ExploreError extends ExploreState{
  final String errorMessage;

  ExploreError(this.errorMessage);

  @override
  // TODO: implement props
  List<Object?> get props => [errorMessage];
}
final class ExploreLoaded extends ExploreState{
  final List<Course> courses;
  final List<Category> categories;

  ExploreLoaded({
    required this.courses,
    required this.categories
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    courses,categories
  ];

}
