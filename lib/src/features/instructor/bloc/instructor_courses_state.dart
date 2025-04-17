part of 'instructor_courses_bloc.dart';

@immutable
abstract class InstructorCoursesState extends Equatable {
  const InstructorCoursesState();

  @override
  List<Object> get props => [];
}

class InstructorCoursesInitial extends InstructorCoursesState {}

class InstructorCoursesLoading extends InstructorCoursesState {}

class InstructorCoursesLoaded extends InstructorCoursesState {
  final List<Course> courses;

  const InstructorCoursesLoaded(this.courses);

  @override
  List<Object> get props => [courses];
}

class InstructorCoursesError extends InstructorCoursesState {
  final String message;

  const InstructorCoursesError(this.message);

  @override
  List<Object> get props => [message];
}
