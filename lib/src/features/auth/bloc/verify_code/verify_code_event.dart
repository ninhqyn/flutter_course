part of 'verify_code_bloc.dart';

@immutable
abstract class VerifyCodeEvent extends Equatable {
  const VerifyCodeEvent();

  @override
  List<Object> get props => [];
}

class VerifyCodeChanged extends VerifyCodeEvent {
  final String code;
  final int position;

  const VerifyCodeChanged(this.code, this.position);

  @override
  List<Object> get props => [code, position];
}

class VerifyCodeSubmitted extends VerifyCodeEvent {}

class ResendCodeRequested extends VerifyCodeEvent {}
