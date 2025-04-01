part of 'search_bloc.dart';

@immutable
sealed class SearchEvent {}
final class FetchDataSearch extends SearchEvent{}
final class TextSearchChanged extends SearchEvent{
  final String inputText;
  TextSearchChanged(this.inputText);
}
final class SearchCategorySelected extends SearchEvent{
  final int categoryId;
  final int index;

  SearchCategorySelected({required this.categoryId,required this.index});
}