import 'package:pie_chart/pie_chart.dart';
import 'package:portefolio/src/imports/imports.dart';
import 'package:portefolio/src/screens/notifications/notifications_main.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  Future<List<DocumentSnapshot<Map<String, dynamic>>>> getQuizResult() async {
    final resultReference =
        FirebaseFirestore.instance.collection('quiz_result');
    final snapshot = await resultReference.get();
    return snapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DocumentSnapshot<Map<String, dynamic>>>>(
        future: getQuizResult(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
                backgroundColor: Colors.white,
                body: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro tentar recolher os dados'));
          } else {
            final data = snapshot.data!;
            List<Widget> listW = [];
            num sumResult = 0;
            num quizResult = 0;
            final Map<String, double> someMap = {
              "Positivos": 0,
              "Negativos": 0,
            };

            data.sort((a, b) => b
                .get('timestamp')
                .toString()
                .compareTo(a.get('timestamp').toString()));

            for (var resultDoc in data) {
              if (resultDoc.get('user_id') ==
                  FirebaseAuth.instance.currentUser?.uid) {
                DateTime now = resultDoc['timestamp'].toDate();
                String convertedDateTime =
                    "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
                print(convertedDateTime);
                sumResult += resultDoc.get('user_score');
                quizResult += resultDoc.get('quiz_score');

                if (resultDoc.get('user_score') * 2 >=
                    resultDoc.get('quiz_score')) {
                  someMap.update("Positivos", (value) => value + 1);
                } else {
                  someMap.update("Negativos", (value) => value + 1);
                }

                listW.add(Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(convertedDateTime),
                    const SizedBox(
                      width: 110,
                    ),
                    Text(
                      '${resultDoc.get('user_score')}/${resultDoc.get('quiz_score')}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Icon(
                      Icons.star,
                      color: Color.fromRGBO(140, 82, 255, 1),
                    )
                  ],
                ));

                listW.add(const SizedBox(
                  height: 20,
                ));
              }
            }

            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                forceMaterialTransparency: true,
                leading: null,
                backgroundColor: Colors.white,
                title: const Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Text('Estatísticas',
                      style: TextStyle(color: Color.fromRGBO(140, 82, 255, 1))),
                ),
                centerTitle: false,
                toolbarHeight: 70,
                actions: const [
                  Padding(
                    padding: EdgeInsets.only(right: 25.0),
                    child: Icon(Icons.apps,
                        color: Color.fromRGBO(140, 82, 255, 1)),
                  )
                ],
              ),
              body: SingleChildScrollView(
                  child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      width: 325,
                      height: 90,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: const Color.fromARGB(255, 219, 219, 219)),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: Color.fromRGBO(140, 82, 255, 1),
                            width: 100,
                            height: 90,
                            child: const Icon(
                              Icons.insert_chart,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Pontuação (média)',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(
                                (sumResult / data.length).toStringAsFixed(2) + ' pontos',
                                style: TextStyle(
                                    color: Color.fromRGBO(140, 82, 255, 1),
                                    fontSize: 15),
                              ),
                            ],
                          ),
                        ],
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      width: 325,
                      height: 90,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: const Color.fromARGB(255, 219, 219, 219)),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: Color.fromRGBO(140, 82, 255, 1),
                            width: 100,
                            height: 90,
                            child: const Icon(
                              Icons.stars_rounded,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Pontuação (total)',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(
                                sumResult.toString() +
                                    ' em ' +
                                    quizResult.toString() + ' pontos',
                                style: TextStyle(
                                    color: Color.fromRGBO(140, 82, 255, 1),
                                    fontSize: 15),
                              ),
                            ],
                          ),
                        ],
                      )),
                  const SizedBox(
                    height: 50,
                  ),
                  PieChart(
                    dataMap: someMap,
                    chartType: ChartType.ring,
                    baseChartColor: Colors.grey[50]!.withOpacity(0.15),
                    ringStrokeWidth: 40,
                    legendOptions: LegendOptions(
                      showLegendsInRow: false,
                      legendPosition: LegendPosition.left,
                      showLegends: true,
                    ),
                    chartRadius: MediaQuery.of(context).size.width / 3.2,
                    colorList: [
                      Color.fromRGBO(140, 82, 255, 1),
                      Color.fromARGB(140, 216, 191, 255)
                    ],
                    chartValuesOptions: ChartValuesOptions(
                      showChartValuesInPercentage: true,
                    ),
                    totalValue: data.length.toDouble(),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const Text(
                    'Histórico (últimos 10 jogos)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: listW.take(20).toList(),
                  ),
                ],
              )),
              bottomNavigationBar: BottomAppBar(
                color: Colors.white,
                child: Container(
                  height: 60.0,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation1,
                                          animation2) =>
                                      const NotificationsPage(), // Pass user object here
                                  transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero,
                                ));
                          },
                          icon: const Icon(Icons.notifications_outlined)),
                      IconButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation1,
                                        animation2) =>
                                    const HomePage(), // Pass user object here
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ));
                        },
                        icon: const Icon(Icons.home_outlined),
                      ),
                      IconButton(
                          onPressed: () {
                            // ícone da estrela
                          },
                          icon: const Icon(
                            Icons.star,
                            color: Color.fromRGBO(140, 82, 255, 1),
                          )),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation1,
                                        animation2) =>
                                    const ProfilePage(), // Pass user object here
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ));
                          },
                          icon: const Icon(Icons.person_outlined)),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}
