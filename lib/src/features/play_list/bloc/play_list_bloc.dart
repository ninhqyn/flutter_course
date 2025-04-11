import 'package:bloc/bloc.dart';
import 'package:learning_app/src/data/model/post_lesson_progress.dart';
import 'package:learning_app/src/data/repositories/lesson_repository.dart';
import 'package:learning_app/src/data/repositories/module_repository.dart';
import 'package:learning_app/src/shared/models/lesson.dart';
import 'package:learning_app/src/shared/models/module.dart';
import 'package:meta/meta.dart';

part 'play_list_event.dart';
part 'play_list_state.dart';

class PlayListBloc extends Bloc<PlayListEvent, PlayListState> {
  final ModuleRepository moduleRepository;
  final LessonRepository lessonRepository;
  PlayListBloc({
    required this.moduleRepository,
    required this.lessonRepository
  }) : super(PlayListInitial()) {
    on<FetchDataPlayList>(_onFetchDataPlayList);
    on<SelectedModule>(_onSelectedModule);
    on<SelectedLesson>(_onSelectedLesson);
    on<VideoFinished>(_onVideoFinished);
  }

  Future<void> _onFetchDataPlayList(
      FetchDataPlayList event,
      Emitter<PlayListState> emit
      ) async {
    try {
      emit(PlayListLoading());

      final modules = await moduleRepository.getAllModuleByCourseId(event.courseId);
      Module? module;
      Lesson? lesson;

      for (var currentModule in modules) {
        if (event.moduleId == currentModule.moduleId) {
          module = currentModule;
          lesson = currentModule.lessons.firstWhere(
                (l) => l.lessonId == event.lessonId,
            orElse: () => currentModule.lessons.first,
          );
          break;
        }
      }

      emit(PlayListLoaded(
        lesson: lesson,
        module: module,
        modules: modules,
      ));
    } catch (e) {
      emit(PlayListError(message: e.toString()));
    }
  }
  Future<void> _onVideoFinished(
      VideoFinished event,
      Emitter<PlayListState> emit,
      ) async {
    try {
      print('Video finished,update progress.');

      // Cập nhật tiến độ học tập
      if (state is PlayListLoaded) {
        final currentState = state as PlayListLoaded;
        final progress = PostLessonProgress(
          lessonId: currentState.lesson!.lessonId,
          courseId: event.courseId,
          isCompleted: true,
          lastPositionSeconds: 10, // Có thể thay đổi tùy vào logic của bạn
          timeSpentMinutes: 10, // Tính toán thời gian học
        );
        if (await lessonRepository.createOrUpdate(progress)) {
          print('Lesson progress updated');
          emit(PlayListVideoFinished());
          emit(currentState);
        } else {
          print('Failed to update lesson progress');
        }
      }
    } catch (e) {
      emit(PlayListError(message: e.toString()));
    }
  }


  void _onSelectedModule(
      SelectedModule event,
      Emitter<PlayListState> emit
      ) {
    try {
      Module? selectedModule;
      for (var module in event.modules) {
        if (module.moduleId == event.moduleId) {
          selectedModule = module;
          break;
        }
      }

      if (selectedModule != null) {
        emit(PlayListLoaded(
          lesson: selectedModule.lessons.first,
          module: selectedModule,
          modules: event.modules,
        ));
      }
    } catch (e) {
      emit(PlayListError(message: e.toString()));
    }
  }

  void _onSelectedLesson(
      SelectedLesson event,
      Emitter<PlayListState> emit
      ) {
    try {
      final selectedLesson = event.currentModule.lessons.firstWhere(
            (lesson) => lesson.lessonId == event.lessonId,
        orElse: () => throw Exception('Lesson not found'),
      );

      if (state is PlayListLoaded) {
        final currentState = state as PlayListLoaded;
        emit(PlayListLoaded(
          lesson: selectedLesson,
          module: event.currentModule,
          modules: currentState.modules,
        ));
      }
    } catch (e) {
      emit(PlayListError(message: e.toString()));
    }
  }
}
