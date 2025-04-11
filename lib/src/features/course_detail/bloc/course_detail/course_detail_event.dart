part of 'course_detail_bloc.dart';

@immutable
sealed class CourseDetailEvent {}
final class FetchDataCourseDetail extends CourseDetailEvent{
  final int courseId;
  final int categoryId;

  FetchDataCourseDetail(this.courseId,this.categoryId);
}
final class UpdateEnrollment extends CourseDetailEvent{
  final int courseId;

  UpdateEnrollment({required this.courseId});
}
