import 'package:portefolio/src/models/question.dart';

class Quiz {
  const Quiz({
    required this.title,
    required this.questions,
  });

  final String title;
  final List<Question> questions;
}