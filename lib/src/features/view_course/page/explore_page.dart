import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/src/core/constants/type_constants.dart';

import 'package:learning_app/src/features/all_categories/page/all_categories_page.dart';
import 'package:learning_app/src/features/course_detail/page/course_detail.dart';

import 'package:learning_app/src/shared/models/category.dart';
import 'package:learning_app/src/shared/models/course.dart';
import 'package:learning_app/src/shared/widgets/category_item.dart';
import 'package:learning_app/src/shared/widgets/course_item.dart';


import 'all_course.dart';
import 'all_course_by_category.dart';
import '../bloc/explore/explore_bloc.dart';



class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  @override
  void initState() {
    super.initState();
    context.read<ExploreBloc>().add(FetchDataExplore());
  }
  void handleNavigatorSuggest(){
    Navigator.push(context, MaterialPageRoute(builder: (_){
      return  const AllCourse(constant: TypeConstant.courseSuggest,);
    })
    );
  }
  void handleNavigatorFavorite(){
    Navigator.push(context, MaterialPageRoute(builder: (_){
      return  const AllCourse(constant: TypeConstant.courseFavorite,);
    })
    );
  }
  void handleNavigatorCategory(List<Category> categories) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_){
       return AllCategoriesPage(categories: categories); 
      }
    ));
  }
  void handleNavigator(Category category) {
    Navigator.push(context, MaterialPageRoute(builder: (_){
      return AllCourseByCategory(category: category);
    })
    );
  }
  handleNavigatorCourseDetail(Course course){
    Navigator.push(context, MaterialPageRoute(builder: (_){
      return CourseDetail(course: course);
    })
    );
  }
  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();
    return SafeArea(
        child: Scaffold(
          body: CustomScrollView(
            controller: controller,
            slivers: [
              SliverAppBar(
                pinned: true, // Giữ app bar luôn hiển thị
                expandedHeight: 60.0,// Thiết lập chiều cao tối đa của app bar
                flexibleSpace: FlexibleSpaceBar(
                  title: AnimatedBuilder(
                    animation: controller,
                    builder: (context, child) {
                      double offset = controller.offset;
                      double alignment = offset > 50 ? 0.0 : -1.0;
                      return Align(
                        alignment: Alignment(alignment, 1),
                        child: const Text(
                          '  Explore',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                  centerTitle: true,
                ),
                backgroundColor: Colors.white,
              ),
              // Thêm Column bên trong SliverToBoxAdapter
              SliverToBoxAdapter(
                child: _contentExplore(context)
              ),
            ],
          ),
        ),
      );
  }

  Widget _contentExplore(BuildContext context){
  
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        //Category
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('   Categories',style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),),
            BlocBuilder<ExploreBloc, ExploreState>(
              builder: (context, state) {
                if(state is ExploreLoaded){
                  return  TextButton(onPressed: (){
                    handleNavigatorCategory(
                      state.categories
                    );
                  }, child: const Text('View all',style: TextStyle(
                      fontWeight:FontWeight.w500,
                      fontSize: 15
                  ),));
                }
                return TextButton(onPressed: (){
                }, child: const Text('View all',style: TextStyle(
                    fontWeight:FontWeight.w500,
                    fontSize: 15
                ),));
              },
            )
          ],
        ),
        const SizedBox(height: 20,),
        Container(
          height: MediaQuery.of(context).size.width/2.5,
          padding: const EdgeInsets.only(left: 15),
          child: BlocBuilder<ExploreBloc, ExploreState>(
            builder: (context, state) {
              if(state is ExploreLoaded ){
                if(state.categories.isNotEmpty){
                  return ListView.separated(
                    itemCount: state.categories.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context,index){
                      return InkWell(
                        onTap: (){
                          handleNavigator(state.categories[index]);
                        },
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width/2.5,
                            child: CategoryItem(category: state.categories[index],)),
                      );
                    }, separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(width: 15,);
                  },);
                }
                return const Text('Not found');
              }
              if(state is ExploreLoading){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return const Text('Error');

            },
          ),
        ),
        //Suggest for you
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('   Suggest for you',style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),),
            TextButton(onPressed: (){
              handleNavigatorSuggest();
            }, child: const Text('View all',style: TextStyle(
              fontWeight:FontWeight.w500,
              fontSize: 15
            ),))
          ],
        ),
        const SizedBox(height: 20,),
        Container(
          padding: const EdgeInsets.only(left: 15),
          child: BlocBuilder<ExploreBloc, ExploreState>(
            builder: (context, state) {
              if(state is ExploreLoaded){
                final courses = state.courses;
                if(courses.isNotEmpty){
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: courses.map((course) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: CourseItem(
                            course: course,
                            onTap: (){
                            handleNavigatorCourseDetail(course);
                          },
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }
                return const Text('Không tìm thấy khóa học');
              }
              if(state is ExploreLoading){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return const Text('Đã xảy ra lỗi');
            },
          ),
        ),

        const SizedBox(height: 20,),


        //Favorite
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('   Favorite course',style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),),
            TextButton(onPressed: (){
              handleNavigatorFavorite();
            }, child: const Text('View all',style: TextStyle(
                fontWeight:FontWeight.w500,
                fontSize: 15
            ),))
          ],
        ),
        const SizedBox(height: 20,),
        Container(
          padding: const EdgeInsets.only(left: 15),
          child: BlocBuilder<ExploreBloc, ExploreState>(
            builder: (context, state) {
              if(state is ExploreLoaded){
                final courses = state.courses;
                if(courses.isNotEmpty){
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: courses.map((course) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: InkWell(onTap: (){
                            handleNavigatorCourseDetail(course);
                          },child: CourseItem(
                            course: course,
                          )),
                        );
                      }).toList(),
                    ),
                  );
                }
                return const Text('Không tìm thấy khóa học');
              }
              if(state is ExploreLoading){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return const Text('Đã xảy ra lỗi');
            },
          ),
        ),
      ],
    );
  }




}