import 'package:english_quiz/features/authentication/birthday_screen.dart';
import 'package:flutter/material.dart';
import 'package:english_quiz/constants/sizes.dart';
import 'package:english_quiz/constants/gaps.dart';
import 'package:english_quiz/features/widgets/form_button.dart';

class StudentNumberScreen extends StatefulWidget {
  Map<String, dynamic> userData;
  StudentNumberScreen({super.key, required this.userData});

  @override
  State<StudentNumberScreen> createState() => _StudentNumberScreenState();
}

class _StudentNumberScreenState extends State<StudentNumberScreen> {
  final TextEditingController _studentNumberController =
      TextEditingController();
  String _studentNumber = "";

  @override
  void initState() {
    super.initState();
    _studentNumberController.addListener(() {
      setState(() {
        _studentNumber = _studentNumberController.text;
      });
    });
  }

  @override
  void dispose() {
    _studentNumberController.dispose();
    super.dispose();
  }

  void onPasswordTap() {
    if (_studentNumber.isEmpty || isStudentNumberValid() != null) {
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BirthdayScreen(userData: {
          'nickname': widget.userData['nickname'],
          'password': widget.userData['password'],
          'name': widget.userData['name'],
          'studentNumber': _studentNumber,
        }),
      ),
    );
  }

  void onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  String? isStudentNumberValid() {
    if (_studentNumber.isEmpty) {
      return null;
    }
    final regExp = RegExp(r'^[1-3][1-8]\d{2}$');
    if (!regExp.hasMatch(_studentNumber)) {
      return "Student Number incorrect formats";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onScaffoldTap,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "Sign Up",
            style: TextStyle(),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.size36,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gaps.v40,
              const Text(
                "Enter your Student Number",
                style: TextStyle(
                  fontSize: Sizes.size20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Gaps.v8,
              const Text(
                "You cannot change it for one year.",
                style: TextStyle(
                  fontSize: Sizes.size16,
                  color: Colors.black54,
                ),
              ),
              Gaps.v16,
              TextFormField(
                onSaved: (newValue) {
                  _studentNumber = newValue.toString();
                },
                keyboardType: TextInputType.number,
                controller: _studentNumberController,
                cursorColor: Theme.of(context).primaryColor,
                decoration: InputDecoration(
                  errorText: isStudentNumberValid(),
                  hintText: "StudentNumber ex) 2212",
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
              ),
              Gaps.v16,
              GestureDetector(
                onTap: onPasswordTap,
                child: FormButton(
                  disabled: _studentNumber.isEmpty,
                  text: "Next",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
