import 'package:bloc/bloc.dart';
import 'package:learning_app/src/data/repositories/module_repository.dart';
import 'package:learning_app/src/shared/models/lesson.dart';
import 'package:learning_app/src/shared/models/module.dart';
import 'package:meta/meta.dart';

part 'play_list_event.dart';
part 'play_list_state.dart';

class PlayListBloc extends Bloc<PlayListEvent, PlayListState> {
  final ModuleRepository moduleRepository;

  PlayListBloc({
    required this.moduleRepository
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
  void _onVideoFinished(
      VideoFinished event,
      Emitter<PlayListState> emit
      ) {
    try {
      print('next video');
      // Tìm bài học tiếp theo trong module hiện tại
      final currentLessonIndex = event.currentModule.lessons
          .indexWhere((l) => l.lessonId == event.currentLesson.lessonId);

      // Nếu còn bài học trong module hiện tại
      if (currentLessonIndex < event.currentModule.lessons.length - 1) {
        final nextLesson = event.currentModule.lessons[currentLessonIndex + 1];
        emit(PlayListLoaded(
          lesson: nextLesson,
          module: event.currentModule,
          modules: event.allModules,
        ));
        return;
      }

      // Nếu hết bài học trong module hiện tại, chuyển sang module tiếp theo
      final currentModuleIndex = event.allModules
          .indexWhere((m) => m.moduleId == event.currentModule.moduleId);

      if (currentModuleIndex < event.allModules.length - 1) {
        final nextModule = event.allModules[currentModuleIndex + 1];
        if (nextModule.lessons.isNotEmpty) {
          emit(PlayListLoaded(
            lesson: nextModule.lessons.first,
            module: nextModule,
            modules: event.allModules,
          ));
          return;
        }
      }

      // Nếu đã học xong tất cả các bài
      emit(PlayListLoaded(
        lesson: event.currentLesson,
        module: event.currentModule,
        modules: event.allModules,
      ));
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
