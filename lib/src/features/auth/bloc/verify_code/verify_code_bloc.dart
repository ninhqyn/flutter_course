import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:learning_app/src/data/repositories/auth_repository.dart';
import 'package:meta/meta.dart';

part 'verify_code_event.dart';
part 'verify_code_state.dart';

class VerifyCodeBloc extends Bloc<VerifyCodeEvent, VerifyCodeState> {
  final AuthRepository authRepository;
  final String email;
  Timer? _resendTimer;
  VerifyCodeBloc({
    required this.authRepository,
    required this.email,
  }) : super(VerifyCodeState.initial()) {
    on<VerifyCodeChanged>(_onVerifyCodeChanged);
    on<VerifyCodeSubmitted>(_onVerifyCodeSubmitted);
    on<ResendCodeRequested>(_onResendCodeRequested);
    on<CountdownTicked>(_onCountdownTicked);

    _startResendTimer();
  }
  @override
  Future<void> close() {
    _resendTimer?.cancel();
    return super.close();
  }
  void _startResendTimer() {
    const totalSeconds = 5 * 60; // 5 minutes in seconds
    emit(state.copyWith(resendCountdown: totalSeconds));

    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final newCountdown = state.resendCountdown! - 1;
      if (newCountdown <= 0) {
        timer.cancel();
        add(const CountdownTicked(0));
      } else {
        add(CountdownTicked(newCountdown));
      }
    });
  }

  void _onCountdownTicked(
      CountdownTicked event,
      Emitter<VerifyCodeState> emit,
      ) {
    emit(state.copyWith(resendCountdown: event.remainingSeconds));
  }
  void _onVerifyCodeChanged(
      VerifyCodeChanged event,
      Emitter<VerifyCodeState> emit,
      ) {
    final updatedCodes = List<String>.from(state.codes);
    updatedCodes[event.position] = event.code;
    emit(state.copyWith(codes: updatedCodes));
  }

  Future<void> _onVerifyCodeSubmitted(
      VerifyCodeSubmitted event,
      Emitter<VerifyCodeState> emit,
      ) async {
    if (!state.isValid) {
      emit(state.copyWith(
        status: VerifyCodeStatus.failure,
        errorMessage: 'Vui lòng nhập đủ 6 số',
      ));
      return;
    }

    emit(state.copyWith(status: VerifyCodeStatus.submitting));

    try {
      // Gọi API xác thực mã
      final response = await authRepository.verifyCode(
        email: email,
        code: state.completeCode,
      );

      if (response.isSuccess) {
        emit(state.copyWith(status: VerifyCodeStatus.success));
      } else {
        emit(state.copyWith(
          status: VerifyCodeStatus.failure,
          errorMessage: response.message,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: VerifyCodeStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onResendCodeRequested(
      ResendCodeRequested event,
      Emitter<VerifyCodeState> emit,
      ) async {
    emit(state.copyWith(status: VerifyCodeStatus.resending));

    try {
      // Gọi API gửi lại mã
      final response = await authRepository.resendVerificationCode(email: email);

      if (response.isSuccess) {
        emit(state.copyWith(status: VerifyCodeStatus.resendSuccess));
        // Restart the timer after successful resend
        _startResendTimer();
      } else {
        emit(state.copyWith(
          status: VerifyCodeStatus.resendFailure,
          errorMessage: response.message,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: VerifyCodeStatus.resendFailure,
        errorMessage: e.toString(),
      ));
    }
  }
}
