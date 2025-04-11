part of 'play_list_bloc.dart';

@immutable
sealed class PlayListEvent {}

final class FetchDataPlayList extends PlayListEvent {
  final int courseId;
  final int lessonId;
  final int moduleId;

  FetchDataPlayList({
    required this.courseId,
    required this.lessonId,
    required this.moduleId
  });
}

final class SelectedModule extends PlayListEvent {
  final int moduleId;
  final List<Module> modules;

  SelectedModule({
    required this.moduleId,
    required this.modules,
  });
}

final class SelectedLesson extends PlayListEvent {
  final int lessonId;
  final Module currentModule;

  SelectedLesson({
    required this.lessonId,
    required this.currentModule,
  });
}
final class VideoFinished extends PlayListEvent {
  final Module currentModule;
  final Lesson currentLesson;
  final List<Module> allModules;
  final int courseId;

  VideoFinished({
    required this.currentModule,
    required this.currentLesson,
    required this.allModules,
    required this.courseId
  });
}