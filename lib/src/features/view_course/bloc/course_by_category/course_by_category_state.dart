part of 'course_by_category_bloc.dart';

enum FetchStatus {
  initial,
  success,
  failure,
  loadingMore
}
final class CourseByCategoryState extends Equatable{
  final FetchStatus status;
  final List<Course> courses;
  final bool hasReachedMax;
  const CourseByCategoryState({
   this.status = FetchStatus.initial,
   this.courses = const<Course>[],
   this.hasReachedMax = false
});
  CourseByCategoryState copyWith({
    FetchStatus? status,
    List<Course>? courses,
    bool? hasReachedMax
}){
    return CourseByCategoryState(
      status: status ?? this.status,
      courses: courses ?? this.courses,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax
    );
}
  @override
  // TODO: implement props
  List<Object?> get props => [status,courses,hasReachedMax];
}

