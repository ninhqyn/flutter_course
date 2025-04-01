import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:learning_app/src/data/model/quiz.dart';
import 'package:meta/meta.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final Quiz quiz;
  Timer? _timer;

  QuizBloc({required this.quiz}) : super(QuizState.initial(quiz.timeLimitMinutes ?? 10)) {
    on<QuizInitialized>(_onInitialized);
    on<QuizAnswerSelected>(_onAnswerSelected);
    on<QuizNextQuestion>(_onNextQuestion);
    on<QuizPreviousQuestion>(_onPreviousQuestion);
    on<QuizTimerTick>(_onTimerTick);
    on<QuizCompleted>(_onCompleted);

    // Initialize the quiz and start the timer
    add(QuizInitialized());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  void _startTimer() {
    _timer?.cancel();

    // Start the countdown timer for total quiz time
    const tickInterval = Duration(seconds: 1);

    _timer = Timer.periodic(tickInterval, (timer) {
      if (state.remainingTimeInSeconds > 0) {
        add(QuizTimerTick());
      } else {
        _timer?.cancel();
        // Time's up for the entire quiz
        add(QuizCompleted());
      }
    });
  }

  void _onInitialized(QuizInitialized event, Emitter<QuizState> emit) {
    _startTimer();
  }

  void _onAnswerSelected(QuizAnswerSelected event, Emitter<QuizState> emit) {
    final selectedAnswers = Map<int, int>.from(state.selectedAnswers);
    selectedAnswers[state.currentQuestionIndex] = event.answerIndex;

    emit(state.copyWith(selectedAnswers: selectedAnswers));
  }

  void _onNextQuestion(QuizNextQuestion event, Emitter<QuizState> emit) {
    // Calculate score for the current question
    int updatedScore = state.score;
    if (state.selectedAnswers.containsKey(state.currentQuestionIndex)) {
      final currentQuestion = quiz.questions[state.currentQuestionIndex];
      final selectedAnswerIndex = state.selectedAnswers[state.currentQuestionIndex]!;

      if (selectedAnswerIndex < currentQuestion.answers.length &&
          currentQuestion.answers[selectedAnswerIndex].isCorrect == true) {
        updatedScore++;
      }
    }

    // Check if this is the last question
    if (state.currentQuestionIndex < quiz.questions.length - 1) {
      emit(state.copyWith(
        currentQuestionIndex: state.currentQuestionIndex + 1,
        score: updatedScore,
      ));
    } else {
      // Quiz is completed
      _timer?.cancel();
      emit(state.copyWith(
        score: updatedScore,
        isCompleted: true,
      ));
    }
  }

  void _onPreviousQuestion(QuizPreviousQuestion event, Emitter<QuizState> emit) {
    if (state.currentQuestionIndex > 0) {
      emit(state.copyWith(
        currentQuestionIndex: state.currentQuestionIndex - 1,
      ));
    }
  }

  void _onTimerTick(QuizTimerTick event, Emitter<QuizState> emit) {
    emit(state.copyWith(remainingTimeInSeconds: state.remainingTimeInSeconds - 1));
  }

  void _onCompleted(QuizCompleted event, Emitter<QuizState> emit) {
    _timer?.cancel();

    // Calculate final score for answered questions
    int finalScore = 0;
    for (int i = 0; i < quiz.questions.length; i++) {
      if (state.selectedAnswers.containsKey(i)) {
        final question = quiz.questions[i];
        final selectedAnswerIndex = state.selectedAnswers[i]!;

        if (selectedAnswerIndex < question.answers.length &&
            question.answers[selectedAnswerIndex].isCorrect == true) {
          finalScore++;
        }
      }
    }

    emit(state.copyWith(
      isCompleted: true,
      score: finalScore,
    ));
  }
}