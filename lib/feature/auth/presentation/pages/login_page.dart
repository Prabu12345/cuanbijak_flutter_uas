import 'package:cuanbijak_flutter_uas/core/common/widgets/loader_widget.dart';
import 'package:cuanbijak_flutter_uas/core/theme/app_pallete.dart';
import 'package:cuanbijak_flutter_uas/core/utils/show_snackbar.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/presentation/pages/register_page.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/presentation/widgets/auth_button.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/presentation/widgets/auth_field.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/presentation/pages/transaction_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const LoginPage(),
      );
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            showSnackBar(context, state.message);
          } else if (state is AuthSuccess) {
            Navigator.pushAndRemoveUntil(
                context, TransactionPage.route(), (route) => false);
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const LoaderWidget();
          }
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.tealAccent, Colors.blueAccent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Login',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 25),
                        AuthField(
                            hintText: "Email",
                            hintIcon: const Icon(Icons.person),
                            controller: emailController),
                        const SizedBox(height: 15),
                        AuthField(
                          hintText: "Password",
                          hintIcon: const Icon(Icons.lock),
                          controller: passwordController,
                          isObscureText: true,
                        ),
                        const SizedBox(height: 15),
                        AuthButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                    AuthLogin(
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim(),
                                    ),
                                  );
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, RegisterPage.route());
                          },
                          child: RichText(
                            text: TextSpan(
                                text: 'Don\'t have an account? ',
                                style: Theme.of(context).textTheme.titleMedium,
                                children: [
                                  TextSpan(
                                    text: 'Sign Up',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: AppPallete.gradient2,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ]),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
