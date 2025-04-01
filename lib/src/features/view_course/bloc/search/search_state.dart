part of 'search_bloc.dart';

@immutable
sealed class SearchState extends Equatable{}

final class SearchInitial extends SearchState {
  @override
  List<Object?> get props => [];
}

final class SearchLoaded extends SearchState{
  final List<Category> categories;
  final List<Course>? filterCourses;
  final int categorySelected;
  final String? keyword;
  SearchLoaded({
    required this.categories,
    this.filterCourses,
    this.categorySelected=0,
    this.keyword
  });
  SearchLoaded copyWith({
    List<Category>? categories,
    List<Course>? filterCourses,
    int? categorySelected,
    String? keyword
}){
    return SearchLoaded(
        categories: categories ?? this.categories,
      filterCourses: filterCourses ?? this.filterCourses,
      categorySelected: categorySelected ?? this.categorySelected,
      keyword: keyword ?? this.keyword
    );
  }
  @override
  List<Object?> get props => [categories,filterCourses,categorySelected,keyword];
}
final class SearchLoading extends SearchState{
  @override
  List<Object?> get props => [];
}
