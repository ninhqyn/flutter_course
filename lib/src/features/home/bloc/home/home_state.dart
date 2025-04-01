part of 'home_bloc.dart';

@immutable
sealed class HomeState extends Equatable{}

final class HomeInitial extends HomeState {
  final int index;
  HomeInitial({
    this.index = 0
});

  @override
  List<Object?> get props =>[index];
}

