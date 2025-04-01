part of 'my_course_bloc.dart';

@immutable
sealed class MyCourseState {}

final class MyCourseInitial extends MyCourseState {}
final class MyCourseLoading extends MyCourseState{}
final class MyCourseLoaded extends MyCourseState{
  final List<UserCourse> myCourse;

  MyCourseLoaded({required this.myCourse});
}
