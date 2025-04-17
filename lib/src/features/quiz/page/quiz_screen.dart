import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/src/data/model/answer_select.dart';
import 'package:learning_app/src/data/model/quiz.dart';
import 'package:learning_app/src/data/repositories/quiz_repository.dart';
import 'package:learning_app/src/features/quiz/bloc/quiz/quiz_bloc.dart';
import 'package:learning_app/src/features/quiz/page/quiz_detail_page.dart';
import 'package:learning_app/src/features/quiz/page/result_screen.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key, required this.quiz});
  final Quiz quiz;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuizBloc(
        quiz: quiz,
        quizRepository: context.read<QuizRepository>(),
      ),
      child: const _QuizScreenContent(),
    );
  }
}

class _QuizScreenContent extends StatelessWidget {
  const _QuizScreenContent();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuizBloc, QuizState>(
      listener: (context, state) {
        if (state.isCompleted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => ResultScreen(
                quiz: context.read<QuizBloc>().quiz,
                quizResultResponse: state.quizResultResponse,
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final bloc = context.read<QuizBloc>();
        final currentQuestion = bloc.quiz.questions[state.currentQuestionIndex];
        final options = currentQuestion.answers.map((answer) => answer.answerText).toList();

        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                  bloc.quiz.quizName,
                  style: const TextStyle(fontWeight: FontWeight.bold)
              ),
              centerTitle: true,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () async {
                  final shouldPop = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Xác nhận'),
                      content: const Text('Bạn có chắc chắn muốn thoát?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Hủy'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Thoát'),
                        ),
                      ],
                    ),
                  );

                  if (shouldPop == true) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_){
                      return QuizDetailPage(quiz: context.read<QuizBloc>().quiz);
                    })); // Thực hiện thoát
                  }
                },

              ),
            ),
            body: Column(
              children: [
                // Quiz timer display
                // Question counter and progress
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Question ${state.currentQuestionIndex + 1}/${bloc.quiz.questions.length}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      BlocBuilder<QuizBloc, QuizState>(
                        buildWhen: (previous, current) => previous.remainingTimeInSeconds != current.remainingTimeInSeconds,
                        builder: (context, state) {
                          final minutes = state.remainingTimeInSeconds ~/ 60;
                          final seconds = state.remainingTimeInSeconds % 60;
                          final timeColor = _getTimeColor(state.remainingTimeInSeconds, bloc.quiz.timeLimitMinutes! * 60);

                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.timer, color: timeColor),
                              const SizedBox(width: 8),
                              Text(
                                '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: timeColor,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Question
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            currentQuestion.questionText,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Answer options
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      // Tìm xem câu hỏi hiện tại có được trả lời chưa
                      final selectedAnswer = state.selectedAnswers.firstWhere(
                            (answer) => answer.questionId == currentQuestion.questionId,
                        orElse: () => AnswerSelect(questionId: -1, answerId: -1),
                      );

                      // Kiểm tra xem câu trả lời này có được chọn không
                      final isSelected = selectedAnswer.questionId != -1 &&
                          selectedAnswer.answerId == currentQuestion.answers[index].answerId;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: GestureDetector(
                          onTap: () {
                            // Tạo đối tượng AnswerSelect khi người dùng chọn câu trả lời
                            final answer = AnswerSelect(
                              questionId: currentQuestion.questionId,
                              answerId: currentQuestion.answers[index].answerId,
                            );
                            context.read<QuizBloc>().add(QuizAnswerSelected(answer: answer));
                          },
                          child: Card(
                            elevation: isSelected ? 4 : 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: isSelected ? Colors.lightBlue : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: isSelected ? Colors.lightBlue : Colors.grey[200],
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        String.fromCharCode(65 + index), // A, B, C, D
                                        style: TextStyle(
                                          color: isSelected ? Colors.white : Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      options[index],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Navigation buttons
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Previous button
                      ElevatedButton(
                        onPressed: state.currentQuestionIndex > 0
                            ? () => context.read<QuizBloc>().add(QuizPreviousQuestion())
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Previous',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      // Next/Finish button
                      ElevatedButton(
                        onPressed: () {
                          // Kiểm tra xem câu hỏi hiện tại đã được trả lời chưa
                          final currentQuestionAnswered = state.selectedAnswers.any(
                                  (answer) => answer.questionId == currentQuestion.questionId
                          );

                          if (currentQuestionAnswered) {
                            if (state.currentQuestionIndex < bloc.quiz.questions.length - 1) {
                              context.read<QuizBloc>().add(QuizNextQuestion());
                            } else {
                              // Show confirmation dialog if it's the final question
                              showDialog(
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  return AlertDialog(
                                    title: const Text('Finish Quiz'),
                                    content: const Text('Are you sure you want to finish the quiz?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(dialogContext).pop(); // Close the dialog
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          // Trigger finish quiz event or any required action here
                                          context.read<QuizBloc>().add(QuizCompleted());
                                          Navigator.of(dialogContext).pop(); // Close the dialog
                                        },
                                        child: const Text('Yes'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue,
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          disabledBackgroundColor: Colors.grey.shade300,
                        ),
                        // Kiểm tra xem câu hỏi hiện tại đã được trả lời chưa
                        // để quyết định xem nút Next/Finish có được kích hoạt không
                        child: Text(
                          state.currentQuestionIndex < bloc.quiz.questions.length - 1
                              ? 'Next'
                              : 'Finish Quiz',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getTimeColor(int secondsRemaining, int totalSeconds) {
    final percentage = secondsRemaining / totalSeconds;

    if (percentage > 0.5) {
      return Colors.green;
    } else if (percentage > 0.25) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}