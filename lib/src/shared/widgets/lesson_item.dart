import 'package:flutter/material.dart';
import 'package:learning_app/src/data/model/user_lesson.dart';
import 'package:learning_app/src/shared/models/lesson.dart';

class LessonItem extends StatelessWidget {
  const LessonItem({super.key, required this.lesson, required this.isCompleted});
  final UserLesson lesson;
  final bool isCompleted;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 2),
            blurRadius: 14,
            color: Colors.black.withOpacity(0.07),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      'https://res.cloudinary.com/depram2im/image/upload/v1743389798/ai_clsgh6.jpg',
                      width: MediaQuery.of(context).size.width / 3,
                      height: MediaQuery.of(context).size.width / 5,
                        fit: BoxFit.fill,
                        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                          return Image.asset(
                              'assets/images/unknown.png',
                              width: 300,
                              height: 150,
                              fit: BoxFit.fill
                          );}
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 45,
                    color: Colors.black.withOpacity(0.2),
                    child: const Icon(
                       Icons.play_arrow,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
              ,
              const SizedBox(width: 8), // Adding space between image and text
              Expanded(  // This ensures the text takes up available space and wraps when necessary
                child: Text(
                  'Lesson ${lesson.orderIndex}: ${lesson.lessonName}',
                  style: const TextStyle(fontSize: 15),
                  overflow: TextOverflow.ellipsis, // Optionally add an ellipsis when text overflows
                  softWrap: true,
                  maxLines: 3,// This allows the text to wrap to the next line
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),  // Adding space between text and the blue line
          Container(
            height: 40,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                width: 1,
                color: Colors.grey
              ),
              color: isCompleted ? Colors.lightBlue :Colors.transparent
            ),
            child:  Center(child: isCompleted ? const Text('Lesson finished',style: TextStyle(
              color: Colors.white
            ),):const Text('Mask as complete',style: TextStyle(
              color: Colors.black,
            ),)
            ),
          ),
        ],
      ),
    );
  }
}
