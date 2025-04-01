part of 'my_course_detail_bloc.dart';

@immutable
sealed class MyCourseDetailState {}

final class MyCourseDetailInitial extends MyCourseDetailState {}
final class MyCourseDetailLoaded extends MyCourseDetailState{
  final Course course;
  final List<UserModule> modules;
  final List<Quiz> quizzes;
  MyCourseDetailLoaded({required this.modules,required this.course,required this.quizzes});
}
final class MyCourseDetailLoading extends MyCourseDetailState{}
