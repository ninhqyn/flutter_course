part of 'verify_code_bloc.dart';

@immutable
enum VerifyCodeStatus { initial, submitting, success, failure, resending, resendSuccess, resendFailure }

class VerifyCodeState extends Equatable {
  final List<String> codes;
  final VerifyCodeStatus status;
  final String? errorMessage;
  final int? resendCountdown; // Time remaining in seconds

  const VerifyCodeState({
    required this.codes,
    this.status = VerifyCodeStatus.initial,
    this.errorMessage,
    this.resendCountdown,
  });

  factory VerifyCodeState.initial() {
    return VerifyCodeState(codes: List.filled(6, ''));
  }

  bool get isValid => codes.every((code) => code.isNotEmpty);
  String get completeCode => codes.join();
  bool get canResend => resendCountdown == null || resendCountdown == 0;

  VerifyCodeState copyWith({
    List<String>? codes,
    VerifyCodeStatus? status,
    String? errorMessage,
    int? resendCountdown,
  }) {
    return VerifyCodeState(
      codes: codes ?? this.codes,
      status: status ?? this.status,
      errorMessage: errorMessage,
      resendCountdown: resendCountdown ?? this.resendCountdown,
    );
  }

  @override
  List<Object?> get props => [codes, status, errorMessage, resendCountdown];
}