import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quizapp/constants.dart';
import 'package:quizapp/quiz_brain.dart';
import 'package:quizapp/score_screen.dart';
import 'package:flutter/animation.dart';

class QuizScreen extends StatefulWidget {
  QuizScreen({Key? key}) : super(key: key);
  static String id = 'quiz_screen';
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animationController;
  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Duration(seconds: 20), vsync: this);
    animation = Tween<double>(begin: 0, end: 1).animate(animationController)
      ..addListener(() {
        setState(() {});
      });
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  QuizBrain quiz = QuizBrain();
  int count = 0;
  int correct = 0;
  int selected = -1;
  bool isAnswered = false;
  Color colour = kGrayColor;
  @override
  Widget build(BuildContext context) {
    Color getTheRightColor(int index) {
      if (isAnswered) {
        if (index == quiz.questionBank[count].answer) {
          colour = kGreenColor;
          return kGreenColor;
        } else if (index == selected &&
            selected != quiz.questionBank[count].answer) {
          colour = kRedColor;
          return kRedColor;
        }
      }
      return kGrayColor;
    }

    IconData getTheRightIcon() {
      return colour == kRedColor ? Icons.close : Icons.done;
    }

    void nextQuestion() {
      if (selected == quiz.questionBank[count].answer) {
        correct++;
      }
      if (count != quiz.questionBank.length - 1) {
        isAnswered = false;
        animationController.reset();
        animationController.forward();
        count++;
      } else {
        selected = -1;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScoreScreen(
                correctAns: correct, totalQues: quiz.questionBank.length),
          ),
        );
      }
    }

    if (animationController.isCompleted || isAnswered) {
      animationController.stop();
      Future.delayed(Duration(seconds: 1), () {
        nextQuestion();
      });
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          FlatButton(
              onPressed: () {
                setState(() {
                  nextQuestion();
                });
              },
              child: Text("Skip")),
        ],
      ),
      body: Stack(
        children: [
          SvgPicture.asset("icons/bg.svg", fit: BoxFit.fill),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  child: Container(
                    width: double.infinity,
                    height: 35,
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF3F4768), width: 3),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Stack(
                      children: [
                        LayoutBuilder(
                          builder: (context, constraints) => Container(
                            width: constraints.maxWidth * animation.value,
                            decoration: BoxDecoration(
                              gradient: kPrimaryGradient,
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: kDefaultPadding / 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("${(animation.value * 20).round()} sec"),
                                SvgPicture.asset("icons/clock.svg"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: kDefaultPadding * 2),
                Row(
                  children: [
                    Text(
                      'Question ${count + 1}/',
                      style: TextStyle(
                        color: kSecondaryColor,
                        fontSize: 30,
                      ),
                    ),
                    Text(
                      '${quiz.questionBank.length}',
                      style: TextStyle(
                        color: kSecondaryColor,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: kDefaultPadding),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.68,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(30.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            quiz.questionBank[count].question,
                            style: TextStyle(
                              color: kBlackColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: kDefaultPadding / 2),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isAnswered = true;
                                selected = 0;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: kDefaultPadding),
                              padding: EdgeInsets.all(kDefaultPadding),
                              decoration: BoxDecoration(
                                border: Border.all(color: getTheRightColor(0)),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "1. ${quiz.questionBank[count].options[0]}",
                                    style: TextStyle(
                                        color: getTheRightColor(0),
                                        fontSize: 16),
                                  ),
                                  Container(
                                    height: 26,
                                    width: 26,
                                    decoration: BoxDecoration(
                                      color: getTheRightColor(0) == kGrayColor
                                          ? Colors.transparent
                                          : getTheRightColor(0),
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(
                                          color: getTheRightColor(0)),
                                    ),
                                    child: getTheRightColor(0) == kGrayColor
                                        ? null
                                        : Icon(getTheRightIcon(), size: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isAnswered = true;
                                selected = 1;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: kDefaultPadding),
                              padding: EdgeInsets.all(kDefaultPadding),
                              decoration: BoxDecoration(
                                border: Border.all(color: getTheRightColor(1)),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "2. ${quiz.questionBank[count].options[1]}",
                                    style: TextStyle(
                                        color: getTheRightColor(1),
                                        fontSize: 16),
                                  ),
                                  Container(
                                    height: 26,
                                    width: 26,
                                    decoration: BoxDecoration(
                                      color: getTheRightColor(1) == kGrayColor
                                          ? Colors.transparent
                                          : getTheRightColor(1),
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(
                                          color: getTheRightColor(1)),
                                    ),
                                    child: getTheRightColor(1) == kGrayColor
                                        ? null
                                        : Icon(getTheRightIcon(), size: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isAnswered = true;
                                selected = 2;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: kDefaultPadding),
                              padding: EdgeInsets.all(kDefaultPadding),
                              decoration: BoxDecoration(
                                border: Border.all(color: getTheRightColor(2)),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "3. ${quiz.questionBank[count].options[2]}",
                                    style: TextStyle(
                                        color: getTheRightColor(2),
                                        fontSize: 16),
                                  ),
                                  Container(
                                    height: 26,
                                    width: 26,
                                    decoration: BoxDecoration(
                                      color: getTheRightColor(2) == kGrayColor
                                          ? Colors.transparent
                                          : getTheRightColor(2),
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(
                                          color: getTheRightColor(2)),
                                    ),
                                    child: getTheRightColor(2) == kGrayColor
                                        ? null
                                        : Icon(getTheRightIcon(), size: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isAnswered = true;
                                selected = 3;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: kDefaultPadding),
                              padding: EdgeInsets.all(kDefaultPadding),
                              decoration: BoxDecoration(
                                border: Border.all(color: getTheRightColor(3)),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "4. ${quiz.questionBank[count].options[3]}",
                                    style: TextStyle(
                                        color: getTheRightColor(3),
                                        fontSize: 16),
                                  ),
                                  Container(
                                    height: 26,
                                    width: 26,
                                    decoration: BoxDecoration(
                                      color: getTheRightColor(3) == kGrayColor
                                          ? Colors.transparent
                                          : getTheRightColor(3),
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(
                                          color: getTheRightColor(3)),
                                    ),
                                    child: getTheRightColor(3) == kGrayColor
                                        ? null
                                        : Icon(getTheRightIcon(), size: 16),
                                  ),
                                ],
                              ),
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
        ],
      ),
    );
  }
}
