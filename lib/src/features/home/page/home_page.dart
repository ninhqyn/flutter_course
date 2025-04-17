import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:learning_app/src/features/profile/page/profile_page.dart';

import 'package:learning_app/src/features/view_course/page/explore_page.dart';
import 'package:learning_app/src/features/view_course/page/search_page.dart';

import 'package:learning_app/src/features/my_course/page/my_course_page.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int indexSelected = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: IndexedStack(
          index: indexSelected,
          children: const [
            ExplorePage(),
            SearchPage(),
            MyCoursePage(),
            ProfilePage(),
          ],
        ),
        bottomNavigationBar: _bottomNavigator(context),
      ),
    );
  }

  Widget _bottomNavigator(BuildContext context) {

    Color selectedColor = Colors.blue;
    Color unselectedColor = Colors.black54;

    return Container(
      height: 70,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 1),
                blurRadius: 16,
                color: Colors.black.withOpacity(0.07)
            )
          ],
          color: Colors.white
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildNavItem(
              context: context,
              icon: 'assets/vector/explore.svg',
              label: 'Explore',
              index: 0,
              selectedColor: selectedColor,
              unselectedColor: unselectedColor,
            ),
          ),
          Expanded(
            child: _buildNavItem(
              context: context,
              icon: 'assets/vector/search.svg',
              label: 'Search',
              index: 1,
              selectedColor: selectedColor,
              unselectedColor: unselectedColor,
            ),
          ),
          Expanded(
            child: _buildNavItem(
              context: context,

              icon: 'assets/vector/my_course.svg',
              label: 'My course',
              index: 2,
              selectedColor: selectedColor,
              unselectedColor: unselectedColor,
            ),
          ),
          Expanded(
            child: _buildNavItem(
              context: context,

              icon: 'assets/vector/profile.svg',
              label: 'Profile',
              index: 3,
              selectedColor: selectedColor,
              unselectedColor: unselectedColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,

    required String icon,
    required String label,
    required int index,
    required Color selectedColor,
    required Color unselectedColor,
  }) {
    bool isSelected = indexSelected == index;
    Color itemColor = isSelected ? selectedColor : unselectedColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            indexSelected = index;
          });
        },
        splashColor: selectedColor.withOpacity(0.3),
        highlightColor: selectedColor.withOpacity(0.2),
        child: Ink(
          height: 70,
          decoration: BoxDecoration(
            color: isSelected ? selectedColor.withOpacity(0.05) : Colors.transparent,

          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                icon,
                colorFilter: ColorFilter.mode(itemColor, BlendMode.srcIn),
                height: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  color: itemColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}