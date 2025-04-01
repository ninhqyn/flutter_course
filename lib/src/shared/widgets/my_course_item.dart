import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learning_app/src/data/model/user_course.dart';


class MyCourseItem extends StatelessWidget {
  const MyCourseItem({super.key, required this.course});
  final UserCourse course;

  @override
  Widget build(BuildContext context) {
    return Row(

      children: [
        Expanded(
          child: Container(
            color: Colors.black12,
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                course.thumbnailUrl == null
                    ? 'assets/images/unknown.png'
                    : course.thumbnailUrl!,
                fit: BoxFit.fill,
                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                  return Image.asset(
                    'assets/images/unknown.png',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Flexible(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.courseName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                const SizedBox(height: 5),
                Text(
                  course.category.categoryName,
                  style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                ),
                Row(
                  children: [
                    SvgPicture.asset('assets/vector/level.svg'),
                    const SizedBox(width: 5,),
                    Text(
                      course.difficultyLevel,
                      style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                 Row(
                
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        minHeight: 4,
                        value: course.progress,
                        borderRadius: const BorderRadius.all(Radius.circular(10)),

                      ),
                    ),
                    const SizedBox(width: 5,),
                    Text('100\%')
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}