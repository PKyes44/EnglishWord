import 'package:english_quiz/features/authentication/login_screen.dart';
import 'package:english_quiz/features/authentication/sign_up_screen.dart';
import 'package:english_quiz/features/menu/menu_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:english_quiz/constants/sizes.dart';
import 'package:english_quiz/constants/gaps.dart';
import 'package:english_quiz/features/widgets/form_button.dart';

class BirthdayScreen extends StatefulWidget {
  Map<String, dynamic> userData;
  BirthdayScreen({super.key, required this.userData});

  @override
  State<BirthdayScreen> createState() => _BirthdayScreenState();
}

class _BirthdayScreenState extends State<BirthdayScreen> {
  final TextEditingController _birthdayController = TextEditingController();
  var _birthday;
  final DateTime maxDate = DateTime(
      DateTime.now().year - 16, DateTime.now().month, DateTime.now().day);

  @override
  void initState() {
    super.initState();
    setTextFieldDate(maxDate);
  }

  @override
  void dispose() {
    _birthdayController.dispose();
    super.dispose();
  }

  void onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  void setTextFieldDate(DateTime date) {
    String textDate = date.toString().split(" ").first;
    _birthdayController.value = TextEditingValue(text: textDate);
    _birthday = date;
    setState(() {});
  }

  void writeUser() {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref('user/${widget.userData['nickname']}');
    var data = {
      'nickname': widget.userData['nickname'],
      'name': widget.userData['name'],
      'password': widget.userData['password'],
      'birthday': _birthday,
      'grade': (DateTime.now().year - _birthday.year - 15).toString(),
    };
    ref.set(data);
    print("data: $data");
  }

  void onSubmit() async {
    // writeUser();
    var data = {
      'nickname': widget.userData['nickname'],
      'name': widget.userData['name'],
      'password': widget.userData['password'],
      'birthday': _birthday.toString(),
      'grade': (DateTime.now().year - _birthday.year - 15).toString(),
    };
    print("data: $data");
    FirebaseDatabase ref = FirebaseDatabase.instance;
    await ref.ref().child('user/${widget.userData['nickname']}').set(data);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
    );
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
                "When is your birthday?",
                style: TextStyle(
                  fontSize: Sizes.size20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Gaps.v8,
              const Text(
                "Your birthday won't be shown publicly",
                style: TextStyle(
                  fontSize: Sizes.size16,
                  color: Colors.black54,
                ),
              ),
              Gaps.v16,
              TextFormField(
                onSaved: (newValue) {
                  _birthday = newValue;
                },
                style: const TextStyle(
                  color: Colors.black,
                ),
                enabled: false,
                controller: _birthdayController,
                decoration: InputDecoration(
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
                onTap: onSubmit,
                child: const FormButton(
                  disabled: false,
                  text: "Next",
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: SizedBox(
            height: 300,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              maximumDate: maxDate,
              initialDateTime: maxDate,
              onDateTimeChanged: setTextFieldDate,
            ),
          ),
        ),
      ),
    );
  }
}
