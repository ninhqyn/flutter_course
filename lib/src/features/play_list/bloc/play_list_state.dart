part of 'play_list_bloc.dart';

@immutable
abstract class PlayListState {}

class PlayListInitial extends PlayListState {}

class PlayListLoading extends PlayListState {}

class PlayListLoaded extends PlayListState {
  final Lesson? lesson;
  final Module? module;
  final List<Module> modules;

  PlayListLoaded({
    required this.lesson,
    required this.module,
    required this.modules,
  });
}

class PlayListError extends PlayListState {
  final String message;

  PlayListError({required this.message});
}