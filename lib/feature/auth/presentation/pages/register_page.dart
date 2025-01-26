import 'package:cuanbijak_flutter_uas/core/common/widgets/loader_widget.dart';
import 'package:cuanbijak_flutter_uas/core/theme/app_pallete.dart';
import 'package:cuanbijak_flutter_uas/core/utils/show_snackbar.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/presentation/pages/login_page.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/presentation/widgets/auth_button.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/presentation/widgets/auth_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const RegisterPage(),
      );
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            showSnackBar(context, state.message);
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
            child: SafeArea(
              child: Center(
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
                          'Register',
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
                            hintText: "Name",
                            hintIcon: const Icon(Icons.person),
                            controller: nameController),
                        const SizedBox(height: 15),
                        AuthField(
                            hintText: "Email",
                            hintIcon: const Icon(Icons.mail_outline),
                            controller: emailController),
                        const SizedBox(height: 15),
                        AuthField(
                          hintText: "Password",
                          hintIcon: const Icon(Icons.lock),
                          controller: passwordController,
                          isObscureText: true,
                        ),
                        const SizedBox(height: 15),
                        AuthField(
                          hintText: "Confirm Password",
                          hintIcon: const Icon(Icons.lock_outline),
                          controller: confirmPasswordController,
                          isObscureText: true,
                        ),
                        const SizedBox(height: 15),
                        AuthButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              if (passwordController.text.trim() ==
                                  confirmPasswordController.text.trim()) {
                                context.read<AuthBloc>().add(
                                      AuthRegister(
                                        email: emailController.text.trim(),
                                        password:
                                            passwordController.text.trim(),
                                        name: nameController.text.trim(),
                                      ),
                                    );
                              }
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              LoginPage.route(),
                            );
                          },
                          child: RichText(
                            text: TextSpan(
                                text: 'Already have an account? ',
                                style: Theme.of(context).textTheme.titleMedium,
                                children: [
                                  TextSpan(
                                    text: 'Sign In',
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
