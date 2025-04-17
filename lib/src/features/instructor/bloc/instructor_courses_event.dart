part of 'instructor_courses_bloc.dart';

@immutable
sealed class InstructorCoursesEvent {}
class FetchInstructorCourses extends InstructorCoursesEvent {
  final int instructorId;
  FetchInstructorCourses(this.instructorId);
}