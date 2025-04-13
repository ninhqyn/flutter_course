import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/src/data/repositories/auth_repository.dart';
import 'package:learning_app/src/features/auth/bloc/verify_code/verify_code_bloc.dart';
import 'package:learning_app/src/features/auth/pages/login_page.dart';

class VerifyCodeScreen extends StatelessWidget {
  final String email;

  const VerifyCodeScreen({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VerifyCodeBloc(
        authRepository: context.read<AuthRepository>(),
        email: email,
      ),
      child: const VerifyCodeView(),
    );
  }
}

class VerifyCodeView extends StatefulWidget {
  const VerifyCodeView({super.key});

  @override
  State<VerifyCodeView> createState() => _VerifyCodeViewState();
}

class _VerifyCodeViewState extends State<VerifyCodeView> {
  final List<TextEditingController> _controllers = List.generate(
    6,
        (index) => TextEditingController(),
  );

  final List<FocusNode> _focusNodes = List.generate(
    6,
        (index) => FocusNode(),
  );

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final email = context.select((VerifyCodeBloc bloc) => bloc.email);

    return BlocListener<VerifyCodeBloc, VerifyCodeState>(
      listenWhen: (previous, current) =>
      previous.status != current.status ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.status == VerifyCodeStatus.success) {
          // TODO: Navigate to the next screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Xác thực thành công')),
          );
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_){
            return const LoginPage();
          }));
        } else if (state.status == VerifyCodeStatus.failure && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        } else if (state.status == VerifyCodeStatus.resendSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã gửi lại mã xác thực thành công')),
          );
        } else if (state.status == VerifyCodeStatus.resendFailure && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gửi lại mã thất bại: ${state.errorMessage}')),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Xác thực Email'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  const Icon(
                    Icons.email_outlined,
                    size: 80,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Mã xác thực đã được gửi đến',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    email,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      6,
                          (index) => _buildCodeInput(index),
                    ),
                  ),
                  const SizedBox(height: 40),
                  BlocBuilder<VerifyCodeBloc, VerifyCodeState>(
                    buildWhen: (previous, current) => previous.status != current.status,
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: state.status == VerifyCodeStatus.submitting
                            ? null
                            : () {
                          context.read<VerifyCodeBloc>().add(VerifyCodeSubmitted());
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: Colors.lightBlue,

                        ),
                        child: state.status == VerifyCodeStatus.submitting
                            ? const CircularProgressIndicator()
                            : const Text('Xác thực',style: TextStyle(color: Colors.white),),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<VerifyCodeBloc, VerifyCodeState>(
                    buildWhen: (previous, current) => previous.status != current.status,
                    builder: (context, state) {
                      return TextButton(
                        onPressed: state.status == VerifyCodeStatus.resending
                            ? null
                            : () {
                          context.read<VerifyCodeBloc>().add(ResendCodeRequested());
                        },
                        child: state.status == VerifyCodeStatus.resending
                            ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2)
                        )
                            : const Text('Gửi lại mã'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCodeInput(int index) {
    return SizedBox(
      width: 45,
      child: BlocBuilder<VerifyCodeBloc, VerifyCodeState>(
        buildWhen: (previous, current) =>
        previous.codes[index] != current.codes[index],
        builder: (context, state) {
          // Ensure the controller reflects the current state
          if (_controllers[index].text != state.codes[index]) {
            _controllers[index].text = state.codes[index];
          }

          return TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: const TextStyle(fontSize: 24),
            decoration: const InputDecoration(
              counterText: '',
              enabledBorder: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2),
              ),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (value) {
              context.read<VerifyCodeBloc>().add(VerifyCodeChanged(value, index));

              if (value.isNotEmpty && index < 5) {
                _focusNodes[index + 1].requestFocus();
              }

              // Auto verify when all digits are entered
              if (index == 5 && value.isNotEmpty && state.isValid) {
                context.read<VerifyCodeBloc>().add(VerifyCodeSubmitted());
              }
            },
          );
        },
      ),
    );
  }
}