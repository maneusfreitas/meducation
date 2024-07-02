import 'package:portefolio/src/imports/imports.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  Future<List<DocumentSnapshot<Map<String, dynamic>>>> getQuiz() async {
    final resultReference =
        FirebaseFirestore.instance.collection('quiz_result');
    final wait = await resultReference.get();

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
            final data = snapshot.data!;
            List<Widget> listW = [];
            num sumResult = 0;

            for (var resultDoc in data) {
              if (resultDoc.get('user_id') ==
                  FirebaseAuth.instance.currentUser?.uid) {
                DateTime now = resultDoc['timestamp'].toDate();
                String convertedDateTime =
                    "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
                print(convertedDateTime);
                sumResult += resultDoc.get('user_score');

                listW.add(Row(
                  children: [
                    Text(convertedDateTime),
                    SizedBox(
                      width: 50,
                    ),
                    Text(resultDoc.get('user_score').toString() +
                        '/' +
                        resultDoc.get('quiz_score').toString()),
                    Icon(Icons.star)
                  ],
                ));
              }
            }

            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                leading: null,
                backgroundColor: Colors.white,
                title: const Text('Estatísticas',
                    style: TextStyle(color: Color.fromRGBO(140, 82, 255, 1))),
                centerTitle: true,
                toolbarHeight: 40,
                actions: const [
                  Padding(
                    padding: EdgeInsets.only(right: 15.0),
                    child: Icon(Icons.apps,
                        color: Color.fromRGBO(140, 82, 255, 1)),
                  )
                ],
              ),
              body: Column(
                children: [
                  Text('Average Score: ${sumResult / data.length}'),
                  SizedBox(
                    height: 50,
                  ),
                  Column(
                    children: listW,
                  ),
                ],
              ),
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
                            // ícone da lupa
                          },
                          icon: Icon(Icons.notifications_outlined)),
                      IconButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation1, animation2) =>
                                          HomePage(user: null), // Pass user object here
                                  transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero,
                                ));
                          },
                          icon: Icon(Icons.home_outlined)),
                      IconButton(
                          onPressed: () {
                            // ícone da estrela
                          },
                          icon: Icon(
                            Icons.star,
                            color: Color.fromRGBO(140, 82, 255, 1),
                          )),
                      IconButton(
                          onPressed: () {
                            // ícone do usuário
                          },
                          icon: Icon(Icons.person_outlined)),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}
