part of 'all_item_bloc.dart';

@immutable
sealed class AllItemEvent {}
final class FetchDataAllItem extends AllItemEvent{
  final String constant;

  FetchDataAllItem(this.constant);
}