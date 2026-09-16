import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:resume_analyzer/components/buttons.dart';
import 'package:resume_analyzer/components/text_field.dart';
import 'package:resume_analyzer/router/routes.dart';
import 'package:resume_analyzer/services/auth_service.dart';
import 'package:resume_analyzer/theme/app_colors.dart';
import 'package:resume_analyzer/theme/app_fonts.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignupState();
}

class _SignupState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;

  late TextEditingController _passwordController;
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String error = "";
  bool isLoading = false;
  void _handleSignIn() async {
    try {
      if (!_formKey.currentState!.validate() || isLoading) return;
      setState(() {
        isLoading = true;
        error = "";
      });
      final user = await AuthService().signin(
        email: _emailController.text,
        password: _passwordController.text,
      );
      log(user.toString());
      if (!mounted) return;

      context.go(AppRoutes.home);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      switch (e.code) {
        case 'invalid-credential':
        case 'wrong-password':
          setState(() {
            error = 'Incorrect email or password.';
          });
          break;

        case 'user-not-found':
          setState(() {
            error = 'No account found with this email.';
          });
          break;

        case 'invalid-email':
          setState(() {
            error = 'Please enter a valid email address.';
          });
          break;

        case 'user-disabled':
          setState(() {
            error = 'This account has been disabled.';
          });
          break;

        case 'too-many-requests':
          setState(() {
            error = 'Too many attempts. Please try again later.';
          });
          break;

        default:
          setState(() {
            error = 'Something went wrong. Please try again.';
          });
      }
    } catch (e) {
      log(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0F0F172A),
                    blurRadius: 16.0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Welcome Back",
                    style: AppFonts.screenTitle.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8.0),

                  Text(
                    "Sign in with Email and Password",
                    style: AppFonts.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24.0),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        AppTextField(
                          controller: _emailController,
                          label: "Email",
                          prefixIcon: Icons.email,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Provide Email";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        AppTextField(
                          controller: _passwordController,
                          isPassword: true,
                          prefixIcon: Icons.password,
                          label: "Password",
                          validator: (val) {
                            if (val!.length < 6) {
                              return "Password must be 6 character long";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 8),
                        if (error.isNotEmpty)
                          Chip(
                            side: BorderSide.none,
                            backgroundColor: Colors.white,

                            onDeleted: () => setState(() {
                              error = "";
                            }),
                            deleteIcon: Icon(Icons.clear),
                            label: Text(
                              error,
                              style: AppFonts.body.copyWith(
                                color: AppColors.danger,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  PrimaryButton(
                    label: "Sign In",
                    onPressed: () => _handleSignIn(),
                    isLoading: isLoading,
                  ),

                  SizedBox(height: 10),
                  InkWell(
                    splashColor: Colors.grey.shade100,
                    onTap: () => context.go(AppRoutes.signup),
                    child: Text(
                      "New user? Sign Up",
                      style: AppFonts.caption.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
