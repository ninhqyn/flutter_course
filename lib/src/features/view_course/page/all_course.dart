import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learning_app/src/core/constants/type_constants.dart';
import 'package:learning_app/src/data/repositories/course_repository.dart';
import 'package:learning_app/src/features/course_detail/page/course_detail.dart';
import 'package:learning_app/src/shared/widgets/course_all_item.dart';
import '../bloc/all_item/all_item_bloc.dart';

class AllCourse extends StatelessWidget{
  const AllCourse({super.key, required this.constant});
  final String constant;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AllItemBloc(
              courseRepository: context.read<CourseRepository>()
          ),
      child: AllCourseView(constant: constant),
    );
  }
  
}
class AllCourseView extends StatefulWidget {
  const AllCourseView({super.key, required this.constant});

  final String constant;

  @override
  State<AllCourseView> createState() => _AllCourseViewState();
}

class _AllCourseViewState extends State<AllCourseView> {

  late String headName;
  final _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    context.read<AllItemBloc>().add(FetchDataAllItem(widget.constant));
    if (widget.constant == TypeConstant.courseFavorite) {
      headName = 'Khóa học phổ biến';
    }
    else if (widget.constant == TypeConstant.courseSuggest) {
      headName = 'Gợi  ý cho bạn';
    } else {
      headName = 'Tất cả khóa học';
    }

    _scrollController.addListener(_onScroll);
  }
  void _onScroll(){
    if(_isBottom) {
      context.read<AllItemBloc>().add(FetchDataAllItem(widget.constant));
    }
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
    return SafeArea(
        child: Scaffold(
          appBar: _appBar(context),
          body: Container(
            padding: const EdgeInsets.only(
                left: 15,
                right: 15,

            ),
            child: BlocBuilder<AllItemBloc, AllItemState>(
              builder: (context, state) {
                if (state is AllItemLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is AllItemError) {
                  return Center(
                    child: Text((state as AllItemError).message),
                  );
                } else if (state is AllItemLoaded || state is AllItemLoadMore) {
                  final courses = state is AllItemLoaded
                      ? (state as AllItemLoaded).courses
                      : (state as AllItemLoadMore).courses;

                  if (courses.isEmpty) {
                    return const Center(
                      child: Text('Không có khóa học nào'),
                    );
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          controller: _scrollController,
                          itemCount: courses.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return InkWell(onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (_){
                                return CourseDetail(course: courses[index]);
                              }));
                            },child: CourseAllItem(course: courses[index]));
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const Column(
                              children: [
                                SizedBox(height: 10),
                                LinearProgressIndicator(
                                  minHeight: 1,
                                  value: 1,
                                  color: Color(0xFFE9EAEC),
                                ),
                                SizedBox(height: 10),
                              ],
                            );
                          },
                        ),
                      ),
                      if (state is AllItemLoadMore)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                    ],
                  );
                }

                return const Center(
                  child: Text('Không có dữ liệu'),
                );
              },
            ),
          ),
        )
    );
  }

  PreferredSize _appBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size(double.infinity, 60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          IconButton(onPressed: () {
            Navigator.pop(context);
          },
              icon: SvgPicture.asset(
                  'assets/vector/arrow_left.svg'
              )
          ),
          Text(headName, style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
          ),
          ),
          Container()
        ],
      ),
    );
  }
}