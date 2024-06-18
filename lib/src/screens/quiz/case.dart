import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portefolio/src/data/dataset.dart';
import 'package:portefolio/src/models/question.dart';
import 'package:portefolio/src/models/quiz.dart';

class Case extends StatefulWidget {
  const Case({super.key});

  @override
  State<Case> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<Case> {
  Future<List<DocumentSnapshot<Map<String, dynamic>>>> getCases() async {
    final casesRef = FirebaseFirestore.instance.collection('cases');

    final cases = await casesRef.get().then((QuerySnapshot snapshot) async {
      final docs = snapshot.docs;

      for (var data in docs) {
        print(data.data());
        print(data.id);

        try {
          final aRef = FirebaseFirestore.instance
              .collection('cases')
              .doc(data.id)
              .collection('questions');

          final a = await aRef.get().then((QuerySnapshot snapshot2) {
            final docs2 = snapshot2.docs;
            for (var data2 in docs2) {
              print(data2.data());
              print(data2.id);
            }
          });
        } catch (ex) {
          print(ex.toString());
        }
      }
    });

    return cases.docs;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DocumentSnapshot<Map<String, dynamic>>>>(
        future: getCases(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro tentar recolher os dados'));
          } else {
            final cases = snapshot.data!;

            for (var caseMed in cases) {
              final id = caseMed.id;
              final title = caseMed.data()!['title'];
              final List<Question> questions = [];

              quizDataset.add(Quiz(title: title, questions: questions));
            }

            quizDataset;

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
                    child: Column(children: [
                      const TextField(
                        decoration: InputDecoration(
                          hintText: 'Oi',
                        ),
                      ),
                      TextButton(
                          onPressed: () {}, child: const Text('Pesquisar')),
                    ])));
          }
        });
  }
}
