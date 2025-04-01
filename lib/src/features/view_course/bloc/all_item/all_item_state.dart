part of 'all_item_bloc.dart';

@immutable
abstract class AllItemState extends Equatable {
  const AllItemState();

  @override
  List<Object> get props => [];
}

class AllItemInitial extends AllItemState {}

class AllItemLoading extends AllItemState {}

class AllItemLoaded extends AllItemState {
  final List<Course> courses;
  final bool hasMax;

  const AllItemLoaded({
    required this.courses,
    required this.hasMax,
  });

  @override
  List<Object> get props => [courses, hasMax];
}

class AllItemLoadMore extends AllItemState {
  final List<Course> courses;
  final bool hasMax;

  const AllItemLoadMore({
    required this.courses,
    required this.hasMax,
  });

  @override
  List<Object> get props => [courses, hasMax];
}

class AllItemError extends AllItemState {
  final String message;

  const AllItemError(this.message);

  @override
  List<Object> get props => [message];
}