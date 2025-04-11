part of 'my_course_detail_bloc.dart';

@immutable
sealed class MyCourseDetailState extends Equatable{}

final class MyCourseDetailInitial extends MyCourseDetailState {
  @override
  List<Object?> get props => [];
}
final class MyCourseDetailLoaded extends MyCourseDetailState{
  final Course course;
  final List<UserModule> modules;
  final List<Quiz> quizzes;
  MyCourseDetailLoaded({required this.modules,required this.course,required this.quizzes});
  MyCourseDetailLoaded copyWith({
    Course? course,
    List<UserModule>? modules,
    List<Quiz>? quizzes
}){
    return MyCourseDetailLoaded(modules: modules ?? this.modules, course: course ?? this.course, quizzes: quizzes ?? this.quizzes);
}
  @override
  List<Object?> get props => [course,modules,quizzes];
}
final class MyCourseDetailLoading extends MyCourseDetailState{
  @override
  List<Object?> get props => [];
}
