import 'package:portefolio/src/imports/imports.dart';
import 'package:portefolio/src/screens/statistics/statistics_main.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        backgroundColor: Colors.white,
        title: const Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: Text('Notificações',
              style: TextStyle(color: Color.fromRGBO(140, 82, 255, 1))),
        ),
        centerTitle: false,
        toolbarHeight: 70,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 25.0),
            child: Icon(Icons.apps, color: Color.fromRGBO(140, 82, 255, 1)),
          )
        ],
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            Icon(
              Icons.warning,
              color: Colors.grey,
            ),
            SizedBox(height: 10),
            Text('Em construção')
          ])),
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
                              HomePage(), // Pass user object here
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ));
                  },
                  icon: Icon(Icons.home_outlined)),
              IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              StatisticsPage(), // Pass user object here
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ));
                  },
                  icon: Icon(
                    Icons.star_outline,
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              const ProfilePage(), // Pass user object here
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ));
                  },
                  icon: Icon(Icons.person_outlined)),
            ],
          ),
        ),
      ),
    );
  }
}
