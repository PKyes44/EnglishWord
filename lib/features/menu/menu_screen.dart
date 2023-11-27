import 'dart:math';

import 'package:english_quiz/constants/gaps.dart';
import 'package:english_quiz/constants/sizes.dart';
import 'package:english_quiz/features/makeQuestion/make_question_screen.dart';
import 'package:english_quiz/features/menu/rank_screen.dart';
import 'package:english_quiz/features/menu/widgets/menubar.dart';
import 'package:english_quiz/features/questions/question_list_screen.dart';
import 'package:english_quiz/features/study-setting/set_story_screen.dart';
import 'package:english_quiz/features/study-setting/set_word_screen.dart';
import 'package:english_quiz/features/wordQuiz/models/widget_questions_model.dart';
import 'package:english_quiz/features/wordQuiz/views/flashcard_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  String nickname;
  MenuScreen({super.key, required this.nickname});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  var topicsList;

  List<Map<dynamic, dynamic>>? wordData = List.empty(growable: true);

  Future<List<Object?>> readWords() async {
    final reference = FirebaseDatabase.instance.ref();

    DataSnapshot snapshot =
        await reference.child('user/${widget.nickname}/words/').get();
    try {
      final readData = snapshot.value as List<Object?>;
      for (var data in readData) {
        if (data == null) {
          continue;
        }
        Map<String, dynamic> post = Map<String, dynamic>.from(data as Map);

        wordData!.add(post);
      }
      return wordData!;
    } catch (e) {
      return [null];
    }
  }

  List<WiidgetOption> getOptions(int index, String text) {
    List<WiidgetOption> resList = [];
    List<String> qList = [];
    qList.add(text);
    for (int i = 0; i < 4; i++) {
      while (true) {
        var rand = Random().nextInt(wordData!.length);
        if (rand == index || qList.contains(wordData![rand]['mean'])) {
        } else {
          resList.add(
            WiidgetOption(text: wordData![rand]['mean'], isCorrect: false),
          );
          qList.add(wordData![rand]['mean']);
          break;
        }
      }
    }
    resList.add(
      WiidgetOption(text: wordData![index]['mean'], isCorrect: true),
    );
    return resList;
  }

  List<WidgetQuestion> widgetQuestionsList = [];

  List<WidgetQuestion> getWidgetQuistion() {
    Future<List<Object?>> resData = readWords();
    List<WidgetQuestion> res = [];
    resData.then((words) {
      print("words : $words");
      for (int i = 0; i < words.length; i++) {
        if (words[i] == null) {
          continue;
        }
        print("words[i] : ${words[i]}");
        wordData = words as List<Map<dynamic, dynamic>>;
        Map<String, dynamic> word = Map<String, dynamic>.from(words[i]);
        print("word : ${word['word']}");
        res.add(
          WidgetQuestion(
            text: word['word'],
            options: getOptions(i, word['mean']),
            id: i,
            correctAnswer: WiidgetOption(text: word['mean'], isCorrect: true),
          ),
        );
      }
      print("res : ${res[0].text}");
      print("res : ${res[1].text}");
      print("res : ${res[2].text}");
      setState(() {
        widgetQuestionsList = res;
      });
      return res;
    });
    return [];
  }

  @override
  void initState() {
    // getWidgetQuistion();
    super.initState();
  }

  void onRankTap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const RankScreen(),
      ),
    );
  }

  void onSetWordTap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SetWordScreen(nickname: widget.nickname),
      ),
    );
  }

  void onSetStoryTap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SetStoryScreen(
          nickname: widget.nickname,
        ),
      ),
    );
  }

  void onWordGameTap(BuildContext context) {
    getWidgetQuistion();
    print("widgetQuestionsList : $widgetQuestionsList");
    if (widgetQuestionsList.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => NewCard(
            topicName: "Word Game",
            typeOfTopic: widgetQuestionsList,
          ),
        ),
      );
    }
  }

  void onSolveQuestionTap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const QuestionListScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MenuBottomBar(
        onMenuBarTap: onRankTap,
        tapScreen: "rank",
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.size20,
            vertical: Sizes.size16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: Sizes.size16,
                    horizontal: Sizes.size24,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      Sizes.size20,
                    ),
                    border: Border.all(color: Colors.black.withOpacity(0.1)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Gaps.v4,
                      const Row(
                        children: [
                          Text(
                            "Point",
                            style: TextStyle(
                              fontSize: Sizes.size24,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Gaps.h32,
                        ],
                      ),
                      Gaps.v8,
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            "3000",
                            style: TextStyle(
                              fontSize: Sizes.size44,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            "pts",
                            style: TextStyle(
                              fontSize: Sizes.size20,
                            ),
                          ),
                        ],
                      ),
                      Gaps.v24,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () => onSetWordTap(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Sizes.size32,
                                vertical: Sizes.size14,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(
                                  Sizes.size20,
                                ),
                                border: Border.all(
                                    color: Colors.black.withOpacity(0.1)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 5,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: const Text("Set Words"),
                            ),
                          ),
                          Gaps.h32,
                          Flexible(
                            child: GestureDetector(
                              onTap: () => onSetStoryTap(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Sizes.size32,
                                  vertical: Sizes.size14,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(
                                    Sizes.size20,
                                  ),
                                  border: Border.all(
                                      color: Colors.black.withOpacity(0.1)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 5,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: const Text("Set Storys"),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Gaps.v16,
              Flexible(
                flex: 2,
                child: Column(
                  children: [
                    Flexible(
                      flex: 3,
                      child: GestureDetector(
                        onTap: () => onWordGameTap(context),
                        child: Card(
                          color: Theme.of(context).primaryColor,
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Word Game",
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                        ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const MakeQuestionScreen(),
                            ),
                          );
                        },
                        child: Card(
                          color: Theme.of(context).primaryColor,
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Icon(
                                  //   topicsList.topicIcon,
                                  //   color: Colors.white,
                                  //   size: 55,
                                  // ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Make Question",
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                        ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: GestureDetector(
                        onTap: () => onSolveQuestionTap(context),
                        child: Card(
                          color: Theme.of(context).primaryColor,
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Icon(
                                  //   topicsList[0].topicIcon,
                                  //   color: Colors.white,
                                  //   size: 55,
                                  // ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Solve Questions",
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                        ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
