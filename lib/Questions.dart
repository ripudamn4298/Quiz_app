class Question {
  int id = 0, answer = 0;
  String question = '';
  List<String> options = ['', ''];

  Question(
      {String ques = '',
      int ans = 0,
      int index = 0,
      required List<String> option}) {
    id = index;
    answer = ans;
    question = ques;
    options = option;
  }
}
