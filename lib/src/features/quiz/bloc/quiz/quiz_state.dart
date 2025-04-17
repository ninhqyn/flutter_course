part of 'quiz_bloc.dart';

@immutable
class QuizState {
  final int currentQuestionIndex;
  final List<AnswerSelect> selectedAnswers;
  final bool isCompleted;
  final int remainingTimeInSeconds;
  final QuizResultResponse quizResultResponse;

  const QuizState({
    required this.currentQuestionIndex,
    required this.selectedAnswers,
    required this.isCompleted,
    required this.remainingTimeInSeconds,
    required this.quizResultResponse
  });

  factory QuizState.initial(int timeLimitMinutes) {
    return QuizState(
      currentQuestionIndex: 0,
      selectedAnswers: const<AnswerSelect>[],
      isCompleted: false,
      remainingTimeInSeconds: timeLimitMinutes * 60,
      quizResultResponse: QuizResultResponse(
          resultId: 0,
          score: 0,
          passed: false,
          totalQuestions:0,
          correctAnswers: 0,
          attemptNumber: 0,
          submissionDate: DateTime.now(),
          message: '',
          success: false)
    );
  }

  QuizState copyWith({
    int? currentQuestionIndex,
    int? score,
    List<AnswerSelect>? selectedAnswers,
    bool? isCompleted,
    int? remainingTimeInSeconds,
    QuizResultResponse? quizResultResponse
  }) {
    return QuizState(
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      isCompleted: isCompleted ?? this.isCompleted,
      remainingTimeInSeconds: remainingTimeInSeconds ?? this.remainingTimeInSeconds,
      quizResultResponse: quizResultResponse ?? this.quizResultResponse

    );
  }
}
