import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:english_quiz/features/menu/menu_screen.dart';
import 'package:english_quiz/features/wordQuiz/models/widget_questions_model.dart';
import 'package:english_quiz/features/wordQuiz/views/quiz_screen.dart';
import 'package:english_quiz/features/wordQuiz/widgets/flash_card_widget.dart';
import 'package:english_quiz/features/wordQuiz/widgets/linear_progress_indicator_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:get/get.dart';

class NewCard extends StatefulWidget {
  final String topicName;
  final List<WidgetQuestion> typeOfTopic;
  const NewCard(
      {super.key, required this.topicName, required this.typeOfTopic});

  @override
  State<NewCard> createState() => _NewCardState();
}

class _NewCardState extends State<NewCard> {
  final AppinioSwiperController controller = AppinioSwiperController();

  @override
  Widget build(BuildContext context) {
    //const Color bgColor = Color(0xFF4993FA);
    Color cardColor = Theme.of(context).primaryColor;

    // Get a list of 4 randomly selected Questions objects

    print("widget.typeOfTopic : ${widget.typeOfTopic}");

    Map<dynamic, dynamic> randomQuestionsMap =
        getRandomQuestionsAndOptions(widget.typeOfTopic, 5);
    List<dynamic> randomQuestions = randomQuestionsMap.keys.toList();
    dynamic randomOptions = randomQuestionsMap.values.toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.only(right: 18.0),
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        CupertinoIcons.clear,
                        color: Colors.black,
                        weight: 10,
                      ),
                    ),
                    MyProgressIndicator(
                      questionlenght: randomQuestions,
                      optionsList: randomOptions,
                      topicType: widget.topicName,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.92,
                height: MediaQuery.of(context).size.height * 0.60,
                child: AppinioSwiper(
                  padding: const EdgeInsets.all(10),
                  loop: true,
                  backgroundCardsCount: 2,
                  swipeOptions: const AppinioSwipeOptions.all(),
                  unlimitedUnswipe: true,
                  controller: controller,
                  unswipe: _unswipe,
                  onSwipe: _swipe,
                  onEnd: _onEnd,
                  cardsCount: randomQuestions.length,
                  cardsBuilder: (BuildContext context, int index) {
                    var cardIndex = randomQuestions[index];
                    return FlipCardsWidget(
                      bgColor: Theme.of(context).primaryColor,
                      cardsLenght: randomQuestions.length,
                      currentIndex: index + 1,
                      answer: cardIndex.correctAnswer.text,
                      question: cardIndex.text,
                      currentTopic: widget.topicName,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(cardColor),
                fixedSize: MaterialStateProperty.all(
                  Size(MediaQuery.sizeOf(context).width * 0.85, 30),
                ),
                // elevation: MaterialStateProperty.all(4),
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => QuizScreen(
                      questionlength: randomQuestions,
                      optionsList: randomOptions,
                      topicType: widget.topicName,
                    ),
                  ),
                );
              },
              child: const Text(
                "Start Quiz",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )),
    );
  }
}

Map<dynamic, dynamic> getRandomQuestionsAndOptions(
  List<WidgetQuestion> allQuestions,
  int count,
) {
  final randomQuestions = <dynamic>[];
  final randomOptions = <dynamic>[];
  final random = Random();
  if (allQuestions.length < count) {
    count = allQuestions.length;
  }
  
  print("Count : $count");

  if (count >= allQuestions.length) {
    count = allQuestions.length;
  }

  while (randomQuestions.length < count) {
    final randomIndex = random.nextInt(allQuestions.length);
    WidgetQuestion selectedQuestion = allQuestions[randomIndex];

    if (!randomQuestions.contains(selectedQuestion)) {
      allQuestions.remove(selectedQuestion);
      randomQuestions.add(selectedQuestion);
      randomOptions.add(selectedQuestion.options);
    }
  }

  // print("randomQuestions : ${randomQuestions.}");

  return Map.fromIterables(randomQuestions, randomOptions);
}

// List<dynamic> getRandomQuestions(List<dynamic> allQuestions, int count) {
//   if (count >= allQuestions.length) {
//     return List.from(allQuestions);
//   }
//   List<dynamic> randomQuestions = [];

//   List<int> indexes = List.generate(allQuestions.length, (index) => index);
//   final random = Random();

//   while (randomQuestions.length < count) {
//     final randomIndex = random.nextInt(indexes.length);
//     final selectedQuestionIndex = indexes[randomIndex];
//     final selectedQuestion = allQuestions[selectedQuestionIndex];
//     randomQuestions.add(selectedQuestion);

//     indexes.removeAt(randomIndex);
//   }
//   return randomQuestions;
// }

void _swipe(int index, AppinioSwiperDirection direction) {
  print("the card was swiped to the: ${direction.name}");
  print(index);
}

void _unswipe(bool unswiped) {
  if (unswiped) {
    print("SUCCESS: card was unswiped");
  } else {
    print("FAIL: no card left to unswipe");
  }
}

void _onEnd() {
  print("end reached!");
}