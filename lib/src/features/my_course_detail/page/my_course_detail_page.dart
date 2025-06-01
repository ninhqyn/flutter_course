import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learning_app/src/data/model/quiz.dart';
import 'package:learning_app/src/data/model/user_lesson.dart';
import 'package:learning_app/src/data/repositories/course_repository.dart';
import 'package:learning_app/src/data/repositories/lesson_repository.dart';
import 'package:learning_app/src/data/repositories/module_repository.dart';

import 'package:learning_app/src/features/my_course_detail/bloc/my_course_detail_bloc.dart';
import 'package:learning_app/src/features/my_course_detail/widget/my_module_item.dart';
import 'package:learning_app/src/features/play_list/bloc/play_list_bloc.dart';
import 'package:learning_app/src/features/play_list/page/video_course_page.dart';
import 'package:learning_app/src/features/quiz/page/quiz_detail_page.dart';
import 'package:learning_app/src/features/quiz/page/quiz_screen.dart';

class MyCourseDetailPage extends StatefulWidget {
  final int courseId;

  const MyCourseDetailPage({super.key, required this.courseId});

  @override
  State<MyCourseDetailPage> createState() => _MyCourseDetailPageState();
}

class _MyCourseDetailPageState extends State<MyCourseDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<MyCourseDetailBloc>().add(FetchDataMyCourseDetail(widget.courseId));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<MyCourseDetailBloc, MyCourseDetailState>(
        builder: (context, state) {
          if (state is MyCourseDetailLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3366FF)),
                ),
              ),
            );
          }

          if (state is MyCourseDetailLoaded) {
            return Scaffold(
              backgroundColor: const Color(0xFFF8FAFC),
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.white,
                centerTitle: true,
                leading: IconButton(
                  icon: SvgPicture.asset(
                    'assets/vector/arrow_left.svg',
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF2B3A67),
                      BlendMode.srcIn,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: Text(
                  state.course.courseName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2B3A67),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(65),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.05),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicatorWeight: 3,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorColor: const Color(0xFF3366FF),
                      labelColor: const Color(0xFF3366FF),
                      unselectedLabelColor: const Color(0xFF64748B),
                      labelStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      tabs: [
                        Tab(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.menu_book_rounded, size: 20),
                              const SizedBox(width: 8),
                              const Text('Nội dung khóa học'),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.quiz_rounded, size: 20),
                              const SizedBox(width: 8),
                              const Text('Bài kiểm tra'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              body: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: Nội dung khóa học
                  SingleChildScrollView(
                    child: _buildCourseContentTab(),
                  ),

                  // Tab 2: Bài kiểm tra (Quiz)
                  SingleChildScrollView(
                    child: _buildQuizTab(),
                  ),
                ],
              ),
            );
          }

          return const Scaffold(
            body: Center(
              child: Text("Có lỗi xảy ra khi tải thông tin khóa học"),
            ),
          );
        },
      ),
    );
  }
  Widget _buildCourseContentTab() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: BlocBuilder<MyCourseDetailBloc, MyCourseDetailState>(
        builder: (context, state) {
          if(state is MyCourseDetailLoaded){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nội dung khóa học',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: Color(0xFF2B3A67),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F4F8),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    state.course.description,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Color(0xFF4A5568),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: state.modules.length,
                  itemBuilder: (context, index) {
                    return MyModuleItem(
                      module: state.modules[index],
                      onLessonTap: (UserLesson lesson) {
                        Navigator.push(context, MaterialPageRoute(builder: (_){
                          return BlocProvider(
                            create: (context) => PlayListBloc(
                                moduleRepository: context.read<ModuleRepository>(),
                                lessonRepository: context.read<LessonRepository>()
                            ),
                            child: VideoCoursePage(
                              courseId: widget.courseId,
                              moduleId: state.modules[index].moduleId,
                              lessonId: lesson.lessonId,
                            ),
                          );
                        }));
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 16);
                  },
                ),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3366FF)),
            ),
          );
        },
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
    bool isImportant = quiz.isFinal == null ? false : quiz.isFinal!;
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_){
          return QuizDetailPage(quiz: quiz);
        }));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isImportant ? Colors.red.shade300 : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isImportant ? Colors.red.shade50 : Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Test ${quiz.orderIndex}: ${quiz.quizName}',
                    style:  TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isImportant ? Colors.red.shade700 : Colors.black,
                    ),
                  ),
                ),
                if (isImportant)
                  const Icon(Icons.star, color: Colors.amber),
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

          ],
        ),
      ),
    );
  }
}