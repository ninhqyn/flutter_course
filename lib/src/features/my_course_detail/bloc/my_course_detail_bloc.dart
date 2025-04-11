import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:learning_app/src/data/model/quiz.dart';
import 'package:learning_app/src/data/model/user_module.dart';
import 'package:learning_app/src/data/repositories/course_repository.dart';
import 'package:learning_app/src/data/repositories/module_repository.dart';
import 'package:learning_app/src/data/repositories/quiz_repository.dart';
import 'package:learning_app/src/shared/models/course.dart';
import 'package:meta/meta.dart';

part 'my_course_detail_event.dart';
part 'my_course_detail_state.dart';

class MyCourseDetailBloc extends Bloc<MyCourseDetailEvent, MyCourseDetailState> {
  final CourseRepository courseRepository;
  final ModuleRepository moduleRepository;
  final QuizRepository quizRepository;
  MyCourseDetailBloc({
    required this.courseRepository,
    required this.moduleRepository,
    required this.quizRepository
}) : super(MyCourseDetailInitial()) {
    on<FetchDataMyCourseDetail>(_onFetchDataMyCourseDetail);
    on<UpdateDataModule>(_onUpdateDataModule);
  }
  Future<void> _onUpdateDataModule(UpdateDataModule event,Emitter<MyCourseDetailState> emit) async{
    if(state is MyCourseDetailLoaded){
      final currentState = state as MyCourseDetailLoaded;
      emit(MyCourseDetailLoading());
      final lessonModule = await moduleRepository.getAllUserModuleByCourseId(currentState.course.courseId);
      emit(currentState.copyWith(modules: lessonModule));
    }

    print('sucess update');
  }
  Future<void> _onFetchDataMyCourseDetail(FetchDataMyCourseDetail event,Emitter<MyCourseDetailState> emit) async{
    emit(MyCourseDetailLoading());


    final result = await Future.wait(
      [
        courseRepository.getCourseById(event.courseId),
        moduleRepository.getAllUserModuleByCourseId(event.courseId),
        quizRepository.getAllQuizzesByCourseId(event.courseId),
      ]
    );
    final course = result[0] as Course;
    final lessonModule = result[1] as List<UserModule>;
    final quizzes = result[2] as List<Quiz>;
    emit(MyCourseDetailLoaded(modules: lessonModule, course: course,quizzes: quizzes));
    print('sucess');
  }
}
