part of 'quiz_bloc.dart';

@immutable
class QuizState {
  final int currentQuestionIndex;
  final int score;
  final Map<int, int> selectedAnswers;
  final bool isCompleted;
  final int remainingTimeInSeconds;

  QuizState({
    required this.currentQuestionIndex,
    required this.score,
    required this.selectedAnswers,
    required this.isCompleted,
    required this.remainingTimeInSeconds,
  });

  factory QuizState.initial(int timeLimitMinutes) {
    return QuizState(
      currentQuestionIndex: 0,
      score: 0,
      selectedAnswers: {},
      isCompleted: false,
      remainingTimeInSeconds: timeLimitMinutes * 60, // Convert minutes to seconds
    );
  }

  QuizState copyWith({
    int? currentQuestionIndex,
    int? score,
    Map<int, int>? selectedAnswers,
    bool? isCompleted,
    int? remainingTimeInSeconds,
  }) {
    return QuizState(
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      score: score ?? this.score,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      isCompleted: isCompleted ?? this.isCompleted,
      remainingTimeInSeconds: remainingTimeInSeconds ?? this.remainingTimeInSeconds,
    );
  }
}
