import 'package:flutter/material.dart';
import 'package:learning_app/src/data/model/user_lesson.dart';
import 'package:learning_app/src/data/model/user_module.dart';
import 'package:learning_app/src/shared/models/lesson.dart';
import 'package:learning_app/src/shared/models/module.dart';
import 'package:learning_app/src/shared/widgets/lesson_item.dart';

class MyModuleItem extends StatelessWidget {
  const MyModuleItem({
    super.key,
    required this.module,
    required this.onLessonTap,  // Added this parameter for onTap callback
  });

  final UserModule module;
  final Function(UserLesson lesson) onLessonTap;  // Accepting the onTap function

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ExpansionTile(
        title: Text(
          'Module ${module.orderIndex}: ${module.moduleName}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${module.lessonCount} Lesson'),
        children: module.lessons.map((lesson) {
          return InkWell(onTap: (){
            onLessonTap(lesson);
          },child: LessonItem(lesson: lesson,isCompleted: lesson.isCompleted,));
        }
        ).toList(),
      ),
    );
  }
}
