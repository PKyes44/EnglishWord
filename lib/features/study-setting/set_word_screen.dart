import 'package:english_quiz/constants/gaps.dart';
import 'package:english_quiz/constants/sizes.dart';
import 'package:english_quiz/features/widgets/form_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetWordScreen extends StatefulWidget {
  final String nickname;
  const SetWordScreen({super.key, required this.nickname});

  @override
  State<SetWordScreen> createState() => _SetWordScreenState();
}

class _SetWordScreenState extends State<SetWordScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isCheckGrade1 = false;
  bool isCheckGrade2 = false;
  bool isShow = false;
  String word = '';
  String mean = '';
  List<Map<dynamic, dynamic>> wordData = List.empty(growable: true);
  late SharedPreferences _prefs; // SharedPreferences 객체
  List<String> words = List.empty(growable: true);
  List<String> means = List.empty(growable: true);

  @override
  void initState() {
    loadWords();
    loadWords();
    // TODO: implement initState
    super.initState();
    _initSharedPreferences(); // SharedPreferences 초기화
    if (getWordList() != null) {
      wordData = getWordList()!;
    }
  }

  void targetGrade1Tap() {
    setState(() {
      isCheckGrade1 = !isCheckGrade1;
    });
  }

  void targetGrade2Tap() {
    setState(() {
      isCheckGrade2 = !isCheckGrade2;
    });
  }

  bool isKorean(String text) {
    if (text.isEmpty) {
      return false;
    }

    final regExp = RegExp(r'(^[ㄱ-ㅎ가-힣]*$)');
    if (regExp.hasMatch(text)) {
      return true;
    }
    return false;
  }

  bool isEnglish(String text) {
    if (text.isEmpty) {
      return false;
    }

    final regExp = RegExp(r'(^[a-zA-Z ]*$)');
    if (regExp.hasMatch(text)) {
      return true;
    }
    return false;
  }

  void onSubmit() {
    if (formKey.currentState != null) {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
      }
    }
    writeWords();
    setState(() {
      if (getWordList() != null) {
        wordData = getWordList()!;
      }
    });
  }

  void onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  void onMenuTap() {
    Navigator.of(context).pop();
  }

  void switchShow() {
    setState(() {
      isShow = !isShow;
    });
  }

  void removeWord(int index) {
    setState(() {
      wordData.removeAt(index);
      FirebaseDatabase.instance.ref('user/user1/').update({
        "words": wordData,
      });
    });
    print("Remove wordData : $wordData");
  }

  void writeWords() {
    int wordCount = wordData.length;
    DatabaseReference ref = FirebaseDatabase.instance
        .ref('user/${widget.nickname}/words/$wordCount');
    ref.set(
      {
        "word": word,
        "mean": mean,
      },
    );
    print("wordCount2 : $wordCount");
    FirebaseDatabase.instance.ref('user/user1/').update({
      "wordCount": wordCount,
    });
  }

  Future<List<Object?>> readWords() async {
    final reference = FirebaseDatabase.instance.ref();
    DataSnapshot snapshot =
        await reference.child('user/${widget.nickname}/words/').get();
    try {
      final readData = snapshot.value as List<Object?>;
      return readData;
    } catch (e) {
      return [null];
    }
  }

  List<Map<String, String>>? getWordList() {
    Future<List<Object?>> wordList = readWords();
    wordList.then((words) async {
      wordData.clear();
      for (var word in words) {
        if (word == null) {
          continue;
        }
        Map<String, dynamic> post = Map<String, dynamic>.from(word as Map);
        setState(() {
          wordData.add(post);
        });
      }
      print("WordList : $wordData");
      return wordData;
    });
    return null;
  }

  // SharedPreferences 초기화 함수
  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // 데이터를 저장하는 함수
  Future<void> _saveData() async {
    words.add(word);
    means.add(mean);
    _prefs.setStringList('words', words);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('저장완료 : Words')), // 저장 완료 메시지 출력
    );

    _prefs.setStringList('means', means);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('저장완료 : Means')), // 저장 완료 메시지 출력
    );

    print("words : $words");
    print("means : $means");
  }

  // 데이터를 로드하는 함수
  Future<List<String>> loadWords() async {
    final myData = _prefs.getString('words'); // 'myData' 키에 저장된 데이터 로드
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('로드완료 : Words')), // 로드 완료 메시지와 함께 데이터 출력
    );
    words = myData!.split(',');
    return myData.split(',');
  }

  // 데이터를 로드하는 함수
  Future<List<String>> loadMeans() async {
    final myData = _prefs.getString('means'); // 'myData' 키에 저장된 데이터 로드
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('로드완료 : Means')), // 로드 완료 메시지와 함께 데이터 출력
    );
    means = myData!.split(',');
    return myData.split(',');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onScaffoldTap,
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: Sizes.size16,
                    left: Sizes.size20,
                    right: Sizes.size20,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                          onTap: onMenuTap,
                          child: const Icon(Icons.arrow_back_ios)),
                      Gaps.h10,
                      const Image(
                        image: AssetImage('assets/number_one.png'),
                      ),
                      Gaps.h16,
                      const Text(
                        "Word Settings",
                        style: TextStyle(
                          fontSize: Sizes.size20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Gaps.v16,
                Container(
                  height: 1.0,
                  width: double.infinity,
                  color: Theme.of(context).primaryColor,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.size20,
                    vertical: Sizes.size16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              onSaved: (newValue) {
                                word = newValue.toString();
                              },
                              decoration: const InputDecoration(
                                hintText: "Word",
                              ),
                              validator: (value) {
                                if (!isEnglish(value.toString())) {
                                  return "Word is not English";
                                }
                                return null;
                              },
                            ),
                            Gaps.v16,
                            TextFormField(
                              onSaved: (newValue) {
                                mean = newValue.toString();
                              },
                              decoration: const InputDecoration(
                                hintText: "Mean",
                              ),
                              validator: (value) {
                                if (!isKorean(value.toString())) {
                                  return "Word is not Korean";
                                }
                                return null;
                              },
                            ),
                            Gaps.v20,
                            GestureDetector(
                              onTap: onSubmit,
                              child: const FormButton(
                                disabled: false,
                                text: "Add",
                              ),
                            ),
                          ],
                        ),
                      ),
                      Gaps.v24,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "My Word List",
                            style: TextStyle(
                              fontSize: Sizes.size20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          GestureDetector(
                            onTap: switchShow,
                            child: Text(isShow ? "접기" : "펼치기"),
                          ),
                        ],
                      ),
                      Gaps.v10,
                      Wrap(
                        runSpacing: 5,
                        children: [
                          for (int i = 0;
                              i <
                                  (isShow || wordData.length < 5
                                      ? wordData.length
                                      : 5);
                              i++)
                            drawWordList(i)
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container drawWordList(int index) {
    print("WordData : $wordData");
    print("drawWord : ${wordData[index]}");
    Container container = Container();
    container = Container(
      padding: const EdgeInsets.symmetric(
        vertical: Sizes.size16,
        horizontal: Sizes.size24,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          Sizes.size20,
        ),
        border: Border.all(
          color: Colors.black.withOpacity(0.4),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                wordData[index]['word'] ?? "",
                style: const TextStyle(
                  fontSize: Sizes.size16,
                ),
              ),
              Gaps.v5,
              Text(
                wordData[index]['mean'] ?? "",
                style: const TextStyle(
                  fontSize: Sizes.size16,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => removeWord(index),
            child: const FaIcon(FontAwesomeIcons.circleXmark),
          ),
        ],
      ),
    );
    return container;
  }
}
