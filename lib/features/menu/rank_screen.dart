import 'package:english_quiz/constants/gaps.dart';
import 'package:english_quiz/constants/sizes.dart';
import 'package:english_quiz/features/menu/widgets/menubar.dart';
import 'package:flutter/material.dart';

class RankScreen extends StatelessWidget {
  const RankScreen({super.key});

  void onMenuTap(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size20,
              vertical: Sizes.size16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gaps.v2,
                Gaps.v16,
                Container(
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
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              "LeaderBoard",
                              style: TextStyle(
                                fontSize: Sizes.size20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  "3000",
                                  style: TextStyle(
                                    fontSize: Sizes.size28,
                                    fontWeight: FontWeight.w500,
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
                          ],
                        ),
                        Gaps.v20,
                        const Text(
                            "See how your Focus Time in the last 24hours compares to other gems in the community"),
                        Gaps.v32,
                        RankContainer(1, "user1", 3000),
                        Gaps.v14,
                        RankContainer(2, "user2", 1500),
                        Gaps.v14,
                        RankContainer(2, "user2", 1500),
                        Gaps.v14,
                        RankContainer(2, "user2", 1500),
                        Gaps.v14,
                        RankContainer(2, "user2", 1500),
                        Gaps.v14,
                        RankContainer(2, "user2", 1500),
                        Gaps.v14,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: MenuBottomBar(
        onMenuBarTap: onMenuTap,
        tapScreen: "menu",
      ),
    );
  }

  Row RankContainer(int rank, String username, int point) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              '$rank',
              style: const TextStyle(
                fontSize: Sizes.size16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Gaps.h10,
            Container(
              width: Sizes.size36,
              height: Sizes.size36,
              decoration: const BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
            Gaps.h14,
            Text(
              username,
              style: const TextStyle(
                fontSize: Sizes.size20,
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              "$point",
              style: const TextStyle(
                fontSize: Sizes.size20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Text(
              "pts",
              style: TextStyle(
                fontSize: Sizes.size16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        )
      ],
    );
  }

  Container DefaultContainer({
    required String enTitle,
    required String koTitle,
  }) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            enTitle,
            style: const TextStyle(
              fontSize: Sizes.size16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(koTitle),
          Gaps.v96,
        ],
      ),
    );
  }
}
