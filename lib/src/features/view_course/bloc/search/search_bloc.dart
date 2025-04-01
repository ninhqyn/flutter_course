import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:learning_app/src/data/repositories/category_repository.dart';
import 'package:learning_app/src/data/repositories/course_repository.dart';

import 'package:learning_app/src/shared/models/category.dart';
import 'package:learning_app/src/shared/models/course.dart';
import 'package:meta/meta.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final CategoryRepository categoryRepository;
  final CourseRepository courseRepository;
  SearchBloc({
    required this.categoryRepository,
    required this.courseRepository
}) : super(SearchInitial()) {
    on<FetchDataSearch>(_onFetchDataEvent);
    on<TextSearchChanged>(_onTextSearchChanged);
    on<SearchCategorySelected>(_onCategorySelected);
  }
  Future<void> _onFetchDataEvent(FetchDataSearch event,Emitter<SearchState> emit) async{
    emit(SearchLoading());
    final categories = await categoryRepository.getAllCategory();
    emit(SearchLoaded(categories:categories));
  }
  Future<void> _onTextSearchChanged(TextSearchChanged event,Emitter<SearchState> emit) async{
    if(state is SearchLoaded){
      print(event.inputText);
      final currentState = state as SearchLoaded;
      final filterCourse = await courseRepository.getFilterCourse(event.inputText);
      final categories = await categoryRepository.getAllCategory();
      final allCategory = Category(
          categoryId: 0,
          categoryName: 'All',
          description: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now());
      List<Category> categoriesAll = [allCategory,...categories];
      if(event.inputText.isNotEmpty){
        emit(currentState.copyWith(filterCourses: filterCourse,keyword: event.inputText,categories: categoriesAll));
      }else{
        emit(currentState.copyWith(filterCourses: filterCourse,keyword: event.inputText,categories: categories));
      }

    }
  }
  Future<void> _onCategorySelected(SearchCategorySelected event,Emitter<SearchState> emit) async{
    if(state is SearchLoaded){
      final currentState = state as SearchLoaded;
      print(event.categoryId);
      print(event.index);
      if(event.categoryId ==0){
        final filterCourse = await courseRepository.getFilterCourse(currentState.keyword!);
        emit(currentState.copyWith(filterCourses: filterCourse,categorySelected: event.index));
      }else{
        final filterCourse = await courseRepository.getFilterCourse(currentState.keyword!,categoryId: event.categoryId);
        emit(currentState.copyWith(filterCourses: filterCourse,categorySelected: event.index));
      }


    }
  }
}
