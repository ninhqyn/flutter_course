import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:learning_app/src/core/constants/type_constants.dart';
import 'package:learning_app/src/data/repositories/course_repository.dart';

import 'package:learning_app/src/shared/models/course.dart';
import 'package:meta/meta.dart';

part 'all_item_event.dart';
part 'all_item_state.dart';

class AllItemBloc extends Bloc<AllItemEvent, AllItemState> {
  final CourseRepository courseRepository;
  int _currentPage = 1;
  static const int _pageSize = 5;

  AllItemBloc({
    required this.courseRepository
  }) : super(AllItemInitial()) {
    on<FetchDataAllItem>(_onFetchData);
  }

  Future<void> _onFetchData(FetchDataAllItem event, Emitter<AllItemState> emit) async {
    if(event.constant == TypeConstant.courseSuggest ||
        event.constant == TypeConstant.courseFavorite) {

      try {
        // Trường hợp đầu tiên khi load
        if(state is AllItemInitial) {
          emit(AllItemLoading());
          final courses = await _fetchCourses(event.constant);
          return emit(AllItemLoaded(
              courses: courses,
              hasMax: courses.length < _pageSize
          ));
        }

        if(state is AllItemLoaded) {
          final currentState = state as AllItemLoaded;
          if(currentState.hasMax) return;

          // Emit trạng thái đang tải thêm
          emit(AllItemLoadMore(
              courses: currentState.courses,
              hasMax: currentState.hasMax
          ));

          await Future.delayed(const Duration(seconds: 1));

          _currentPage++;
          final newCourses = await _fetchCourses(event.constant);

          return emit(AllItemLoaded(
              courses: List.of(currentState.courses)..addAll(newCourses),
              hasMax: newCourses.length < _pageSize
          ));
        }
      } catch (error) {
        emit(AllItemError('Đã xảy ra lỗi: ${error.toString()}'));
      }
    }
  }

  Future<List<Course>> _fetchCourses(String constant) async {
    if (constant == TypeConstant.courseSuggest) {
      return await courseRepository.getAllCourseNew(page: _currentPage, pageSize: _pageSize);
    } else {
      return await courseRepository.getAllCourseFavorites(page: _currentPage, pageSize: _pageSize);
    }
  }
}