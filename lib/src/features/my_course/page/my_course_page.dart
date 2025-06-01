import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learning_app/src/features/my_course/bloc/my_course_bloc.dart';
import 'package:learning_app/src/features/my_course_detail/page/my_course_detail_page.dart';
import 'package:learning_app/src/shared/widgets/my_course_item.dart';

class MyCoursePage extends StatefulWidget {
  const MyCoursePage({super.key});

  @override
  State<MyCoursePage> createState() => _MyCoursePageState();
}

class _MyCoursePageState extends State<MyCoursePage> {
  late MyCourseBloc _myCourseBloc;
  @override
  void initState() {
    super.initState();
    _myCourseBloc = context.read<MyCourseBloc>();
    _myCourseBloc.add(FetchDataMyCourse());
  }
  @override
  Widget build(BuildContext context) {

    return SafeArea(
          child: Scaffold(
            appBar: _appBar(context),
            body: Padding(
              padding: const EdgeInsets.only(left: 16,right: 16,top: 16),
              child: BlocBuilder<MyCourseBloc, MyCourseState>(
                builder: (context, state) {
                  if(state is MyCourseLoaded){
                    final myCourse = state.myCourse;
                    if(myCourse.isNotEmpty){
                      return ListView.builder(itemCount: myCourse.length,

                          itemBuilder: (context,index){
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
              'Khóa học của tôi',
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

