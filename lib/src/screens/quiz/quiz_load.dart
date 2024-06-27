import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portefolio/src/dataset/dataset.dart';
import 'package:portefolio/src/models/answer_model.dart';
import 'package:portefolio/src/models/question_model.dart';
import 'package:portefolio/src/models/quiz_model.dart';
import 'package:portefolio/src/screens/quiz/quiz_main.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestState();
}

class _TestState extends State<TestScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToQuiz();
  }

  void _navigateToQuiz() async {
    await Future.delayed(const Duration(milliseconds: 2000), () {});
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const QuizScreen()));
  }

  Future<List<DocumentSnapshot<Map<String, dynamic>>>> getQuiz() async {
    quizDataset = [];
    quizDatasetCopy = [];
    final quizReference = FirebaseFirestore.instance.collection('quiz');
    final wait = await quizReference.get();

    await quizReference.get().then((QuerySnapshot quizSnapshot) async {
      final quizDocs = quizSnapshot.docs;

      for (var quizDoc in quizDocs) {
        List<Question> questionDataset = [];
        List<Question> questionDatasetCopy = [];

        final questionReference = FirebaseFirestore.instance
            .collection('quiz')
            .doc(quizDoc.id)
            .collection('question');

        await questionReference
            .get()
            .then((QuerySnapshot questionSnapshot) async {
          final questionDocs = questionSnapshot.docs;

          for (var questionDoc in questionDocs) {
            List<Answer> answerDataset = [];
            List<Answer> answerDatasetCopy = [];

            final answerRef = FirebaseFirestore.instance
                .collection('quiz')
                .doc(quizDoc.id)
                .collection('question')
                .doc(questionDoc.id)
                .collection('answer');

            await answerRef.get().then((QuerySnapshot answerSnapshot) {
              final answerDocs = answerSnapshot.docs;

              for (var answerDoc in answerDocs) {
                answerDataset.add(Answer(
                    title: answerDoc.get('title'),
                    result: answerDoc.get('result')));

                answerDatasetCopy
                    .add(Answer(title: answerDoc.get('title'), result: false));
              }
            });

            questionDataset.add(Question(
                title: questionDoc.get('title'), answers: answerDataset));

            questionDatasetCopy.add(Question(
                title: questionDoc.get('title'), answers: answerDatasetCopy));
          }
        });

        quizDataset
            .add(Case(title: quizDoc.get('title'), questions: questionDataset));

        quizDatasetCopy.add(
            Case(title: quizDoc.get('title'), questions: questionDatasetCopy));
      }
    });

    return wait.docs;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DocumentSnapshot<Map<String, dynamic>>>>(
        future: getQuiz(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
                backgroundColor: Colors.white,
                body: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro tentar recolher os dados'));
          } else {
            return const Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
