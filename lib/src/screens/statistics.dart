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
            final userData = snapshot.data!;
            List<Widget> listW = [];

            for (var resultDoc in userData) {
              if (resultDoc.get('user_id') ==
                  FirebaseAuth.instance.currentUser?.uid) {

                    DateTime now = resultDoc['timestamp'].toDate();
                    String convertedDateTime = "${now.year.toString()}-${now.month.toString().padLeft(2,'0')}-${now.day.toString().padLeft(2,'0')} ${now.hour.toString().padLeft(2,'0')}:${now.minute.toString().padLeft(2,'0')}";
                    print(convertedDateTime);

                listW.add(Row(
                  children: [
                    Text(convertedDateTime),
                    SizedBox(width: 50,),
                        Text(
                        resultDoc.get('user_score').toString() +
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
                backgroundColor: Colors.white,
                title: const Text('Meducation'),
                centerTitle: true,
              ),
              body: Column(
                children: listW,
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
                        icon: Image.asset(
                          'assets/icons/heart.png',
                          width: 24,
                          height: 24,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // ícone do coração
                        },
                        icon: Image.asset(
                          'assets/icons/search.png',
                          width: 24,
                          height: 24,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // ícone da casa
                        },
                        icon: Image.asset(
                          'assets/icons/home.png',
                          width: 24,
                          height: 24,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // ícone da estrela
                        },
                        icon: Image.asset(
                          'assets/icons/star.png',
                          width: 24,
                          height: 24,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // ícone do usuário
                        },
                        icon: Image.asset(
                          'assets/icons/user.png',
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}
