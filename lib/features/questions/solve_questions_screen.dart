import 'dart:async';
import 'package:english_quiz/constants/gaps.dart';
import 'package:english_quiz/features/wordQuiz/models/widget_questions_model.dart';
import 'package:english_quiz/features/wordQuiz/views/results_screen.dart';
import 'package:flutter/material.dart';

class SolveQuestionScreen extends StatefulWidget {
  final List<WiidgetOption> optionsList;
  final List<dynamic> questionlength;
  final String questionType;
  final Map<String, String> viewABC;
  const SolveQuestionScreen({
    super.key,
    required this.optionsList,
    required this.questionlength,
    required this.questionType,
    required this.viewABC,
  });

  @override
  State<SolveQuestionScreen> createState() => _SolveQuestionScreenState();
}

class _SolveQuestionScreenState extends State<SolveQuestionScreen> {
  int questionTimerSeconds = 20;
  Timer? _timer;
  int _questionNumber = 1;
  PageController _controller = PageController();
  int score = 0;
  bool isLocked = false;
  List optionsLetters = ["A.", "B.", "C.", "D."];

  final String topicType = "Solve Question";
  // final List<WiidgetOption> widget.optionsList = [
  //   const WiidgetOption(
  //     text: "q1",
  //     isCorrect: false,
  //   ),
  //   const WiidgetOption(
  //     text: "q2",
  //     isCorrect: false,
  //   ),
  //   const WiidgetOption(
  //     text: "q3",
  //     isCorrect: false,
  //   ),
  //   const WiidgetOption(
  //     text: "q4",
  //     isCorrect: true,
  //   ),
  //   const WiidgetOption(
  //     text: "q5",
  //     isCorrect: false,
  //   ),
  // ];
  // final List<dynamic> widget.questionlength = [
  //   WidgetQuestion(
  //     text: "Question",
  //     options: [
  //       const WiidgetOption(
  //         text: "q1",
  //         isCorrect: false,
  //       ),
  //       const WiidgetOption(
  //         text: "q2",
  //         isCorrect: false,
  //       ),
  //       const WiidgetOption(
  //         text: "q3",
  //         isCorrect: false,
  //       ),
  //       const WiidgetOption(
  //         text: "q4",
  //         isCorrect: true,
  //       ),
  //       const WiidgetOption(
  //         text: "q5",
  //         isCorrect: false,
  //       ),
  //     ],
  //     id: 1,
  //     correctAnswer: const WiidgetOption(text: "q4", isCorrect: true),
  //   ),
  // ];

  void startTimerOnQuestions() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (questionTimerSeconds > 0) {
            questionTimerSeconds--;
          } else {
            _timer?.cancel();
            navigateToNewScreen();
          }
        });
      }
    });
  }

  void stopTime() {
    _timer?.cancel();
  }

  void navigateToNewScreen() {
    if (_questionNumber < widget.questionlength.length) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
      setState(() {
        _questionNumber++;
        isLocked = false;
      });
      _resetQuestionLocks();
      startTimerOnQuestions();
    } else {
      _timer?.cancel();
      // Navigator.pushReplacement(
      //   context,
      // MaterialPageRoute(
      //   builder: (context) => ResultsScreen(
      //     score: score,
      //     totalQuestions: widget.questionlength.length,
      //     whichTopic: topicType,
      //   ),
      // ),
      // )
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
    _resetQuestionLocks();
    startTimerOnQuestions();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                width: MediaQuery.of(context).size.width * 0.90,
                height: MediaQuery.of(context).size.height * 0.90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.24),
                      blurRadius: 20.0,
                      offset: const Offset(0.0, 10.0),
                      spreadRadius: 10,
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: PageView.builder(
                            controller: _controller,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: widget.questionlength.length,
                            onPageChanged: (value) {
                              setState(() {
                                _questionNumber = value + 1;
                                isLocked = false;
                                _resetQuestionLocks();
                              });
                            },
                            itemBuilder: (context, index) {
                              final myquestions = widget.questionlength[index];
                              var optionsIndex = widget.optionsList[index];

                              return Column(
                                children: [
                                  Text(
                                    // myquestions.text,
                                    "QUESTION",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontSize: 18,
                                        ),
                                  ),
                                  Gaps.v16,
                                  OutlinedButton(
                                    onPressed: () {},
                                    style: ButtonStyle(
                                      overlayColor:
                                          MaterialStateProperty.all<Color>(
                                        const Color.fromRGBO(255, 159, 64, 0.5),
                                      ),
                                    ),
                                    child: Text(
                                      "Watch Story",
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Gaps.v16,
                                  if (widget.questionType == "ABC")
                                    buildABCView(),
                                  Gaps.v24,
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: myquestions.options.length,
                                      itemBuilder: (context, index) {
                                        var color = Colors.grey.shade200;

                                        var questionOption =
                                            myquestions.options[index];
                                        // final letters = optionsLetters[index];

                                        if (myquestions.isLocked) {
                                          if (questionOption ==
                                              myquestions
                                                  .selectedWiidgetOption) {
                                            color = questionOption.isCorrect
                                                ? Colors.green
                                                : Colors.red;
                                          } else if (questionOption.isCorrect) {
                                            color = Colors.green;
                                          }
                                        }
                                        return InkWell(
                                          onTap: () {
                                            print(optionsIndex);
                                            stopTime();
                                            if (!myquestions.isLocked) {
                                              setState(() {
                                                myquestions.isLocked = true;
                                                myquestions
                                                        .selectedWiidgetOption =
                                                    questionOption;
                                              });

                                              isLocked = myquestions.isLocked;
                                              if (myquestions
                                                  .selectedWiidgetOption
                                                  .isCorrect) {
                                                score++;
                                              }
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                              horizontal: 10,
                                            ),
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 8),
                                            decoration: BoxDecoration(
                                              border: Border.all(color: color),
                                              color: Colors.grey.shade100,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    "${questionOption.text}",
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                  ),
                                                ),
                                                isLocked == true
                                                    ? questionOption.isCorrect
                                                        ? const Icon(
                                                            Icons.check_circle,
                                                            color: Colors.green,
                                                          )
                                                        : const Icon(
                                                            Icons.cancel,
                                                            color: Colors.red,
                                                          )
                                                    : const SizedBox.shrink()
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  isLocked
                                      ? buildElevatedButton()
                                      : const SizedBox.shrink(),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildABCView() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 10,
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        color: Colors.grey.shade100,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: [
          Flexible(
            child: Text(
              '''ㄱ. ${widget.viewABC["A"]}\n
ㄴ. ${widget.viewABC["B"]}\n
ㄷ. ${widget.viewABC["C"]}''',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  void _resetQuestionLocks() {
    for (var question in widget.questionlength) {
      question.isLocked = false;
    }
    questionTimerSeconds = 20;
  }

  ElevatedButton buildElevatedButton() {
    //  const Color bgColor3 = Color(0xFF5170FD);
    Color cardColor = Theme.of(context).primaryColor;

    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(cardColor),
        fixedSize: MaterialStateProperty.all(
          Size(MediaQuery.sizeOf(context).width * 0.80, 40),
        ),
        elevation: MaterialStateProperty.all(4),
      ),
      onPressed: () {
        if (_questionNumber < widget.questionlength.length) {
          _controller.nextPage(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
          );
          setState(() {
            _questionNumber++;
            isLocked = false;
          });
          _resetQuestionLocks();
          startTimerOnQuestions();
        } else {
          _timer?.cancel();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ResultsScreen(
                score: score,
                totalQuestions: widget.questionlength.length,
                whichTopic: topicType,
              ),
            ),
          );
        }
      },
      child: Text(
        'Result',
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
