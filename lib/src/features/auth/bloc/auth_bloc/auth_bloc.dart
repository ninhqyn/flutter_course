import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:learning_app/src/data/repositories/auth_repository.dart';
import 'package:learning_app/src/data/services/auth_api_client.dart';

import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  late final StreamSubscription<AuthStatus> _authStatusSubscription;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthState.unknown()) {
    on<AuthRequested>(_onRequested);
    on<AuthLogOut>(_onLogout);
    on<AuthStatusChanged>(_onAuthStatusChanged);
    _authStatusSubscription = _authRepository.authStatusStream.listen(
          (status) => add(AuthStatusChanged(status)),
    );

    // Kích hoạt kiểm tra trạng thái ban đầu
    add(const AuthRequested());
  }

  @override
  Future<void> close() {
    _authStatusSubscription.cancel();
    return super.close();
  }

  Future<void> _onRequested(
      AuthRequested event,
      Emitter<AuthState> emit,
      ) async {

    await _authRepository.checkAuthStatus();

  }

  void _onAuthStatusChanged(
      AuthStatusChanged event,
      Emitter<AuthState> emit,
      ) {

    switch (event.status) {
      case AuthStatus.authenticated:
        emit(const AuthState.authenticated());
        break;
      case AuthStatus.unauthenticated:
        emit(const AuthState.unauthenticated());
        break;
      case AuthStatus.unknown:
        emit(const AuthState.unknown());
        break;
      default:
        emit(const AuthState.unknown());
    }
  }

  Future<void> _onLogout(AuthLogOut event, Emitter<AuthState> emit) async {
    try {
      await _authRepository.clearTokens();
    } catch (e) {
      emit(const AuthState.unknown());
    }
  }
}