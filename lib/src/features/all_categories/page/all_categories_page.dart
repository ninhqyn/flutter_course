import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:learning_app/src/features/view_course/page/all_course_by_category.dart';
import 'package:learning_app/src/shared/models/category.dart';
import 'package:learning_app/src/shared/widgets/category_card.dart';
import 'package:learning_app/src/shared/widgets/category_item.dart';

class AllCategoriesPage extends StatelessWidget {
  const AllCategoriesPage({super.key, required this.categories});
  final List<Category> categories;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'All Categories',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: GridView.count(

          shrinkWrap: true, // chiếm không gian vừa đủ
          crossAxisCount: 2, // 2 cột
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio:  2/ 2.5, // điều chỉnh tỉ lệ ngang / dọc
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
      ),
    );
  }
}
