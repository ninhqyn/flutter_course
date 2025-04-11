import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:learning_app/src/data/repositories/course_repository.dart';
import 'package:learning_app/src/features/my_course/bloc/my_course_bloc.dart';
import 'package:learning_app/src/features/my_course_detail/page/my_course_detail_page.dart';
import 'package:learning_app/src/shared/widgets/course_all_item.dart';
import 'package:learning_app/src/shared/widgets/course_item.dart';
import 'package:learning_app/src/shared/widgets/my_course_item.dart';

class MyCoursePage extends StatelessWidget {
  const MyCoursePage({super.key});

  @override
  Widget build(BuildContext context) {


    return SafeArea(
          child: Scaffold(
            appBar: _appBar(context),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 16,right: 16,top: 16),
                child: BlocBuilder<MyCourseBloc, MyCourseState>(
                  builder: (context, state) {
                    if(state is MyCourseLoaded){
                      final myCourse = state.myCourse;
                      if(myCourse.isNotEmpty){
                        return ListView.builder(itemCount: myCourse.length,shrinkWrap: true,itemBuilder: (context,index){
                          return InkWell(onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (_){
                              return MyCourseDetailPage(courseId: myCourse[index].courseId);
                            }));
                          },child: MyCourseItem(course: myCourse[index]));
                        });
                      }
                      return _noCourse(context);
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ),
          )
      );
  }

  Widget _noCourse(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Image.asset(
          'assets/images/my_course.png',
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.width / 3,
          fit: BoxFit.fill,
        ),
        const SizedBox(height: 20),
        const Text(
          'What will you learn first?',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'When you buy your first course, it will show up here',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400
          ),
        )
      ],
    );
  }

  PreferredSize _appBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size(double.infinity, 50),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'My course',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
            ),
            SvgPicture.asset('assets/vector/cart.svg', width: 34, height: 34)
          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String name;
  final String description;
  final IconData icon;
  final Color color;

  const CategoryCard({
    Key? key,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.black.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}