import 'package:portefolio/src/imports/imports.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        backgroundColor: Colors.white,
        title: const Text('Notificações',
            style: TextStyle(color: Color.fromRGBO(140, 82, 255, 1))),
        centerTitle: true,
        toolbarHeight: 40,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15.0),
            child: Icon(Icons.apps, color: Color.fromRGBO(140, 82, 255, 1)),
          )
        ],
      ),
      body: Column(),
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
                  icon: Icon(
                    Icons.notifications,
                    color: Color.fromRGBO(140, 82, 255, 1),
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
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
                    Icons.star_outline,
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
}
