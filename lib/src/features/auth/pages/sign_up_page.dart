import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learning_app/src/data/repositories/auth_repository.dart';
import 'package:learning_app/src/features/auth/bloc/sign_up/sign_up_bloc.dart';
import 'package:learning_app/src/features/auth/pages/resend_page.dart';
import 'package:learning_app/src/features/auth/pages/sign_in_page.dart';
import 'package:learning_app/src/features/auth/pages/verifycode_screen.dart';


class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key, required this.isLogin});
  final bool isLogin;
  void handleNavigator(BuildContext context){
    if(!isLogin){
      Navigator.pop(context);
    }else{
      Navigator.push(context, MaterialPageRoute(builder: (_){
        return const SignInPage(isSignUp: true);
      }));
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmController = TextEditingController();
    return BlocProvider(
      create: (context) => SignUpBloc(context.read<AuthRepository>()),
      child: SafeArea(
      child: Builder(
        builder: (context) {
          return BlocConsumer<SignUpBloc, SignUpState>(
            listener: (context, state) {
              if(state.signUpStatus == SignUpStatus.failure){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage),
                    backgroundColor: Colors.red,
                  ),
                );
              }
              if(state.signUpStatus == SignUpStatus.success){
                Navigator.push(context, MaterialPageRoute(builder: (_){
                  return VerifyCodeScreen(email: state.email,);
                }));
              }
            },
            builder: (context, state) {
              if(state.signUpStatus == SignUpStatus.loading){
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return Scaffold(
                resizeToAvoidBottomInset: true, // Ensures the UI resizes when the keyboard appears
                appBar: _appBar(context),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Đăng ký',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                        ),
                        const SizedBox(height: 16.0), // Add spacing
                        TextField(
                          controller: nameController,
                          onChanged: (value){
                            context.read<SignUpBloc>().add(UserNameChanged(userName: value));
                          },
                          decoration:  InputDecoration(
                            hintText: 'Tên hiển thị',
                            errorText: state.nameError.isEmpty ? null : state.nameError,
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue,
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        TextField(
                          controller: emailController,
                          onChanged: (value){
                            context.read<SignUpBloc>().add(EmailSignUpChanged(email: value));
                          },
                          decoration: InputDecoration(
                            hintText: 'Email',
                            errorText: state.emailError.isEmpty ? null : state.emailError,
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue,
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0), // Add spacing
                        TextField(
                          controller: passwordController,
                          onChanged: (value){
                            context.read<SignUpBloc>().add(PasswordSignUpChanged(password: value));
                          },
                          obscureText: !state.isShowPassword,
                          decoration: InputDecoration(
                            hintText: 'Mật khẩu',
                            errorText: state.passwordError.isEmpty ? null : state.passwordError,
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.lightBlue, // Match the image's border color
                                width: 2.0,
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                state.isShowPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                context.read<SignUpBloc>().add(PasswordVisible());
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: confirmController,
                          onChanged: (value){
                            context.read<SignUpBloc>().add(ConfirmPasswordChanged(confirmPassword: value));
                          },
                          obscureText: !state.isShowConfirmPassword,
                          decoration: InputDecoration(
                            hintText: 'Xác thực mật khẩu',
                            errorText: state.confirmPasswordError.isEmpty ? null : state.confirmPasswordError,
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.lightBlue, // Match the image's border color
                                width: 2.0,
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                state.isShowConfirmPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                context.read<SignUpBloc>().add(ConfirmPasswordVisible());
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),// Add spacing
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Quên mật khẩu?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(height: 100,),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<SignUpBloc>().add(SignUpSubmit());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent, // Match the "Log in" button color
                              minimumSize: const Size(double.infinity, 50),
                              side: BorderSide(
                                width: 1,
                                color: Colors.black.withOpacity(0.2),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Đăng ký', // Changed to "Log in" to match the second image
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      ),
    ),
);
  }

  PreferredSize _appBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size(double.infinity, 50),
      child: Padding(
        padding: const EdgeInsets.only(left: 10,top: 10,bottom: 5,right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context); // Navigate back when arrow is tapped
              },
              child: SvgPicture.asset('assets/vector/arrow_left.svg'),
            ),
            TextButton(
              onPressed: () {
                handleNavigator(context);
              },
              child: const Text(
                'Đã  có tài khoản ?',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}