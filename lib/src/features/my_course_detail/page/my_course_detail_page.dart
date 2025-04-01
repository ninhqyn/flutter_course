import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/src/data/model/quiz.dart';
import 'package:learning_app/src/data/model/user_lesson.dart';
import 'package:learning_app/src/data/repositories/course_repository.dart';
import 'package:learning_app/src/data/repositories/module_repository.dart';
import 'package:learning_app/src/data/repositories/quiz_repository.dart';
import 'package:learning_app/src/features/my_course_detail/bloc/my_course_detail_bloc.dart';
import 'package:learning_app/src/features/my_course_detail/widget/my_module_item.dart';
import 'package:learning_app/src/features/play_list/bloc/play_list_bloc.dart';
import 'package:learning_app/src/features/play_list/page/video_course_page.dart';
import 'package:learning_app/src/features/quiz/page/quiz_screen.dart';
import 'package:learning_app/src/shared/models/lesson.dart';

class MyCourseDetailPage extends StatefulWidget {
  final int courseId;

  const MyCourseDetailPage({super.key, required this.courseId});

  @override
  State<MyCourseDetailPage> createState() => _MyCourseDetailPageState();
}

class _MyCourseDetailPageState extends State<MyCourseDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late MyCourseDetailBloc myCourseDetailBloc;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    myCourseDetailBloc = MyCourseDetailBloc(
        courseRepository: context.read<CourseRepository>(),
        moduleRepository: context.read<ModuleRepository>(),
      quizRepository: context.read<QuizRepository>()
    )
      ..add(FetchDataMyCourseDetail(widget.courseId));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(

      value: myCourseDetailBloc,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('My Course Detail'),
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Text(
                      'Nội dung khóa học',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Text(
                      'Bài kiểm tra',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              // Tab 1: Nội dung khóa học (Module, bài học)
              SingleChildScrollView(
                child: _buildCourseContentTab(),
              ),

              // Tab 2: Bài kiểm tra (Quiz)
              SingleChildScrollView(
                child: _buildQuizTab(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourseContentTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nội dung khóa học',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          BlocBuilder<MyCourseDetailBloc, MyCourseDetailState>(
            builder: (context, state) {
              if(state is MyCourseDetailLoaded){
                return Text(state.course.description);
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          const SizedBox(height: 16),
          BlocBuilder<MyCourseDetailBloc, MyCourseDetailState>(
            builder: (context, state) {
              if(state is MyCourseDetailLoaded){
                return ListView.separated(
                    shrinkWrap: true,
                    itemCount:state.modules.length,
                    itemBuilder: (context, index) {
                      return MyModuleItem(module: state.modules[index], onLessonTap: (UserLesson lesson) {
                        Navigator.push(context, MaterialPageRoute(builder: (_){
                          return BlocProvider(
                            create: (context) => PlayListBloc(moduleRepository: context.read<ModuleRepository>()),
                            child: VideoCoursePage(courseId: widget.courseId, moduleId: state.modules[index].moduleId, lessonId: lesson.lessonId,),
                          );
                        }));
                      },);
                    }, separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 5,);
                },);
              }
              return const Center(
                child: CircularProgressIndicator(),
              );

            },
          )
          // Thêm các module khác tương tự
        ],
      ),
    );
  }


  Widget _buildQuizTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bài kiểm tra',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          BlocBuilder<MyCourseDetailBloc, MyCourseDetailState>(
            builder: (context, state) {
              if(state is MyCourseDetailLoaded){
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.quizzes.length,
                    itemBuilder: (context,index){
                  return _buildQuizItem(state.quizzes[index]);
                });
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildQuizItem(Quiz quiz) {

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: /*isImportant ? Colors.red.shade300 : */Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(8),
        color: /*isImportant ? Colors.red.shade50 : */Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Test ${quiz.orderIndex}: ${quiz.quizName}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: /*isImportant ? Colors.red.shade700 :*/ Colors.black,
                  ),
                ),
              ),
              /*if (isImportant)
                const Icon(Icons.star, color: Colors.amber),*/
            ],
          ),
          const SizedBox(height: 8),
          Text(quiz.description),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.question_answer, size: 16),
              const SizedBox(width: 4),
              Text('${quiz.questions.length} câu hỏi'),
              const SizedBox(width: 16),
              const Icon(Icons.timer, size: 16),
              const SizedBox(width: 4),
              Text('${quiz.timeLimitMinutes} phút'),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_){
                return QuizScreen(quiz: quiz);
              }));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: /*isImportant ? Colors.red :*/ null,
            ),
            child: const Text('Bắt đầu'),
          ),
        ],
      ),
    );
  }
}