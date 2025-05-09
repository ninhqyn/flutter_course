part of 'quiz_detail_bloc.dart';

@immutable
sealed class QuizDetailState {}

final class QuizDetailInitial extends QuizDetailState {}

final class QuizDetailLoading extends QuizDetailState{}
final class QuizDetailLoaded extends QuizDetailState{
  final List<QuizResultResponse> quizResults;
  final bool hasMax;

  QuizDetailLoaded({required this.quizResults,required this.hasMax});
}
final class QuizDetailLoadMore extends QuizDetailState{
  final List<QuizResultResponse> quizResults;
  final bool hasMax;
  QuizDetailLoadMore({required this.quizResults,required this.hasMax});
}