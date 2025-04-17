import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:learning_app/src/data/repositories/course_repository.dart';
import 'package:learning_app/src/shared/models/course.dart';
import 'package:meta/meta.dart';

part 'instructor_courses_event.dart';
part 'instructor_courses_state.dart';

class InstructorCoursesBloc extends Bloc<InstructorCoursesEvent, InstructorCoursesState> {
  final CourseRepository _courseRepository;

  InstructorCoursesBloc(CourseRepository courseRepository) :_courseRepository = courseRepository, super(InstructorCoursesInitial()) {
    on<FetchInstructorCourses>(_onFetchInstructorCourses);
  }

  Future<void> _onFetchInstructorCourses(
      FetchInstructorCourses event,
      Emitter<InstructorCoursesState> emit,
      ) async {
    emit(InstructorCoursesLoading());

    try {
      final courses = await _courseRepository.getAllCourseByInstructorId(event.instructorId);
      emit(InstructorCoursesLoaded(courses));
    } catch (e) {
      emit(InstructorCoursesError(e.toString()));
    }
  }
}