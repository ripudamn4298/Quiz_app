import 'package:flutter/material.dart';
import 'package:quizapp/constants.dart';
import 'package:flutter_svg/svg.dart';

class ScoreScreen extends StatelessWidget {
  ScoreScreen({required this.correctAns, required this.totalQues});
  final correctAns;
  final totalQues;
  static String id = 'score_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset("icons/bg.svg", fit: BoxFit.fill),
          Column(
            children: [
              Spacer(flex: 3),
              Text("Score",
                  style: TextStyle(
                    color: kSecondaryColor,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  )),
              Spacer(),
              Text(
                "${correctAns * 10}/${totalQues * 10}",
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: kSecondaryColor),
              ),
              Spacer(flex: 3),
            ],
          )
        ],
      ),
    );
  }
}
