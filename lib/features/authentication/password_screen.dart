import 'package:english_quiz/features/authentication/name_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:english_quiz/constants/sizes.dart';
import 'package:english_quiz/constants/gaps.dart';
import 'package:english_quiz/features/widgets/form_button.dart';

class PasswordScreen extends StatefulWidget {
  Map<String, dynamic> userData;
  PasswordScreen({
    super.key,
    required this.userData,
  });

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  String _password = "";
  bool obscureText = true;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      setState(() {
        _password = _passwordController.text;
      });
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  bool isPasswordValid() {
    return _password.isNotEmpty && _password.length > 8;
  }

  void onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  void onSubmit() {
    if (!isPasswordValid()) {
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NameScreen(
          userData: {
            'nickname': widget.userData['nickname'],
            'password': _password,
          },
        ),
      ),
    );
  }

  void onClearTap() {
    _passwordController.clear();
  }

  void toggleObscureText() {
    setState(() {
      obscureText = !obscureText;
    });
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
                "Password",
                style: TextStyle(
                  fontSize: Sizes.size20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Gaps.v16,
              TextFormField(
                onSaved: (newValue) {
                  _password = newValue.toString();
                },
                obscureText: obscureText,
                onEditingComplete: onSubmit,
                autocorrect: false,
                controller: _passwordController,
                cursorColor: Theme.of(context).primaryColor,
                decoration: InputDecoration(
                  suffix: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: onClearTap,
                        child: FaIcon(
                          FontAwesomeIcons.solidCircleXmark,
                          color: Colors.grey.shade500,
                          size: Sizes.size20,
                        ),
                      ),
                      Gaps.h16,
                      GestureDetector(
                        onTap: toggleObscureText,
                        child: FaIcon(
                          obscureText
                              ? FontAwesomeIcons.eye
                              : FontAwesomeIcons.eyeSlash,
                          color: Colors.grey.shade500,
                          size: Sizes.size20,
                        ),
                      ),
                    ],
                  ),
                  // errorText: "",
                  hintText: "Password",
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
              Gaps.v10,
              const Text(
                "Your password must have:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gaps.v10,
              Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.circleCheck,
                    size: Sizes.size20,
                    color: isPasswordValid() ? Colors.green : Colors.grey,
                  ),
                  Gaps.h5,
                  const Text("8 to 20 characters"),
                ],
              ),
              Gaps.v16,
              GestureDetector(
                onTap: onSubmit,
                child: FormButton(
                  disabled: !isPasswordValid(),
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
