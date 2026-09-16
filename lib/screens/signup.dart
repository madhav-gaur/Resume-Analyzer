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

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _nameController;
  late TextEditingController _passwordController;
  late TextEditingController _cPasswordController;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _cPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _cPasswordController.dispose();
    super.dispose();
  }

  String error = "";
  bool isLoading = false;
  void _handleSignUp() async {
    try {
      if (!_formKey.currentState!.validate() || isLoading) return;
      setState(() {
        isLoading = true;
        error = "";
      });

      final user = await AuthService().signup(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );
      log(user.toString());
      if (!mounted) return;
      context.go(AppRoutes.home);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = "An account already exists with this email.";
          break;

        case 'weak-password':
          message = "Password is too weak.";
          break;

        case 'invalid-email':
          message = "Enter a valid email.";
          break;

        default:
          message = "Something went Wrong";
          break;
      }
      setState(() {
        error = message;
      });
    } catch (e) {
      log(e.toString());
      if (mounted) {
        setState(() {
          error = "Something went Wrong";
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.0),
            child: Container(
              padding: EdgeInsets.all(24.0),
              decoration: BoxDecoration(
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
                    "Create Account",
                    style: AppFonts.screenTitle.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8.0),

                  Text(
                    "Sign up to Power your Resume.",
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
                          controller: _nameController,
                          label: "Name",
                          prefixIcon: Icons.person,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Provide Name";
                            }
                            if (val.length < 2) {
                              return "Name should be at Least 3 Charcter Long";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 8),
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
                        SizedBox(height: 8),
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
                        AppTextField(
                          controller: _cPasswordController,
                          isPassword: true,
                          prefixIcon: Icons.password,
                          label: "Confirm Password",
                          validator: (val) {
                            if (val != _passwordController.text) {
                              return "Confirm Password doesn't match";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 8),
                        if (error.isNotEmpty)
                          Chip(
                            side: BorderSide.none,
                            backgroundColor: AppColors.surface,

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
                    label: "Sign Up",
                    onPressed: () => _handleSignUp(),
                    isLoading: isLoading,
                  ),
                  SizedBox(height: 10),
                  InkWell(
                    splashColor: Colors.grey.shade100,
                    onTap: () => context.go(AppRoutes.signin),
                    child: Text(
                      "Already a user? Sign In",
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
