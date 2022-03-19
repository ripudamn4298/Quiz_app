import 'package:flutter/material.dart';
import 'package:quizapp/quiz_screen.dart';
import 'package:quizapp/score_screen.dart';
import 'package:quizapp/welcome_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        QuizScreen.id: (context) => QuizScreen(),
      },
    );
  }
}
