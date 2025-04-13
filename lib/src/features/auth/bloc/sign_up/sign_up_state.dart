part of 'sign_up_bloc.dart';

enum SignUpStatus{
  success,
  error,
  loading,
  failure,
  initial
}
@immutable
class SignUpState extends Equatable{
  final String userName;
  final String email;
  final String password;
  final String confirmPassword;
  final String nameError;
  final String emailError;
  final String passwordError;
  final String confirmPasswordError;
  final bool isValidate;
  final bool isShowPassword;
  final bool isShowConfirmPassword;
  final String errorMessage;
  final SignUpStatus signUpStatus;
  const SignUpState({
    this.userName ='',
    this.email ='',
    this.password = '',
    this.confirmPassword ='',
    this.nameError ='',
    this.emailError = '',
    this.passwordError = '',
    this.confirmPasswordError = '',
    this.isValidate = false,
    this.isShowPassword = false,
    this.isShowConfirmPassword = false,
    this.signUpStatus  = SignUpStatus.initial,
    this.errorMessage =''
  });
  SignUpState copyWith({
    String? userName,
    String? email,
    String? password,
    String? confirmPassword,
    String? nameError,
    String? emailError,
    String? passwordError,
    String? confirmPasswordError,
    bool? isValidate,
    bool? isShowPassword,
    bool? isShowConfirmPassword,
    SignUpStatus? signUpStatus,
    String? errorMessage
  }){
    return SignUpState(
      userName: userName ?? this.userName,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      nameError: nameError ?? this.nameError,
      emailError: emailError ?? this.emailError,
      passwordError: passwordError ?? this.passwordError,
      confirmPasswordError: confirmPasswordError ?? this.confirmPasswordError,
      isValidate:  isValidate ?? this.isValidate,
      isShowPassword: isShowPassword ?? this.isShowPassword,
      isShowConfirmPassword: isShowConfirmPassword ?? this.isShowConfirmPassword,
      signUpStatus: signUpStatus ?? this.signUpStatus,
      errorMessage: errorMessage ?? this.errorMessage
    );
}
  @override
  List<Object?> get props => [isShowConfirmPassword,isShowPassword,userName,email,password,
    confirmPassword,nameError,emailError,passwordError,confirmPasswordError,isValidate,
    signUpStatus,errorMessage];
}

