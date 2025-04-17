import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learning_app/src/shared/models/course.dart';
import 'package:learning_app/src/shared/utils/price_format.dart';

class CourseItem extends StatelessWidget {
  const CourseItem({
    super.key,
    required this.course,
    this.onTap,
  });

  final Course course;
  final VoidCallback? onTap;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 300,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 2),
                  blurRadius: 17,
                  color: Colors.black.withOpacity(0.07)
              )
            ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10)
              ),
              child: Image.network(
                course.thumbnailUrl ?? 'assets/images/unknown.png',
                width: 300,
                height: 150,
                fit: BoxFit.fill,
                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                  return Image.asset(
                    'assets/images/unknown.png',
                    width: 300,
                    height: 150,
                    fit: BoxFit.fill,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    course.courseName,
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    course.category.categoryName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      SvgPicture.asset('assets/vector/level.svg'),
                      const SizedBox(width: 5,),
                      Text(
                        course.difficultyLevel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      return SizedBox(
                        width: constraints.maxWidth,
                        child: Text(
                          course.price.toCurrencyVND(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}