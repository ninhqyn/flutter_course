part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}
final class TabChanged extends HomeEvent{
  final int tabSelected;
  TabChanged(this.tabSelected);
}
