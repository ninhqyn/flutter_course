import 'package:flutter/material.dart';
import 'package:learning_app/src/data/model/user_lesson.dart';
import 'package:learning_app/src/data/model/user_module.dart';

class MyModuleItem extends StatelessWidget {
  const MyModuleItem({
    super.key,
    required this.module,
    required this.onLessonTap,
  });

  final UserModule module;
  final Function(UserLesson lesson) onLessonTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: const Color(0xFF3366FF),
          ),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          childrenPadding: const EdgeInsets.only(bottom: 16),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF3366FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '${module.orderIndex}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3366FF),
                  fontSize: 16,
                ),
              ),
            ),
          ),
          title: Text(
            module.moduleName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF2B3A67),
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              children: [
                const Icon(
                  Icons.video_library_outlined,
                  size: 16,
                  color: Color(0xFF718096),
                ),
                const SizedBox(width: 6),
                Text(
                  '${module.lessonCount} bài học',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF718096),
                  ),
                ),
                const SizedBox(width: 12),
                _buildCompletionIndicator(module),
              ],
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: module.lessons.map((lesson) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      onTap: () {
                        onLessonTap(lesson);
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: _buildEnhancedLessonItem(lesson),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletionIndicator(UserModule module) {
    // Tính toán tiến độ hoàn thành của module
    int completedLessons = module.lessons.where((lesson) => lesson.isCompleted).length;
    double completionPercentage = completedLessons / module.lessonCount;

    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: completionPercentage,
                backgroundColor: const Color(0xFFE2E8F0),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${(completionPercentage * 100).toInt()}%',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4CAF50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedLessonItem(UserLesson lesson) {
    IconData lessonIcon;
    Color iconColor;
      lessonIcon = Icons.play_circle_outline;
      iconColor = const Color(0xFF3366FF);


    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: lesson.isCompleted ? const Color(0xFFF0FDF4) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: lesson.isCompleted ? const Color(0xFFBBF7D0) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              lessonIcon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.lessonName,
                  style: TextStyle(
                    fontWeight: lesson.isCompleted ? FontWeight.w500 : FontWeight.w600,
                    fontSize: 14,
                    color: const Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${lesson.durationMinutes ?? 0} phút',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF718096),
                  ),
                ),
              ],
            ),
          ),
          lesson.isCompleted
              ? Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Color(0xFF4CAF50),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 14,
            ),
          )
              : const Icon(
            Icons.lock_open_outlined,
            color: Color(0xFF718096),
            size: 20,
          ),
        ],
      ),
    );
  }
}