import 'package:portefolio/src/models/question_model.dart';

class Case {
  const Case({
    required this.id,
    required this.title,
    required this.questions,
  });

  final String id;
  final String title;
  final List<Question> questions;
}