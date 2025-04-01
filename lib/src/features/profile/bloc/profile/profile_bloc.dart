import 'package:bloc/bloc.dart';
import 'package:learning_app/src/data/model/user.dart';

import 'package:learning_app/src/data/repositories/auth_repository.dart';
import 'package:learning_app/src/data/repositories/user_repository.dart';

import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {

  final UserRepository _userRepository;
  ProfileBloc(
      UserRepository userRepository) :
        _userRepository = userRepository,
        super(ProfileInitial()) {

    on<ProfileFetchData>(_onFetchUserData);
    add(ProfileFetchData());
  }
  Future<void> _onFetchUserData(ProfileFetchData event,Emitter<ProfileState> emit) async{
    emit(ProfileLoading());
    print('fetch data user');
    final user = await _userRepository.getUserInfo();
    if(user!=null){
      print(user.email);
      emit(ProfileLoaded(user: user));
    }

  }
}
