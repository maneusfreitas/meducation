import 'package:portefolio/src/models/answer.dart';

class Question {
  const Question({
    required this.title,
    required this.answers,
  });

  final String title;
  final List<Answer> answers;
}