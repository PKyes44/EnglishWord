import 'package:english_quiz/features/authentication/birthday_screen.dart';
import 'package:english_quiz/features/authentication/student_number_screen.dart';
import 'package:flutter/material.dart';
import 'package:english_quiz/constants/sizes.dart';
import 'package:english_quiz/constants/gaps.dart';
import 'package:english_quiz/features/widgets/form_button.dart';

class NameScreen extends StatefulWidget {
  Map<String, dynamic> userData;
  NameScreen({super.key, required this.userData});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _name = "";

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      setState(() {
        _name = _nameController.text;
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void onStudentNumberTap() {
    if (_name.isEmpty) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BirthdayScreen(
          userData: {
            'nickname': widget.userData['nickname'],
            'password': widget.userData['password'],
            'name': _name,
          },
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
                "What is your name?",
                style: TextStyle(
                  fontSize: Sizes.size20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Gaps.v8,
              const Text(
                "You cannot change this later.",
                style: TextStyle(
                  fontSize: Sizes.size16,
                  color: Colors.black54,
                ),
              ),
              Gaps.v16,
              TextFormField(
                onSaved: (newValue) {
                  _name = newValue.toString();
                },
                controller: _nameController,
                cursorColor: Theme.of(context).primaryColor,
                decoration: InputDecoration(
                  hintText: "Name",
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
                  disabled: _name.isEmpty,
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
