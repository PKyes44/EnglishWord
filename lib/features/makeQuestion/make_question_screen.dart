import 'package:english_quiz/constants/gaps.dart';
import 'package:english_quiz/constants/sizes.dart';
import 'package:english_quiz/features/widgets/form_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';

class MakeQuestionScreen extends StatefulWidget {
  const MakeQuestionScreen({super.key});

  @override
  State<MakeQuestionScreen> createState() => _MakeQuestionScreenState();
}

class _MakeQuestionScreenState extends State<MakeQuestionScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isCheckGrade1 = false;
  bool isCheckGrade2 = false;
  bool multipleQCheck = false;
  bool ABCQCheck = false;
  String userId = 'user1';
  bool isShow = false;
  String word = '';
  String mean = '';
  List<Map<dynamic, dynamic>?> storyData = List.empty(growable: true);
  List<bool> checkList = List.empty(growable: true);
  int? storyIndex;
  Map<String, String> questionData = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStoryList();
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

  void multipleQTap() {
    setState(() {
      multipleQCheck = !multipleQCheck;
      ABCQCheck = false;
    });
  }

  void ABCQTap() {
    setState(() {
      ABCQCheck = !ABCQCheck;
      multipleQCheck = false;
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

  void switchCheck(int index) {
    setState(() {
      for (int i = 0; i < checkList.length; i++) {
        if (i == index) {
          checkList[i] = !checkList[i];
        } else {
          checkList[i] = false;
        }
      }
      storyIndex = index;
    });
  }

  Future<String> getGrade() async {
    final reference = FirebaseDatabase.instance.ref();
    DataSnapshot snapshot = await reference.child('user/$userId/grade').get();
    try {
      final readData = snapshot.value.toString();
      return readData;
    } catch (e) {
      return "";
    }
  }

  Future<dynamic> getStoryList() async {
    String grade;
    getGrade().then((value) async {
      grade = value;
      final reference = FirebaseDatabase.instance.ref();
      DataSnapshot snapshot = await reference.child('story/$grade').get();
      try {
        final readData = snapshot.value as Map<dynamic, dynamic>?;
        print("readData : ${readData!.keys}");
        List<Map<dynamic, dynamic>> returnData = List.empty(growable: true);
        for (var readDataKey in readData.keys) {
          returnData.add(readData[readDataKey]);
          checkList.add(false);
        }
        setState(() {
          storyData = returnData;
        });
        return returnData;
      } catch (e) {
        try {
          final readData2 = snapshot.value as Map<dynamic, dynamic>;
          print("readData2 : ${readData2.keys}");
          var returnData = [];
          for (var readDataKey in readData2.keys) {
            returnData.add(readData2[readDataKey]);
          }
          setState(() {
            storyData.add(returnData as Map<dynamic, dynamic>);
          });
          return returnData;
        } catch (e) {
          print("final ReadData");
          return [null];
        }
      }
    });
  }

  void writeQuestion() {
    var uuid = const Uuid();
    var questionId = uuid.v4();
    var title = questionData['title'];
    var questionText = questionData['questionText'];
    var answer = questionData['answer'];

    if (multipleQCheck) {
      var data = {
        "questionId": questionId,
        "title": title,
        "questionText": questionText,
        "q1": questionData['q1'],
        "q2": questionData['q2'],
        "q3": questionData['q3'],
        "q4": questionData['q4'],
        "q5": questionData['q5'],
        "answer": answer,
        "questionType": "multiples",
        "userId": userId,
      };

      if (storyIndex != null) {
        data['story'] = storyData[storyIndex!]!['storyId'];
      }

      if (isCheckGrade1) {
        DatabaseReference ref =
            FirebaseDatabase.instance.ref('questions/1/$questionId');
        ref.set(data);
      }
      if (isCheckGrade2) {
        DatabaseReference ref =
            FirebaseDatabase.instance.ref('questions/2/$questionId');
        ref.set(data);
      }
    }
    if (ABCQCheck) {
      var data = {
        "questionId": questionId,
        "title": title,
        "questionText": questionText,
        "q1": questionData['q1'],
        "q2": questionData['q2'],
        "q3": questionData['q3'],
        "q4": questionData['q4'],
        "q5": questionData['q5'],
        "answer": answer,
        "questionType": "ABC",
        "userId": userId,
        "A": questionData['A'],
        "B": questionData['B'],
        "C": questionData['C'],
      };

      if (storyIndex != null) {
        data['story'] = storyData[storyIndex!]!['storyId'];
      }

      if (isCheckGrade1) {
        DatabaseReference ref =
            FirebaseDatabase.instance.ref('questions/1/$questionId');
        ref.set(data);
      }
      if (isCheckGrade2) {
        DatabaseReference ref =
            FirebaseDatabase.instance.ref('questionss/2/$questionId');
        ref.set(data);
      }
    }
  }

  void onSubmit() {
    if (!isCheckGrade1 && !isCheckGrade2) {
      return;
    }

    if (formKey.currentState != null) {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        writeQuestion();
        Navigator.of(context).pop();
      }
    }
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
                        "Question Form",
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
                      Column(
                        children: [
                          const Text(
                            "Target Grade",
                            style: TextStyle(
                              fontSize: Sizes.size20,
                            ),
                          ),
                          Gaps.v10,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: targetGrade1Tap,
                                child: FaIcon(isCheckGrade1
                                    ? FontAwesomeIcons.solidSquareCheck
                                    : FontAwesomeIcons.squareCheck),
                              ),
                              Gaps.h10,
                              const Text(
                                "1학년",
                                style: TextStyle(
                                  fontSize: Sizes.size16,
                                ),
                              ),
                              Gaps.h20,
                              GestureDetector(
                                onTap: targetGrade2Tap,
                                child: FaIcon(isCheckGrade2
                                    ? FontAwesomeIcons.solidSquareCheck
                                    : FontAwesomeIcons.squareCheck),
                              ),
                              Gaps.h10,
                              const Text(
                                "2학년",
                                style: TextStyle(
                                  fontSize: Sizes.size16,
                                ),
                              ),
                            ],
                          ),
                          Gaps.v5,
                          if (!isCheckGrade1 && !isCheckGrade2)
                            const Text(
                              "1개 이상의 학년을 선택해야 합니다.",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: Sizes.size14,
                              ),
                            ),
                          Text(
                            "주의 : 생성된 문제는 선택된 학년에게만 추가됩니다.",
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: Sizes.size12,
                            ),
                          ),
                        ],
                      ),
                      Gaps.v16,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Story List",
                                style: TextStyle(
                                  fontSize: Sizes.size20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "문제에 구문이 필요하다면 선택하세요",
                                style: TextStyle(
                                  fontSize: Sizes.size10,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
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
                                  (isShow || storyData.length < 5
                                      ? storyData.length
                                      : 5);
                              i++)
                            drawWordList(i)
                        ],
                      ),
                      Gaps.v16,
                      Column(
                        children: [
                          const Text(
                            "Question Type",
                            style: TextStyle(
                              fontSize: Sizes.size20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Gaps.v10,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: multipleQTap,
                                child: FaIcon(multipleQCheck
                                    ? FontAwesomeIcons.solidSquareCheck
                                    : FontAwesomeIcons.squareCheck),
                              ),
                              Gaps.h10,
                              const Text(
                                "객관식",
                                style: TextStyle(
                                  fontSize: Sizes.size16,
                                ),
                              ),
                              Gaps.h20,
                              GestureDetector(
                                onTap: ABCQTap,
                                child: FaIcon(ABCQCheck
                                    ? FontAwesomeIcons.solidSquareCheck
                                    : FontAwesomeIcons.squareCheck),
                              ),
                              Gaps.h10,
                              const Text(
                                "ㄱㄴㄷ",
                                style: TextStyle(
                                  fontSize: Sizes.size16,
                                ),
                              ),
                            ],
                          ),
                          Gaps.v24,
                          if (multipleQCheck) drawMultipleQuestionFrom(),
                          if (ABCQCheck) drawABCQuestionForm()
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

  Form drawABCQuestionForm() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            onSaved: (newValue) {
              questionData['title'] = newValue.toString();
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Sizes.size10),
              ),
              labelText: "Title",
              labelStyle: const TextStyle(
                fontSize: Sizes.size16,
              ),
            ),
          ),
          Gaps.v10,
          TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: 1,
            onSaved: (newValue) {
              questionData['questionText'] = newValue.toString();
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Sizes.size10),
              ),
              labelText: "Question Text",
              labelStyle: const TextStyle(
                fontSize: Sizes.size16,
              ),
            ),
          ),
          Gaps.v16,
          const Text(
            "Question View Setting",
            style: TextStyle(
              fontSize: Sizes.size20,
              fontWeight: FontWeight.w500,
            ),
          ),
          Gaps.v16,
          TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: 1,
            onSaved: (newValue) {
              questionData['A'] = newValue.toString();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter question As";
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Sizes.size10),
              ),
              labelText: "ㄱ.",
              labelStyle: const TextStyle(
                fontSize: Sizes.size16,
              ),
            ),
          ),
          Gaps.v10,
          TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: 1,
            onSaved: (newValue) {
              questionData['B'] = newValue.toString();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter question B";
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Sizes.size10),
              ),
              labelText: "ㄴ.",
              labelStyle: const TextStyle(
                fontSize: Sizes.size16,
              ),
            ),
          ),
          Gaps.v10,
          TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: 1,
            onSaved: (newValue) {
              questionData['C'] = newValue.toString();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter question C.";
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Sizes.size10),
              ),
              labelText: "ㄷ.",
              labelStyle: const TextStyle(
                fontSize: Sizes.size16,
              ),
            ),
          ),
          Gaps.v16,
          const Text(
            "Set Questions",
            style: TextStyle(
              fontSize: Sizes.size20,
              fontWeight: FontWeight.w500,
            ),
          ),
          Gaps.v16,
          TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: 1,
            onSaved: (newValue) {
              questionData['q1'] = newValue.toString();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter question 1";
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Sizes.size10),
              ),
              labelText: "ex) ㄱ",
              labelStyle: const TextStyle(
                fontSize: Sizes.size16,
              ),
            ),
          ),
          Gaps.v10,
          TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: 1,
            onSaved: (newValue) {
              questionData['q2'] = newValue.toString();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter question 2";
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Sizes.size10),
              ),
              labelText: "ex) ㄴ",
              labelStyle: const TextStyle(
                fontSize: Sizes.size16,
              ),
            ),
          ),
          Gaps.v10,
          TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: 1,
            onSaved: (newValue) {
              questionData['q3'] = newValue.toString();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter question 3";
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Sizes.size10),
              ),
              labelText: "ex) ㄱ,ㄴ",
              labelStyle: const TextStyle(
                fontSize: Sizes.size16,
              ),
            ),
          ),
          Gaps.v10,
          TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: 1,
            onSaved: (newValue) {
              questionData['q4'] = newValue.toString();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter question 4";
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Sizes.size10),
              ),
              labelText: "ex) ㄱ,ㄷ",
              labelStyle: const TextStyle(
                fontSize: Sizes.size16,
              ),
            ),
          ),
          Gaps.v10,
          TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: 1,
            onSaved: (newValue) {
              questionData['q5'] = newValue.toString();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter question 5";
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Sizes.size10),
              ),
              labelText: "ex) ㄱ,ㄴ,ㄷ",
              labelStyle: const TextStyle(
                fontSize: Sizes.size16,
              ),
            ),
          ),
          Gaps.v16,
          const Text(
            "Set Answer",
            style: TextStyle(
              fontSize: Sizes.size20,
              fontWeight: FontWeight.w500,
            ),
          ),
          Gaps.v16,
          TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: 1,
            onSaved: (newValue) {
              questionData['answer'] = newValue.toString();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter answer.";
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Sizes.size10),
              ),
              labelText: "Answer.",
              labelStyle: const TextStyle(
                fontSize: Sizes.size16,
              ),
            ),
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
    );
  }

  Form drawMultipleQuestionFrom() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            onSaved: (newValue) {
              questionData['title'] = newValue.toString();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter title";
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Sizes.size10),
              ),
              labelText: "Title",
              labelStyle: const TextStyle(
                fontSize: Sizes.size16,
              ),
            ),
          ),
          Gaps.v10,
          TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: 2,
            onSaved: (newValue) {
              questionData['questionText'] = newValue.toString();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter question text.";
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Sizes.size10),
              ),
              labelText: "Question Text",
              labelStyle: const TextStyle(
                fontSize: Sizes.size16,
              ),
            ),
          ),
          Gaps.v16,
          const Text(
            "Set Questions",
            style: TextStyle(
              fontSize: Sizes.size20,
              fontWeight: FontWeight.w500,
            ),
          ),
          Gaps.v16,
          TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: 1,
            onSaved: (newValue) {
              questionData['q1'] = newValue.toString();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter question 1";
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Sizes.size10),
              ),
              labelText: "Question 1",
              labelStyle: const TextStyle(
                fontSize: Sizes.size16,
              ),
            ),
          ),
          Gaps.v10,
          TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: 1,
            onSaved: (newValue) {
              questionData['q2'] = newValue.toString();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter question 2";
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Sizes.size10),
              ),
              labelText: "Question 2",
              labelStyle: const TextStyle(
                fontSize: Sizes.size16,
              ),
            ),
          ),
          Gaps.v10,
          TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: 1,
            onSaved: (newValue) {
              questionData['q3'] = newValue.toString();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter question 3";
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Sizes.size10),
              ),
              labelText: "Question 3",
              labelStyle: const TextStyle(
                fontSize: Sizes.size16,
              ),
            ),
          ),
          Gaps.v10,
          TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: 1,
            onSaved: (newValue) {
              questionData['q4'] = newValue.toString();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter question 4";
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Sizes.size10),
              ),
              labelText: "Question 4",
              labelStyle: const TextStyle(
                fontSize: Sizes.size16,
              ),
            ),
          ),
          Gaps.v10,
          TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: 1,
            onSaved: (newValue) {
              questionData['q5'] = newValue.toString();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter question 5";
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Sizes.size10),
              ),
              labelText: "Question 5",
              labelStyle: const TextStyle(
                fontSize: Sizes.size16,
              ),
            ),
          ),
          Gaps.v16,
          const Text(
            "Set Answer",
            style: TextStyle(
              fontSize: Sizes.size20,
              fontWeight: FontWeight.w500,
            ),
          ),
          Gaps.v16,
          TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: 1,
            onSaved: (newValue) {
              questionData['answer'] = newValue.toString();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter answer.";
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Sizes.size10),
              ),
              labelText: "Answer.",
              labelStyle: const TextStyle(
                fontSize: Sizes.size16,
              ),
            ),
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
    );
  }

  Container drawWordList(int index) {
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
                storyData[index]?['title'] == null
                    ? ""
                    : storyData[index]!['title'].toString(),
                style: const TextStyle(
                  fontSize: Sizes.size16,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => switchCheck(index),
            child: FaIcon(
              checkList[index]
                  ? FontAwesomeIcons.solidSquareCheck
                  : FontAwesomeIcons.squareCheck,
            ),
          ),
        ],
      ),
    );
    return container;
  }
}
