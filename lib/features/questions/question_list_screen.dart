import 'package:english_quiz/constants/gaps.dart';
import 'package:english_quiz/features/makeQuestion/make_question_screen.dart';
import 'package:english_quiz/features/questions/solve_questions_screen.dart';
import 'package:english_quiz/features/widgets/form_button.dart';
import 'package:english_quiz/features/wordQuiz/models/widget_questions_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuestionListScreen extends StatefulWidget {
  const QuestionListScreen({super.key});

  @override
  State<QuestionListScreen> createState() => _QuestionListScreenState();
}

class _QuestionListScreenState extends State<QuestionListScreen> {
  List<dynamic> questions = List.empty(growable: true);
  List<WiidgetOption> optionsList = List.empty(growable: true);
  List<dynamic> questionlength = List.empty(growable: true);
  String userId = "user1";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getQuestions();
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

  void getQuestions() async {
    Future<String> grade = getGrade();
    grade.then((grade) async {
      final reference = FirebaseDatabase.instance.ref();
      DataSnapshot snapshot = await reference.child('questions/$grade').get();
      Map<dynamic, dynamic> tempList = snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        for (var tempkey in tempList.keys) {
          var tempQuestion = tempList[tempkey];
          questions.add(tempQuestion);
        }
      });
      print("questions : $questions");
    });
  }

  List<dynamic> getWidgetQuestion(int questionIndex) {
    return questionlength = [
      WidgetQuestion(
        id: 1,
        correctAnswer: WiidgetOption(
            text: questions[questionIndex]['answer'], isCorrect: true),
        text: questions[questionIndex]['questionText'],
        options: [
          WiidgetOption(
            text: questions[questionIndex]['q1'],
            isCorrect: questions[questionIndex]['q1'] ==
                    questions[questionIndex]['answer']
                ? true
                : false,
          ),
          WiidgetOption(
            text: questions[questionIndex]['q2'],
            isCorrect: questions[questionIndex]['q2'] ==
                    questions[questionIndex]['answer']
                ? true
                : false,
          ),
          WiidgetOption(
            text: questions[questionIndex]['q3'],
            isCorrect: questions[questionIndex]['q3'] ==
                    questions[questionIndex]['answer']
                ? true
                : false,
          ),
          WiidgetOption(
            text: questions[questionIndex]['q4'],
            isCorrect: questions[questionIndex]['q4'] ==
                    questions[questionIndex]['answer']
                ? true
                : false,
          ),
          WiidgetOption(
            text: questions[questionIndex]['q5'],
            isCorrect: questions[questionIndex]['q5'] ==
                    questions[questionIndex]['answer']
                ? true
                : false,
          ),
        ],
      )
    ];
  }

  List<WiidgetOption> getWidgetOptions(int questionIndex) {
    return optionsList = [
      WiidgetOption(
        text: questions[questionIndex]['q1'],
        isCorrect:
            questions[questionIndex]['q1'] == questions[questionIndex]['answer']
                ? true
                : false,
      ),
      WiidgetOption(
        text: questions[questionIndex]['q2'],
        isCorrect:
            questions[questionIndex]['q2'] == questions[questionIndex]['answer']
                ? true
                : false,
      ),
      WiidgetOption(
        text: questions[questionIndex]['q3'],
        isCorrect:
            questions[questionIndex]['q3'] == questions[questionIndex]['answer']
                ? true
                : false,
      ),
      WiidgetOption(
        text: questions[questionIndex]['q4'],
        isCorrect:
            questions[questionIndex]['q4'] == questions[questionIndex]['answer']
                ? true
                : false,
      ),
      WiidgetOption(
        text: questions[questionIndex]['q5'],
        isCorrect:
            questions[questionIndex]['q5'] == questions[questionIndex]['answer']
                ? true
                : false,
      ),
    ];
  }

  Map<String, String> getViewABC(int questionIndex) {
    if (questions[questionIndex]['questionType'] == "ABC") {
      return {
        'A': questions[questionIndex]['A'],
        'B': questions[questionIndex]['B'],
        'C': questions[questionIndex]['C'],
      };
    } else {
      return {};
    }
  }

  void onMakeQuestionTap() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const MakeQuestionScreen(),
    ));
  }

  void onMenuTap() {
    Navigator.of(context).pop();
  }

  void onQuestionTap(int questionIndex) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SolveQuestionScreen(
          optionsList: getWidgetOptions(questionIndex),
          questionlength: getWidgetQuestion(questionIndex),
          questionType: questions[questionIndex]['questionType'],
          viewABC: getViewABC(questionIndex)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Center(
              child: Text(
                'Questions',
              ),
            ),
            GestureDetector(
              child: IconButton(
                onPressed: onMakeQuestionTap,
                icon: const Icon(
                  Icons.add,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          listview_separated(),
        ],
      ),
    );
  }

  Widget listview_separated() {
    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: questions.length,
        itemBuilder: ((context, index) {
          return GestureDetector(
            onTap: () => onQuestionTap(index),
            child: SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          questions[index]['title'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Gaps.v8,
                        Text(
                          "Written by ${questions[index]['userId']}",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 10,
                        ),
                        child: Text(
                          "Solve",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        separatorBuilder: (context, index) => const Divider(
          height: 10.0,
          color: Colors.grey,
        ),
      ),
    );
  }
}
