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

      final result = await Future.wait([
        skillRepository.getAllSkillByCourseId(event.courseId),
        instructorRepository.getAllInstructorByCourseId(event.courseId),
        moduleRepository.getAllModuleByCourseId(event.courseId),
        courseRepository.getCourseByCategoryId(event.categoryId),
        ratingRepository.getRatingTotalCourseId(event.courseId)
      ]);
      final skills = result[0] as List<Skill>;
      final instructor = result[1] as List<Instructor>;
      final modules = result[2] as List<Module>;
      final courses = result[3] as List<Course>;
      final rating = result[4] as RatingTotal;

      final filteredCourses = courses.where((course) => course.courseId != event.courseId).toList();

      // Emit state với dữ liệu đã xử lý
      emit(CourseDetailLoaded(
          courseId: event.courseId,
          skills: skills,
          instructors: instructor,
          modules: modules,
          courses: filteredCourses,
          rating: rating
      ));

      print('fetch data course detail ${event.courseId}');
    } catch (e) {
      print('Error fetching data: $e');
      emit(CourseDetailError(message: 'Failed to fetch data'));
    }
  }
}
