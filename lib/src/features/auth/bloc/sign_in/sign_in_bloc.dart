import 'package:bloc/bloc.dart';

import 'package:learning_app/src/data/repositories/auth_repository.dart';
import 'package:learning_app/src/data/services/auth_api_client.dart';


import 'package:meta/meta.dart';

import '../auth_bloc/auth_bloc.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthRepository _authRepository;
  final AuthBloc _authBloc;
  SignInBloc(AuthRepository authRepository,
      AuthBloc authBloc) :_authRepository = authRepository,
        _authBloc = authBloc ,super(SignInInitial()) {
    on<SignInButtonSubmit>(_onLoginRequested);
  }
  Future<void> _onLoginRequested(
      SignInButtonSubmit event,
      Emitter<SignInState> emit,
      ) async {
    try {
      // Emit loading state
      emit(SignInLoading());

      // Attempt to login
      final authResponse = await _authRepository.signInWithEmail(
          event.email,
          event.password
      );

      // Handle different authentication statuses
      switch (authResponse.status) {
        case AuthStatus.authenticated:
          _authBloc.add(AuthRequested());

          break;
        case AuthStatus.userNotFound:
          emit(SignInFailure(errorMessage: 'User not found'));
          break;
        case AuthStatus.invalidPassword:
          emit(SignInFailure(errorMessage: 'Invalid password'));
          break;
        case AuthStatus.emailRequired:
          emit(SignInFailure(
            errorMessage: 'Email is required',
          ));
          break;
        default:
          emit(SignInFailure(
            errorMessage: authResponse.message ?? 'Login failed',
          ));
      }
    } catch (e) {
      emit(SignInFailure(
        errorMessage: 'An unexpected error occurred: $e',
      ));
    }
  }


}
