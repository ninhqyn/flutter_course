part of 'course_detail_bloc.dart';

@immutable
sealed class CourseDetailState extends Equatable{}

final class CourseDetailInitial extends CourseDetailState {
  @override
  List<Object?> get props =>[];
}
final class CourseDetailLoading extends CourseDetailState{
  @override
  List<Object?> get props => [];
}
final class CourseDetailEnrollSuccess extends CourseDetailState{
  @override
  List<Object?> get props => [];
}
final class CourseDetailEnroll extends CourseDetailState{
  @override
  List<Object?> get props => [];
}
final class CourseDetailLoaded extends CourseDetailState{
  final int courseId;
  final List<Skill> skills;
  final List<Instructor> instructors;
  final List<Module> modules;
  final List<Course> courses;
  final RatingTotal rating;
  final bool isEnrollment;
  CourseDetailLoaded({
    required this.courseId,
    required this.skills,
    required this.instructors,
    required this.modules,
    required this.courses,
    required this.rating,
    this.isEnrollment = false
});
  CourseDetailLoaded copyWith({
    int? courseId,
    List<Skill>? skills,
    List<Instructor>? instructors,
    List<Module>? modules,
    List<Course>? courses,
    RatingTotal? rating,
    bool? isEnrollment
}){
    return CourseDetailLoaded(
        courseId: courseId ?? this.courseId,
        skills: skills ?? this.skills,
        instructors: instructors ?? this.instructors,
        modules: modules ?? this.modules,
        courses: courses ?? this.courses,
        rating: rating ?? this.rating,
        isEnrollment: isEnrollment ?? this.isEnrollment
    );
  }
  @override
  List<Object?> get props => [
    courseId,
    skills,
    instructors,
    modules,
    courses,
    rating,
    isEnrollment
  ];
}
final class CourseDetailError extends CourseDetailState{
  final String message;

  CourseDetailError({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}