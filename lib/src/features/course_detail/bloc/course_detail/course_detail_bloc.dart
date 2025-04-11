import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:learning_app/src/data/repositories/course_repository.dart';
import 'package:learning_app/src/data/repositories/instructor_repository.dart';
import 'package:learning_app/src/data/repositories/module_repository.dart';
import 'package:learning_app/src/data/repositories/rating_repository.dart';
import 'package:learning_app/src/data/repositories/skill_repository.dart';
import 'package:learning_app/src/shared/models/course.dart';
import 'package:learning_app/src/shared/models/instructor.dart';
import 'package:learning_app/src/shared/models/module.dart';
import 'package:learning_app/src/shared/models/rating_total.dart';
import 'package:learning_app/src/shared/models/skill.dart';
import 'package:meta/meta.dart';
part 'course_detail_event.dart';
part 'course_detail_state.dart';

class CourseDetailBloc extends Bloc<CourseDetailEvent, CourseDetailState> {
  final SkillRepository skillRepository;
  final InstructorRepository instructorRepository;
  final ModuleRepository moduleRepository;
  final CourseRepository courseRepository;
  final RatingRepository ratingRepository;

  CourseDetailBloc({
    required this.skillRepository,
    required this.instructorRepository,
    required this.moduleRepository,
    required this.courseRepository,
    required this.ratingRepository
  }) : super(CourseDetailInitial()) {
    on<FetchDataCourseDetail>(_onFetchDataCourseDetail);
  }

  Future<void> _onFetchDataCourseDetail(FetchDataCourseDetail event, Emitter<CourseDetailState> emit) async {
    try {
      final rating = await ratingRepository.getRatingTotalCourseId(event.courseId);
      emit(CourseDetailLoaded(
          courseId:event.courseId,
          skills: const<Skill>[],
          instructors: const<Instructor>[],
          modules: const<Module>[],
          courses: const<Course>[],
          rating: rating)
      );
      final result = await Future.wait([
        skillRepository.getAllSkillByCourseId(event.courseId),
        instructorRepository.getAllInstructorByCourseId(event.courseId),
        moduleRepository.getAllModuleByCourseId(event.courseId),
        courseRepository.getCourseByCategoryId(event.categoryId),
      ]);
      final skills = result[0] as List<Skill>;
      final instructor = result[1] as List<Instructor>;
      final modules = result[2] as List<Module>;
      final courses = result[3] as List<Course>;
      final filteredCourses = courses.where((course) => course.courseId != event.courseId).toList();
      if(state is CourseDetailLoaded){
        final currentState = state as CourseDetailLoaded;
        emit(currentState.copyWith(
          skills: skills,
          instructors: instructor,
          modules: modules,
          courses: filteredCourses
        ));
      }
      print('fetch data course detail ${event.courseId}');
    } catch (e) {
      print('Error fetching data: $e');
      emit(CourseDetailError(message: 'Failed to fetch data'));
    }
  }
}
