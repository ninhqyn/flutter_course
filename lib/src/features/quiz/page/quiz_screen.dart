import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/src/data/model/quiz.dart';
import 'package:learning_app/src/features/quiz/bloc/quiz_bloc.dart';
import 'package:learning_app/src/features/quiz/page/result_screen.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key, required this.quiz});
  final Quiz quiz;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuizBloc(quiz: quiz),
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
                score: state.score,
                selectedAnswers: state.selectedAnswers,
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
              title:
                  Text(bloc.quiz.quizName,style: const TextStyle(
                      fontWeight: FontWeight.bold
                  )
              ),
              centerTitle: true,
              elevation: 0,
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
                      final isSelected = state.selectedAnswers[state.currentQuestionIndex] == index;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: GestureDetector(
                          onTap: () => context.read<QuizBloc>().add(QuizAnswerSelected(index)),
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
                        onPressed: state.selectedAnswers.containsKey(state.currentQuestionIndex)
                            ? () {
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
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue,
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
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