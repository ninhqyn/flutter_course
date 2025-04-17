part of 'quiz_detail_bloc.dart';

@immutable
sealed class QuizDetailEvent {}
final class FetchQuizHistory extends QuizDetailEvent{}
