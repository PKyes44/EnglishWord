import 'package:english_quiz/constants/sizes.dart';
import 'package:english_quiz/features/authentication/sign_up_screen.dart';
import 'package:english_quiz/features/menu/menu_screen.dart';
import 'package:english_quiz/features/questions/question_list_screen.dart';
import 'package:english_quiz/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'features/authentication/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const EnglishQuizApp());
}

class EnglishQuizApp extends StatelessWidget {
  const EnglishQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EnglishQuizApp',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: Sizes.size16 + Sizes.size2,
            fontWeight: FontWeight.w600,
          ),
        ),
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xffFF9F40),
      ),
<<<<<<< HEAD
      home: const SignUpScreen(),
=======
>>>>>>> 731c610a8ab47c1a915f977873678f55f64e0878
    );
  }
}
