import 'package:english_quiz/features/authentication/password_screen.dart';
import 'package:flutter/material.dart';
import 'package:english_quiz/constants/sizes.dart';
import 'package:english_quiz/constants/gaps.dart';
import 'package:english_quiz/features/widgets/form_button.dart';

class NickNameScreen extends StatefulWidget {
  const NickNameScreen({super.key});

  @override
  State<NickNameScreen> createState() => _NickNameScreenState();
}

class _NickNameScreenState extends State<NickNameScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  String _nickname = "";

  @override
  void initState() {
    super.initState();
    _nicknameController.addListener(() {
      setState(() {
        _nickname = _nicknameController.text;
      });
    });
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  void onStudentNumberTap() {
    if (_nickname.isEmpty) return;
    print(_nickname);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PasswordScreen(
          userData: {'nickname': _nickname},
        ),
      ),
    );
  }

  void onScaffoldTap() {
    FocusScope.of(context).unfocus();
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
                "Create nickname",
                style: TextStyle(
                  fontSize: Sizes.size20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Gaps.v8,
              const Text(
                "You can always change this later.",
                style: TextStyle(
                  fontSize: Sizes.size16,
                  color: Colors.black54,
                ),
              ),
              Gaps.v16,
              TextFormField(
                onSaved: (newValue) {
                  _nickname = newValue.toString();
                },
                controller: _nicknameController,
                cursorColor: Theme.of(context).primaryColor,
                decoration: InputDecoration(
                  hintText: "Nickname",
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
                onTap: () => onStudentNumberTap(),
                child: FormButton(
                  disabled: _nickname.isEmpty,
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
