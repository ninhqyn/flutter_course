part of 'sign_in_bloc.dart';

@immutable
sealed class SignInState {}

final class SignInInitial extends SignInState {}

final class SignInSuccess extends SignInState{}

final class SignInFailure extends SignInState{
  final String errorMessage;

  SignInFailure({required this.errorMessage});
}
final class SignInLoading extends SignInState{}
