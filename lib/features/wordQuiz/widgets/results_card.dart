import 'package:english_quiz/constants/sizes.dart';
import 'package:english_quiz/features/wordQuiz/widgets/dotted_lines.dart';
import 'package:flutter/material.dart';

class ResultsCard extends StatelessWidget {
  const ResultsCard({
    super.key,
    required this.roundedPercentageScore,
    required this.bgColor3,
  });

  final int roundedPercentageScore;
  final Color bgColor3;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.888,
      height: MediaQuery.of(context).size.height * 0.568,
      child: Stack(
        children: [
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: "Congratulations!",
                              style: TextStyle(
                                fontSize: Sizes.size24,
                                color: Colors.black,
                              ),
                            ),
                            //m'adamfo(Twi) - my friend
                            const TextSpan(
                              text: "\n\nYou Scored  \n",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: Sizes.size16,
                              ),
                            ),
                            TextSpan(
                              text: "$roundedPercentageScore Point",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontSize: 30,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  CustomPaint(
                    painter: DrawDottedhorizontalline(),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: roundedPercentageScore >= 75
                            ? Column(
                                children: [
                                  Text(
                                    "You have Earned this Trophy",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                  Image.asset("assets/bouncy-cup.gif",
                                      fit: BoxFit.fill,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.25),
                                ],
                              )
                            : Column(
                                children: [
                                  Text(
                                    "I know You can do better!!",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  Image.asset("assets/sad.png",
                                      fit: BoxFit.fill,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.25),
                                ],
                              ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            left: -10,
            top: MediaQuery.of(context).size.height * 0.178,
            child: Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle),
            ),
          ),
          Positioned(
            right: -10,
            top: MediaQuery.of(context).size.height * 0.178,
            child: Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle),
            ),
          ),
        ],
      ),
    );
  }
}
