import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:resume_analyzer/router/routes.dart';
import 'package:resume_analyzer/screens/home.dart';
import 'package:resume_analyzer/screens/signin.dart';
import 'package:resume_analyzer/screens/signup.dart';

final GoRouter appRouter = GoRouter(
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    log(user.toString());
    final isLoggedIn = user != null;

    final isAuthPage =
        state.matchedLocation == AppRoutes.signup ||
        state.matchedLocation == AppRoutes.signin;

    if (!isLoggedIn && !isAuthPage) {
      return AppRoutes.signup;
    }

    if (isLoggedIn && isAuthPage) {
      return AppRoutes.home;
    }

    return null;
  },
  routes: [
    GoRoute(path: AppRoutes.home, builder: (context, state) => Home()),
    GoRoute(path: AppRoutes.signup, builder: (context, state) => Signup()),
    GoRoute(path: AppRoutes.signin, builder: (context, state) => SignIn()),
  ],
);
