import 'dart:convert';
import 'dart:io';

import 'package:english_quiz/constants/gaps.dart';
import 'package:english_quiz/constants/sizes.dart';
import 'package:english_quiz/features/study-setting/set_story_detail_screen.dart';
import 'package:english_quiz/features/widgets/form_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class SetStoryScreen extends StatefulWidget {
  final String nickname;
  const SetStoryScreen({super.key, required this.nickname});

  @override
  State<SetStoryScreen> createState() => _SetStoryScreenState();
}

class _SetStoryScreenState extends State<SetStoryScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _storyController = TextEditingController();

  bool isCheckGrade1 = false;
  bool isCheckGrade2 = false;
  String parsedtext = '';
  String targetGradeErrorText = '';
  String title = '';
  String body = '';
  bool isShow = false;
  String userId = 'user1';
  List<Map<dynamic, dynamic>> storyData = List.empty(growable: true);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (getStoryList() != null) {
      storyData = getStoryList()!;
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

  void onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  void onMenuTap() {
    Navigator.of(context).pop();
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

  Future _getFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    var bytes = File(pickedFile.path.toString()).readAsBytesSync();
    String img64 = base64Encode(bytes);

    var url = 'https://api.ocr.space/parse/image';
    var payload = {
      "base64Image": "data:image/jpg;base64,${img64.toString()}",
      "language": "kor"
    };
    var header = {"apikey": "K85277938588957"};

    var post = await http.post(Uri.parse(url), body: payload, headers: header);
    var result = jsonDecode(post.body);

    setState(() {
      parsedtext = result['ParsedResults'][0]['ParsedText'];
    });
    _storyController.value = TextEditingValue(text: parsedtext);
  }

  void onSubmit() {
    if (formKey.currentState != null) {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        writeStory();
      }
    }
  }

  void onDetailTap(String storyId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StoryDetailScreen(
          nickname: widget.nickname,
          storyId: storyId,
        ),
      ),
    );
  }

  void switchShow() {
    setState(() {
      isShow = !isShow;
    });
  }

  void writeStory() {
    var uuid = const Uuid();
    var storyId = uuid.v4();

    var data = {
      "storyId": storyId,
      "title": title,
      "body": body,
    };
    if (isCheckGrade1) {
      DatabaseReference ref =
          FirebaseDatabase.instance.ref('storys/1/$storyId');
      ref.set(data);
    }
    if (isCheckGrade2) {
      DatabaseReference ref =
          FirebaseDatabase.instance.ref('storys/2/$storyId');
      ref.set(data);
    }
    setState(() {
      storyData.add(data);
    });
    print("StoryData updated : $storyData");
  }

  Future<List<Object?>> readStory() async {
    Future<String> grade = getGrade();
    grade.then((grade) async {
      final reference = FirebaseDatabase.instance.ref();
      DataSnapshot snapshot = await reference.child('story/$grade').get();
      var returnData = [];
      try {
        final readData2 = snapshot.value as Map<dynamic, dynamic>;
        print("readData2 : ${readData2.keys}");
        for (var readDataKey in readData2.keys) {
          returnData.add(readData2[readDataKey]);
        }
        // return returnData;
      } catch (e) {
        print("final ReadData");
        // return [null];
      }
      storyData.clear();
      print("ReadStory : $returnData");
      for (var story in returnData) {
        if (story == null) {
          continue;
        }
        Map<String, dynamic> post = Map<String, dynamic>.from(story as Map);
        setState(() {
          storyData.add(post);
        });
      }
      print("StoryData : $storyData");
      return storyData;
    });
    return [null];
  }

  List<Map<String, String>>? getStoryList() {
    Future<List<Object?>> storyList = readStory();
    storyList.then((storys) async {
      storyData.clear();
      final reference = FirebaseDatabase.instance.ref();
      DataSnapshot snapshot =
          await reference.child('user/$userId/grade/').get();
      int grade = snapshot.value as int;
      print("grade : $grade");
      print("ReadStory : $storys");
      for (var story in storys) {
        if (story == null) {
          continue;
        }
        Map<String, dynamic> post = Map<String, dynamic>.from(story as Map);
        if (post['grade$grade']) {
          setState(() {
            storyData.add(post);
          });
        }
      }
      print("StoryData : $storyData");
      return storyData;
    });
    return null;
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
                        "Story Settings",
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
                      Text(
                        "주의 : 생성된 이야기는 선택된 학년에게만 추가됩니다",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: Sizes.size12,
                        ),
                      ),
                      Gaps.v20,
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              onSaved: (value) {
                                title = value.toString();
                              },
                              validator: (value) {
                                if (value.toString().isEmpty) {
                                  return "need to title";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                hintText: "Title",
                              ),
                            ),
                            Gaps.v10,
                            TextFormField(
                              onSaved: (value) {
                                body = value.toString();
                              },
                              validator: (value) {
                                if (value.toString().isEmpty) {
                                  return "need to story";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              autocorrect: false,
                              controller: _storyController,
                              cursorColor: Theme.of(context).primaryColor,
                              decoration: InputDecoration(
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 10,
                                  ),
                                  child: GestureDetector(
                                    onTap: _getFromGallery,
                                    child:
                                        const FaIcon(FontAwesomeIcons.camera),
                                  ),
                                ),
                                hintText: "Body",
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ),
                            ),
                            Gaps.v20,
                            GestureDetector(
                              onTap: onSubmit,
                              child: FormButton(
                                disabled: isCheckGrade1 || isCheckGrade2
                                    ? false
                                    : true,
                                text: "Add",
                              ),
                            ),
                            Gaps.v24,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "My Story List",
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
                                        (isShow || storyData.length < 5
                                            ? storyData.length
                                            : 5);
                                    i++)
                                  createStoryList(i),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container createStoryList(int i) {
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
        border: Border.all(
          color: Colors.black.withOpacity(0.4),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            storyData[i]['title'],
            style: const TextStyle(
              fontSize: Sizes.size16,
            ),
          ),
          GestureDetector(
            onTap: () => onDetailTap(storyData[i]['storyId']),
            child: const FaIcon(FontAwesomeIcons.magnifyingGlass),
          )
        ],
      ),
    );
  }
}
