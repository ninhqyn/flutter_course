import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:learning_app/src/data/model/answer_select.dart';
import 'package:learning_app/src/data/model/quiz.dart';
import 'package:learning_app/src/data/model/quiz_result_request.dart';
import 'package:learning_app/src/data/model/quiz_result_response.dart';
import 'package:learning_app/src/data/repositories/quiz_repository.dart';
import 'package:meta/meta.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final Quiz quiz;
  final QuizRepository _quizRepository;
  Timer? _timer;

  QuizBloc({
    required this.quiz,
    required QuizRepository quizRepository,
  }) : _quizRepository = quizRepository,
        super(QuizState.initial(quiz.timeLimitMinutes ?? 10)) {

    on<QuizInitialized>(_onInitialized);
    on<QuizAnswerSelected>(_onAnswerSelected);
    on<QuizNextQuestion>(_onNextQuestion);
    on<QuizPreviousQuestion>(_onPreviousQuestion);
    on<QuizTimerTick>(_onTimerTick);
    on<QuizCompleted>(_onCompleted);
    on<QuizSubmitted>(_onSubmitted);

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
    final currentAnswers = List<AnswerSelect>.from(state.selectedAnswers);

    // Kiểm tra xem câu hỏi này đã được trả lời chưa
    final existingAnswerIndex = currentAnswers.indexWhere(
            (answer) => answer.questionId == event.answer.questionId
    );

    if (existingAnswerIndex != -1) {
      // Nếu đã trả lời rồi, thay thế câu trả lời cũ
      currentAnswers[existingAnswerIndex] = event.answer;
    } else {
      // Nếu chưa trả lời, thêm câu trả lời mới
      currentAnswers.add(event.answer);
    }

    emit(state.copyWith(selectedAnswers: currentAnswers));
  }

  void _onNextQuestion(QuizNextQuestion event, Emitter<QuizState> emit) {
    // Check if this is the last question
    if (state.currentQuestionIndex < quiz.questions.length - 1) {
      emit(state.copyWith(
        currentQuestionIndex: state.currentQuestionIndex + 1,
      ));
    } else {
      // Quiz is completed
      _timer?.cancel();
      emit(state.copyWith(
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

    emit(state.copyWith(
      isCompleted: true,
    ));

    // Tự động gửi kết quả khi hoàn thành
    add(QuizSubmitted(answers: state.selectedAnswers));
  }

  Future<void> _onSubmitted(QuizSubmitted event, Emitter<QuizState> emit) async {
    try {
      final int timeSpentMinutes =
          ((quiz.timeLimitMinutes ?? 10) * 60 - state.remainingTimeInSeconds) ~/ 60;
      // Tạo request payload
      final quizResultRequest = QuizResultRequest(
        quizId: quiz.quizId,
        answers: event.answers,
        timeSpentMinutes: timeSpentMinutes,
      );

      // Gọi API để gửi kết quả
      final result = await _quizRepository.submitQuiz(quizResultRequest); // Cập nhật state với kết quả
      emit(state.copyWith(
        quizResultResponse: result,
        isCompleted: true,
      ));
    } catch (e) {
      // Xử lý lỗi - có thể emit state lỗi nếu cần
      print('Error submitting quiz: $e');
    }
  }
}