import 'package:portefolio/src/models/question_model.dart';

class Case {
  const Case({
    required this.title,
    required this.questions,
  });

  final String title;
  final List<Question> questions;
}