import 'package:english_quiz/constants/gaps.dart';
import 'package:english_quiz/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MenuBottomBar extends StatelessWidget {
  final void Function(BuildContext) onMenuBarTap;
  final String tapScreen;

  const MenuBottomBar({
    super.key,
    required this.onMenuBarTap,
    required this.tapScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 10),
        ],
      ),
      child: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: Sizes.size16,
            top: Sizes.size16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (tapScreen == "menu") {
                        onMenuBarTap(context);
                      }
                    },
                    child: const Icon(
                      Icons.home_filled,
                      size: Sizes.size40,
                      color: Color(0xffFF9F40),
                    ),
                  ),
                  const Text("Menu"),
                ],
              ),
              Gaps.h96,
              Gaps.h16,
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (tapScreen == "rank") {
                        onMenuBarTap(context);
                      }
                    },
                    child: const FaIcon(
                      FontAwesomeIcons.rankingStar,
                      size: Sizes.size32,
                      color: Color(0xffFF9F40),
                    ),
                  ),
                  Gaps.v5,
                  const Text("Rank"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
