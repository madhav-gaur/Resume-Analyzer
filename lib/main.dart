import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resume_analyzer/firebase_options.dart';
import 'package:resume_analyzer/router/router.dart';
import 'package:resume_analyzer/theme/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        routerConfig: appRouter,
        title: "Resume Analyzer",
        themeMode: ThemeMode.dark,
        theme: ThemeData(
          brightness: Brightness.dark,

          scaffoldBackgroundColor: Colors.black,
          appBarTheme: AppBarThemeData(
            backgroundColor: AppColors.background,
            elevation: 0,
            scrolledUnderElevation: 0,
            //   shape: RoundedRectangleBorder(
            //     side: BorderSide(color: AppColors.lightGrey),
            //   ),
            //   centerTitle: true,
            //   titleTextStyle: AppFonts.screenTitle.copyWith(
            //     color: AppColors.primary,
            //   ),
            // ),
          ),
        ),
      ),
    );
  }
}
