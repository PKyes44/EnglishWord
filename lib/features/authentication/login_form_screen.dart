import 'package:english_quiz/features/menu/menu_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:english_quiz/constants/gaps.dart';
import 'package:english_quiz/constants/sizes.dart';
import 'package:english_quiz/features/widgets/form_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginFormScreen extends StatefulWidget {
  const LoginFormScreen({super.key});

  @override
  State<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, String> formData = {};

  Map<String, String> userData = {};
  late SharedPreferences _prefs; // SharedPreferences 객체

  String nickname = '';

  void _onSubmitTap() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        _saveData();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MenuScreen(
                      nickname: nickname,
                    )),
            (route) => false);
      }
    }
  }

  // 데이터를 저장하는 함수
  Future<void> _saveData() async {
    _prefs.setString('nickname', nickname);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('저장완료 : Words')), // 저장 완료 메시지 출력
    );
  }

  @override
  void initState() {
    var readData = readUserData();
    readData.then((value) {
      var tempData = value;
      var dataList = [];
      for (var data in tempData.values) {
        dataList.add(data);
      }
      for (var data in dataList) {
        userData[data['nickname']] = data['password'];
        setState(() {});
      }
      print('userData : $userData');
    });
    // TODO: implement initState
    super.initState();
  }

  Future<Map<Object?, Object?>> readUserData() async {
    final reference = FirebaseDatabase.instance.ref();
    DataSnapshot snapshot = await reference.child('user/').get();
    return snapshot.value as Map<Object?, Object?>;
  }

  bool matchNickname(String nickname) {
    if (!userData.containsKey(nickname)) {
      return false;
    }
    return true;
  }

  bool matchPassword(String password) {
    if (!userData.containsValue(password)) {
      return false;
    }
    return true;
  }

  bool matchData(String password) {
    if (userData[nickname] == password) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log in'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.size36,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Gaps.v28,
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Nickname',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return "Plase write your nickname";
                  }
                  if (!matchNickname(value.toString())) {
                    return "Wrong nickname";
                  }
                  nickname = value.toString();
                  return null;
                },
                onSaved: (newValue) {
                  if (newValue != null) {
                    formData['nickname'] = newValue;
                  }
                },
              ),
              Gaps.v16,
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Password',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return "Plase write your password";
                  }
                  if (!matchPassword(value.toString()) ||
                      !matchData(value.toString())) {
                    return "Wrong password";
                  }
                  return null;
                },
                onSaved: (newValue) {
                  if (newValue != null) {
                    formData['password'] = newValue;
                  }
                },
              ),
              Gaps.v28,
              GestureDetector(
                onTap: _onSubmitTap,
                child: const FormButton(disabled: false, text: "Log in"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
