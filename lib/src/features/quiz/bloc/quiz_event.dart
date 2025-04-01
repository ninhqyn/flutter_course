part of 'quiz_bloc.dart';

@immutable
sealed class QuizEvent {}
class QuizInitialized extends QuizEvent {}

class QuizAnswerSelected extends QuizEvent {
  final int answerIndex;
  QuizAnswerSelected(this.answerIndex);
}

class QuizNextQuestion extends QuizEvent {}

class QuizPreviousQuestion extends QuizEvent {}

class QuizTimerTick extends QuizEvent {}

class QuizCompleted extends QuizEvent {}