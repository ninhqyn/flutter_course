part of 'sign_in_bloc.dart';

@immutable
sealed class SignInEvent {}
final class SignInButtonSubmit extends SignInEvent{
  final String email;
  final String password;

  SignInButtonSubmit({required this.email,required this.password});
}