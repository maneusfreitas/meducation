import 'package:portefolio/src/models/answer_model.dart';

class Question {
  const Question({
    required this.title,
    required this.answers,
  });

  final String title;
  final List<Answer> answers;
}