import 'package:bloc/bloc.dart';
import 'package:learning_app/src/data/model/user_course.dart';

import 'package:learning_app/src/data/repositories/course_repository.dart';
import 'package:learning_app/src/shared/models/course.dart';
import 'package:meta/meta.dart';

part 'my_course_event.dart';
part 'my_course_state.dart';

class MyCourseBloc extends Bloc<MyCourseEvent, MyCourseState> {
  final CourseRepository courseRepository;
  MyCourseBloc({
    required this.courseRepository
}) : super(MyCourseInitial()) {
    on<FetchDataMyCourse>(_onFetchData);
  }
  Future<void> _onFetchData(FetchDataMyCourse event,Emitter<MyCourseState> emit) async{
    emit(MyCourseLoading());
    final myCourse = await courseRepository.getAllUserCourse();
    print(myCourse.length);
    emit(MyCourseLoaded(myCourse: myCourse));
  }
}
