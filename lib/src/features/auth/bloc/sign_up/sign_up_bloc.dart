import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:learning_app/src/data/repositories/auth_repository.dart';
import 'package:learning_app/src/shared/utils/input_validators.dart';
import 'package:meta/meta.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthRepository _authRepository;
  SignUpBloc(AuthRepository authRepository)  :
        _authRepository = authRepository,
        super(const SignUpState()) {
    on<UserNameChanged>(_onUserNameChanged);
    on<EmailSignUpChanged>(_onEmailChanged);
    on<PasswordSignUpChanged>(_onPasswordChanged);
    on<ConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<PasswordVisible>(_onPasswordVisible);
    on<ConfirmPasswordVisible>(_onConfirmPasswordVisible);
    on<SignUpSubmit>(_onSignUpSubmit);
  }
  Future<void> _onSignUpSubmit(SignUpSubmit event, Emitter<SignUpState> emit) async {
    // Validate all fields first
    final nameError = InputValidators.validateUsername(state.userName);
    final emailError = InputValidators.validateEmail(state.email);
    final passwordError = InputValidators.validatePassword(state.password);
    final confirmPasswordError = InputValidators.validateConfirmPassword(state.password, state.confirmPassword);

    // Update state with any errors
    emit(state.copyWith(
      nameError: nameError,
      emailError: emailError,
      passwordError: passwordError,
      confirmPasswordError: confirmPasswordError,
    ));

    // Check if all validations pass AND fields are not empty
    if (nameError.isEmpty &&
        emailError.isEmpty &&
        passwordError.isEmpty &&
        confirmPasswordError.isEmpty &&
        state.userName.isNotEmpty &&
        state.email.isNotEmpty &&
        state.password.isNotEmpty &&
        state.confirmPassword.isNotEmpty) {

      emit(state.copyWith(isValidate: true, signUpStatus: SignUpStatus.loading));
      Example:
        final response = await _authRepository.signUpWithEmail(state.userName, state.email, state.password, state.confirmPassword);
        if (response.isSuccess) {
          emit(state.copyWith(signUpStatus: SignUpStatus.success));
        } else {
          emit(state.copyWith(signUpStatus: SignUpStatus.failure, errorMessage: response.message));
        }


      debugPrint('Validation passed! Proceeding with signup...');
    } else {
      // Validation failed, show errors
      debugPrint('Validation failed! Cannot proceed with signup.');
      emit(state.copyWith(isValidate: false));
    }
  }
  void _onPasswordVisible(PasswordVisible event,Emitter<SignUpState> emit){
    debugPrint('handle show pass');
    emit(state.copyWith(isShowPassword: !state.isShowPassword));
  }
  void _onConfirmPasswordVisible(ConfirmPasswordVisible event,Emitter<SignUpState> emit){
    debugPrint('handle show pass confirm');
    emit(state.copyWith(isShowConfirmPassword: !state.isShowConfirmPassword));
  }
  void _onUserNameChanged(UserNameChanged event,Emitter<SignUpState> emit){
    final errorText =InputValidators.validateUsername(event.userName);
    emit(state.copyWith(userName: event.userName,nameError: errorText));
    debugPrint(state.userName);
    debugPrint(state.nameError);
  }
  void _onEmailChanged(EmailSignUpChanged event,Emitter<SignUpState> emit){
    final errorText = InputValidators.validateEmail(event.email);
    emit(state.copyWith(email: event.email,emailError: errorText));
    debugPrint(state.email);
  }
  void _onPasswordChanged(PasswordSignUpChanged event,Emitter<SignUpState> emit){
    final errorText = InputValidators.validatePassword(event.password);
    if(state.confirmPassword!='' && state.confirmPassword.isNotEmpty){
      final confirmPasswordError = InputValidators.validateConfirmPassword(event.password, state.confirmPassword);
      emit(state.copyWith(password: event.password,passwordError: errorText,confirmPasswordError: confirmPasswordError));
      return;
    }
    emit(state.copyWith(password: event.password,passwordError: errorText));
    debugPrint(state.password);
  }
  void _onConfirmPasswordChanged(ConfirmPasswordChanged event,Emitter<SignUpState> emit){
    final errorText = InputValidators.validateConfirmPassword(state.password,event.confirmPassword);
    emit(state.copyWith(confirmPassword: event.confirmPassword,confirmPasswordError: errorText));
    debugPrint(state.confirmPassword);
  }
}
