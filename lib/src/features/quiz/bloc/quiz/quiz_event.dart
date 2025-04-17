
part of 'quiz_bloc.dart';

@immutable
abstract class QuizEvent {}

class QuizInitialized extends QuizEvent {}

class QuizAnswerSelected extends QuizEvent {
  final AnswerSelect answer;

  QuizAnswerSelected({required this.answer});
}

class QuizNextQuestion extends QuizEvent {}

class QuizPreviousQuestion extends QuizEvent {}

class QuizTimerTick extends QuizEvent {}

class QuizCompleted extends QuizEvent {}

class QuizSubmitted extends QuizEvent {
  final List<AnswerSelect> answers;

  QuizSubmitted({required this.answers});
}