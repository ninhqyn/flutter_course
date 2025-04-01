part of 'course_by_category_bloc.dart';

@immutable
sealed class CourseByCategoryEvent {}
final class FetchDataCourseByCategory extends CourseByCategoryEvent{
  final int categoryId;

  FetchDataCourseByCategory(this.categoryId);
}