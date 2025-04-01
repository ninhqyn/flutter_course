import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:learning_app/src/data/repositories/course_repository.dart';

import 'package:learning_app/src/shared/models/course.dart';

import 'package:meta/meta.dart';
import 'dart:async';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:stream_transform/stream_transform.dart';

part 'course_by_category_event.dart';
part 'course_by_category_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}
class CourseByCategoryBloc extends Bloc<CourseByCategoryEvent, CourseByCategoryState> {
  final CourseRepository courseRepository;
  int _currentPage = 1;
  static const int _pageSize =10;
  CourseByCategoryBloc({
    required this.courseRepository
}) : super(const CourseByCategoryState()) {
    on<FetchDataCourseByCategory>(_onFetchData,transformer: throttleDroppable(throttleDuration));
  }


  Future<void> _onFetchData(FetchDataCourseByCategory event,Emitter<CourseByCategoryState> emit) async{
    if(state.hasReachedMax) return;
    try{
       //
       if(state.status == FetchStatus.initial){
         final courses = await courseRepository.getCourseByCategoryId(event.categoryId,
             page: _currentPage,
             pageSize: _pageSize);
         if(courses.isEmpty){
           return emit(state.copyWith(hasReachedMax: true));
         }
         emit(
             state.copyWith(
                 status: FetchStatus.success,
                 courses: courses
             )
         );
         print(event.categoryId);
         return emit(state.copyWith(
           status: FetchStatus.success,
           courses: courses,
           hasReachedMax: courses.length < _pageSize,
         ));
       }
       _currentPage++;
       emit(state.copyWith(status: FetchStatus.loadingMore));
       final courses = await courseRepository.getCourseByCategoryId(
           event.categoryId, page: _currentPage, pageSize: _pageSize);

       if (courses.isEmpty) {
         return emit(state.copyWith(hasReachedMax: true, status: FetchStatus.success));
       }

       emit(state.copyWith(
         status: FetchStatus.success,
         courses: List.of(state.courses)..addAll(courses),
         hasReachedMax: courses.length < _pageSize,
       ));
    }catch(_){
      emit(state.copyWith(status: FetchStatus.failure));
    }
  }
}
