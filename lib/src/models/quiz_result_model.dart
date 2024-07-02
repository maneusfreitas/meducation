import 'package:portefolio/src/imports/imports.dart';

class QuizResult {
  const QuizResult({
    required this.userId,
    required this.quizId,
    required this.userScore,
    required this.quizScore,
    required this.timestamp,
  });

  final String? userId;
  final String quizId;
  final int userScore;
  final int quizScore;
  final Timestamp timestamp;

  toJson()
  {
    return {
      "user_id": userId,
      "quiz_id": quizId,
      "user_score": userScore,
      "quiz_score": quizScore,
      "timestamp": timestamp,
    };
  }
}