import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  HomeBloc() : super(HomeInitial()) {
    on<TabChanged>(_onTabChanged);
  }
  void _onTabChanged(TabChanged event,Emitter<HomeState> emit){
    emit(HomeInitial(index: event.tabSelected));
  }

}
