
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:learning_app/src/data/repositories/course_repository.dart';
import 'package:learning_app/src/features/course_detail/page/course_detail.dart';

import 'package:learning_app/src/shared/models/category.dart';
import 'package:learning_app/src/shared/widgets/course_all_item.dart';

import '../bloc/course_by_category/course_by_category_bloc.dart';

class AllCourseByCategory extends StatefulWidget {
  const AllCourseByCategory({super.key, required this.category});
  final Category category;
  @override
  State<AllCourseByCategory> createState() => _AllCourseByCategoryState();
}

class _AllCourseByCategoryState extends State<AllCourseByCategory> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

 void _onScroll(){
    if(_isBottom) context.read<CourseByCategoryBloc>().add(FetchDataCourseByCategory(widget.category.categoryId));
 }
  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
  bool get _isBottom{
    if(!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => CourseByCategoryBloc(
      courseRepository: context.read<CourseRepository>()
  )..add(FetchDataCourseByCategory(widget.category.categoryId)),
  child: Scaffold(
      body: Builder(
        builder: (context) {
          return SafeArea(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 220,
                        color: Colors.pink,
                        child: Image.network(
                          widget.category.imageUrl ==null ?'assets/images/background_login.png':
                          widget.category.imageUrl!,
                          fit: BoxFit.fill,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace){
                            return Image.asset(
                              width: double.infinity,
                              'assets/images/unknown.png',
                              fit: BoxFit.fill,
                            );
                          },
                        ),
                      ),
                      _appBar(context),
                      Positioned(
                         top: 100,
                        left: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.black.withOpacity(0.4)
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(widget.category.categoryName,style: const TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                              ),),
                            ),
                            const SizedBox(height: 10,),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.black.withOpacity(0.4)
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: const Text('5 course',style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white
                              ),),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      top: 15,
                        left: 15,
                        right: 15,
                    ),
                    child: BlocBuilder<CourseByCategoryBloc,CourseByCategoryState >(
                      builder: (context, state) {
                        if(state.status == FetchStatus.success){
                          if(state.courses.isNotEmpty){
                            return Column(
                              children: [
                                ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: state.courses.length,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(onTap: (){
                                      Navigator.push(context,MaterialPageRoute(builder: (_){
                                        return CourseDetail(course: state.courses[index]);
                                      }));
                                    },child: CourseAllItem(course: state.courses[index],));
                                  }, separatorBuilder: (BuildContext context, int index) {
                                  return const Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      LinearProgressIndicator(
                                        minHeight: 1,
                                        value: 1,
                                        color: Color(0xFFE9EAEC),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  );
                                },
                                ),
                                if(state.status == FetchStatus.loadingMore)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                              ],
                            );
                          }
                        }
                        if(state.status == FetchStatus.initial){
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if(state.status == FetchStatus.failure){
                          return const Center(
                            child: Text('Da xy ra loi'),
                          );
                        }
                        return const Text('Error');
                
                      },
                
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    ),
);
  }

  Widget _appBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.black.withOpacity(0.4)
            ),
            child: IconButton(onPressed: () {
              Navigator.pop(context);
            },
                icon: SvgPicture.asset(
                    'assets/vector/arrow_left.svg',
                  color: Colors.white,
                )
            ),
          ),
          Container(),
          Container()
        ],
      ),
    );
  }
}