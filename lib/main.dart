import 'package:english_quiz/constants/sizes.dart';
import 'package:english_quiz/features/authentication/sign_up_screen.dart';
import 'package:english_quiz/features/menu/menu_screen.dart';
import 'package:english_quiz/features/questions/question_list_screen.dart';
import 'package:english_quiz/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/authentication/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const EnglishQuizApp());
}

// ignore: must_be_immutable
class EnglishQuizApp extends StatefulWidget {
  const EnglishQuizApp({super.key});

  @override
  State<EnglishQuizApp> createState() => _EnglishQuizAppState();
}

class _EnglishQuizAppState extends State<EnglishQuizApp> {
  String nickname = '';
  // late SharedPreferences _prefs;
  @override
  void initState() {
    // init();
    // TODO: implement initState
    super.initState();
  }
  var data;

  // void init() async {}

  // 데이터를 로드하는 함수
  Future<bool> checkLoginLog() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final myData = prefs.getString('nickname'); // 'myData' 키에 저장된 데이터 로드
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('로드완료 : $myData')), // 로드 완료 메시지와 함께 데이터 출력
    );

    if (myData == null) {
      return false;
    }
    nickname = myData.toString();
    return true;
  }

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
      home: 
          ? MenuScreen(nickname: nickname)
          : const SignUpScreen(),
    );
  }
}
