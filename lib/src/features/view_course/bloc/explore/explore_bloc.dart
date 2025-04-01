import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:learning_app/src/data/repositories/category_repository.dart';
import 'package:learning_app/src/data/repositories/course_repository.dart';

import 'package:learning_app/src/shared/models/category.dart';
import 'package:learning_app/src/shared/models/course.dart';
import 'package:meta/meta.dart';

part 'explore_event.dart';
part 'explore_state.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  final CourseRepository courseRepository;
  final CategoryRepository categoryRepository;

  ExploreBloc({
    required this.courseRepository,
    required this.categoryRepository,
  }) : super(ExploreInitial()) {
    on<FetchDataExplore>(_onFetchDataExplore);
  }

  Future<void> _onFetchDataExplore(FetchDataExplore event, Emitter<ExploreState> emit) async {
    emit(ExploreLoading());

    try {
      final results = await Future.wait([
        courseRepository.getAllCourse(),
        categoryRepository.getAllCategory(),
      ]);
      final courses = results[0] as List<Course>;
      final categories = results[1] as List<Category>;
      emit(ExploreLoaded(courses: courses, categories: categories));
      print('fetch explore success');
    } catch (e) {

      emit(ExploreError(e.toString()));
      print(e.toString());
    }
  }
}
