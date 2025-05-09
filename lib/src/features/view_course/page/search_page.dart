import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learning_app/src/data/repositories/category_repository.dart';
import 'package:learning_app/src/data/repositories/course_repository.dart';
import 'package:learning_app/src/features/cart/page/cart_page.dart';
import 'package:learning_app/src/features/view_course/page/all_course_by_category.dart';
import 'package:learning_app/src/shared/models/category.dart';
import 'package:learning_app/src/shared/models/course.dart';

import 'package:learning_app/src/shared/widgets/category_card.dart';
import 'package:learning_app/src/shared/widgets/category_item_vertical.dart';
import 'package:learning_app/src/shared/widgets/course_all_item.dart';

import '../bloc/search/search_bloc.dart';
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => SearchBloc(
      categoryRepository: context.read<CategoryRepository>(),
      courseRepository: context.read<CourseRepository>())..add(FetchDataSearch()
  ),
  child: Builder(
    builder: (context) {
      return Scaffold(
          appBar: _appBar(context),
          body: SafeArea(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                final hasInput = _searchController.text.isNotEmpty;
                if (state is SearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is SearchLoaded) {

                  return hasInput
                      ? _inputWidget(state.categories,state.filterCourses!=null ? state.filterCourses! : const<Course>[],state.categorySelected)
                      : _noneInputWidget(state.categories);
                }

                // Fallback
                return const Center(child: Text('An error occurred'));
              },
            ),
          ),
        );
    }
  ),
);
  }

  Widget _noneInputWidget(List<Category> categories) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Browse categories',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            const SizedBox(height: 10),
          GridView.count(
            physics: NeverScrollableScrollPhysics(), // không scroll
            shrinkWrap: true, // chiếm không gian vừa đủ
            crossAxisCount: 2, // 2 cột
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio:  2/ 2.8, // điều chỉnh tỉ lệ ngang / dọc
            children: List.generate(categories.length, (index) {
              return InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return AllCourseByCategory(category: categories[index]);
                  }));
                },
                child: CategoryCard(category: categories[index]),
              );
            }),
          ),

          const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _inputWidget(List<Category> categories,List<Course> filterCourses,int categorySelected) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 36,
          margin: const EdgeInsets.only(left: 16, top: 20, bottom: 20),
          child: ListView.separated(
            itemCount: categories.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              bool result =index==categorySelected ? true : false;
              return InkWell(onTap: (){
                context.read<SearchBloc>().add(
                    SearchCategorySelected(
                    categoryId: categories[index].categoryId,
                        index: index)
                );
              },
              child: CategoryItemHorizontal(
              isSelected: result,
              categoryName: categories[index].categoryName,
              )
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(width: 10);
            },
          )
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            '${filterCourses.length} courses',
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.black
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: filterCourses.length,
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              // Replace with actual CourseAllItem widget
              return CourseAllItem(course: filterCourses[index]);
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
        )
      ],
    );
  }

  PreferredSize _appBar(BuildContext context) {
    final hasInput = _searchController.text.isNotEmpty;
    return PreferredSize(
      preferredSize: const Size(double.infinity, 50),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'What are you looking for?',
                    prefixIcon: hasInput ? null: const Icon(Icons.search),
                    border: InputBorder.none,
                    filled: true,
                    fillColor: const Color(0xFFF3F5F6),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12,horizontal: 10),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.cancel_outlined),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                        });

                        context.read<SearchBloc>().add(TextSearchChanged(''));
                      },
                    )
                        : null,
                  ),
                  onChanged: (value) {
                    setState(() {

                    });
                    context.read<SearchBloc>().add(TextSearchChanged(value));
                  },
                )
            ),
            const SizedBox(width: 10),
            GestureDetector(onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (_){
                return const ShoppingCartPage();
              }));
            },child: SvgPicture.asset('assets/vector/cart.svg', width: 34, height: 34))
          ],
        ),
      ),
    );
  }
}