part of 'my_course_detail_bloc.dart';

@immutable
sealed class MyCourseDetailEvent {}
final class FetchDataMyCourseDetail extends MyCourseDetailEvent{
  final int courseId;

  FetchDataMyCourseDetail(this.courseId);
}
