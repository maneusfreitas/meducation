import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portefolio/src/dataset/dataset.dart';
import 'package:portefolio/src/models/answer_model.dart';
import 'package:portefolio/src/models/question_model.dart';
import 'package:portefolio/src/models/quiz_model.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizState();
}

class _QuizState extends State<QuizScreen> {
  Future<List<DocumentSnapshot<Map<String, dynamic>>>> getQuiz() async {
    final quizReference = FirebaseFirestore.instance.collection('quiz');
    final wait = await quizReference.get();

    await quizReference.get().then((QuerySnapshot quizSnapshot) async {
      final quizDocs = quizSnapshot.docs;

      for (var quizDoc in quizDocs) {
        List<Question> questionDataset = [];

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
              }
            });

            questionDataset.add(Question(
                title: questionDoc.get('title'), answers: answerDataset));
          }
        });

        quizDataset
            .add(Case(title: quizDoc.get('title'), questions: questionDataset));
      }
    });

    return wait.docs;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DocumentSnapshot<Map<String, dynamic>>>>(
        future: getQuiz(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasError) {
            print(snapshot.error.toString());
            return const Center(child: Text('Erro tentar recolher os dados'));
          } else {
            List<Widget> listW = [];

            for (var quiz in quizDataset) {
              listW.add(Text(quiz.title, style: const TextStyle(fontSize: 10)));

              listW.add(const SizedBox(height: 15));

              for (var question in quiz.questions) {
                listW.add(
                    Text(question.title, style: const TextStyle(fontSize: 10)));

                listW.add(const SizedBox(height: 10));

                for (var answer in question.answers) {
                  listW.add(CheckboxListTile(
                      title: Text(
                        answer.title,
                        style: const TextStyle(fontSize: 10),
                      ),
                      value: answer.result,
                      onChanged: (value) {
                        setState(() {
                          value = !value!;
                        });
                      }));

                  listW.add(const SizedBox(height: 5));
                }
              }
            }

            listW.add(ElevatedButton(
              onPressed: () {
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ));

            return Scaffold(
                appBar: AppBar(
                  title: const Text('Questões',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.black,
                          fontWeight: FontWeight.w700)),
                  backgroundColor: Colors.white,
                  bottomOpacity: 0.5,
                  elevation: 0.5,
                  centerTitle: true,
                  leading: Container(
                    margin: const EdgeInsets.only(
                      left: 20.0,
                    ),
                    child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        iconSize: 25,
                        color: Color(
                            int.parse("#0097b2".substring(1, 7), radix: 16) +
                                0xFF000000),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ),
                  toolbarHeight: 90,
                ),
                body: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification:
                        (OverscrollIndicatorNotification overscroll) {
                      overscroll.disallowIndicator();
                      return true;
                    },
                    child: Center(
                      child: ListView(children: listW),
                      /*ElevatedButton(
                          onPressed: () {
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        )*/
                    )));
          }
        });
  }
}
