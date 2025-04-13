part of 'sign_up_bloc.dart';

@immutable
sealed class SignUpEvent {}
final class UserNameChanged extends SignUpEvent{
  final String userName;
  UserNameChanged({required this.userName});
}
final class EmailSignUpChanged extends SignUpEvent{
  final String email;
  EmailSignUpChanged({required this.email});
}
final class PasswordSignUpChanged extends SignUpEvent{
  final String password;

  PasswordSignUpChanged({required this.password});
}
final class ConfirmPasswordChanged extends SignUpEvent{
  final String confirmPassword;
  ConfirmPasswordChanged({required this.confirmPassword});
}
final class SignUpSubmit extends SignUpEvent{
  SignUpSubmit();
}
final class PasswordVisible extends SignUpEvent{}
final class ConfirmPasswordVisible extends SignUpEvent{}
