import 'package:english_quiz/constants/gaps.dart';
import 'package:english_quiz/constants/sizes.dart';
import 'package:english_quiz/features/menu/menu_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class StoryDetailScreen extends StatefulWidget {
  const StoryDetailScreen({
    super.key,
    required this.storyId,
    required this.nickname,
  });
  final String nickname;
  final String storyId;

  @override
  State<StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  Map<String, dynamic> storyData = {};

  void onPreviousTap() {
    Navigator.of(context).pop();
  }

  void onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.storyId);
    if (getStory() != null) {
      storyData = getStory()!;
    }
  }

  Map<String, dynamic>? getStory() {
    final tempData = readStory();
    tempData.then((value) async {
      print(value);
      if (value != null) {
        setState(() {
          storyData = value;
        });
        return storyData;
      }
    });
    return null;
  }

  Future<Map<String, dynamic>?> readStory() async {
    final reference = FirebaseDatabase.instance.ref();
    DataSnapshot snapshot =
        await reference.child('storys/${widget.storyId}').get();
    print(snapshot.value);
    // try {
    if (snapshot.value == null) {
      return null;
    }
    Map<String, dynamic> post =
        Map<String, dynamic>.from(snapshot.value as Map);
    print("readData : $post");
    return post;
  }

  void removeStory() async {
    final reference = FirebaseDatabase.instance.ref();
    await reference.child('storys/${widget.storyId}').remove();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MenuScreen(
          nickname: widget.nickname,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: onScaffoldTap,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: onPreviousTap,
                            child: const Icon(Icons.arrow_back_ios),
                          ),
                          Gaps.h10,
                          const Image(
                            image: AssetImage('assets/number_one.png'),
                          ),
                          Gaps.h16,
                          const Text(
                            "Story Detail",
                            style: TextStyle(
                              fontSize: Sizes.size20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: removeStory,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: Sizes.size12,
                            horizontal: Sizes.size10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              Sizes.size5,
                            ),
                            color: Theme.of(context).primaryColor,
                          ),
                          child: const Text(
                            "Remove",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
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
                    children: [
                      Text(
                        storyData['title'] ?? "Null",
                        style: const TextStyle(
                          fontSize: Sizes.size20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Gaps.v10,
                      Text(
                        storyData['body'] ?? "Null",
                        style: const TextStyle(
                          fontSize: Sizes.size16,
                          fontWeight: FontWeight.w400,
                        ),
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
}
