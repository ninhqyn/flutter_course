part of 'quiz_detail_bloc.dart';

@immutable
sealed class QuizDetailState {}

final class QuizDetailInitial extends QuizDetailState {}

final class QuizDetailLoading extends QuizDetailState{}
final class QuizDetailLoaded extends QuizDetailState{
  final List<QuizResultResponse> quizResults;

  QuizDetailLoaded({required this.quizResults});
}
