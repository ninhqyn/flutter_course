part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}
final class ProfileLoading extends ProfileState{}
final class ProfileInitial extends ProfileState {}
final class ProfileLoaded extends ProfileState{
  final User user;

  ProfileLoaded({
    required this.user
  });
}
