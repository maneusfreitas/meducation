import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:portefolio/src/dataset/dataset.dart';
import 'package:portefolio/src/models/quiz_model.dart';
import 'package:portefolio/src/models/quiz_result_model.dart';
import 'package:portefolio/src/screens/home.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultState();
}

class _ResultState extends State<ResultScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double countGood = 0;
    int countGlobalGood = 0;
    int countAnswer = 0;

    int indexM = 0;
    int indexQ = 0;
    int indexA = 0;

    for (var quiz in quizDatasetCopy) {
      indexQ = 0;

      for (var question in quiz.questions) {
        indexA = 0;

        for (var answer in question.answers) {
          bool resultGood = quizDataset
              .elementAt(indexM)
              .questions
              .elementAt(indexQ)
              .answers
              .elementAt(indexA)
              .result;

          if (resultGood == true) countGlobalGood++;

          if ((answer.result == resultGood) && (answer.result == true)) {
            countGood++;
          } else if (answer.result == true && resultGood == false) {
            countGood = countGood - 0.8;
          }

          countAnswer++;
          indexA++;
        }

        indexQ++;
      }

      indexM++;
    }

    double perc = (countGood / countGlobalGood) * 100;

    final Map<String, double> someMap = {
      "Certas": countGood.toDouble(),
      "Erradas": (countGlobalGood - countGood).toDouble(),
    };

    final uid = FirebaseAuth.instance.currentUser?.uid;
    FirebaseFirestore.instance.collection('quiz_result').add(QuizResult(
            userId: uid,
            quizId: quizDataset.first.id,
            userScore: countGood.toInt(),
            quizScore: countGlobalGood,
            timestamp: Timestamp.now())
        .toJson());

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          forceMaterialTransparency: true,
          backgroundColor: Colors.white,
          toolbarHeight: 0,
          bottomOpacity: 0.5,
          elevation: 0.5,
          automaticallyImplyLeading: false,
        ),
        body: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Parabéns!',
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(
                  height: 25,
                ),
                const Image(
                  image: NetworkImage(
                      'https://cdn-icons-png.flaticon.com/512/4832/4832868.png'),
                  width: 150,
                  height: 150,
                ),
                SizedBox(
                  height: 25,
                ),
                const Text('Score',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(
                  '${countGood.toStringAsFixed(2)} / $countGlobalGood (${perc.toStringAsFixed(2)}%)',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 25,
                ),
                Text('Nº de questões: $indexQ'),
                Text('Nº de respostas: $countAnswer'),
                /*PieChart(
                  dataMap: someMap,
                  chartType: ChartType.ring,
                  baseChartColor: Colors.grey[50]!.withOpacity(0.15),
                  legendOptions: LegendOptions(
                    showLegendsInRow: false,
                    legendPosition: LegendPosition.left,
                    showLegends: false,
                  ),
                  chartRadius: MediaQuery.of(context).size.width / 3.2,
                  colorList: [
                    Color.fromRGBO(140, 82, 255, 1),
                    Color.fromARGB(140, 216, 191, 255)
                  ],
                  chartValuesOptions: ChartValuesOptions(
                    showChartValuesInPercentage: true,
                  ),
                  totalValue: (countGlobalGood).toDouble(),
                ),*/
                SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);

                    Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              const HomePage(
                            user: null,
                          ), // Pass user object here
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ));
                  },
                  child: Text(
                    'Voltar ao menu',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                )
              ],
            ))));
  }
}
