import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:portefolio/src/screens/notifications/notifications_main.dart';
import 'package:portefolio/src/screens/profile/profile_main.dart';
import 'package:portefolio/src/screens/quiz/quiz_load.dart';
import 'package:portefolio/src/screens/statistics/statistics_main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _userName = '';
  String _nikoImage = '';
  String _downloadImage = '';

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          _userName = userDoc.get('name');
          _nikoImage = userDoc.get('currentImage');
        });
      }
    } catch (e) {}
  }

  Future<void> getNikoImage() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      String _downloadImage = await FirebaseStorage.instance
          .ref('niko/${userDoc.get('currentImage')}')
          .getDownloadURL();
      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        backgroundColor: Colors.white,
        title: const Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: Text('Meducation',
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: const Text(
              'Bem-vindo',
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            child: Text(
              _userName,
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Center(
            child: Container(
              width: 300,
              height: 350,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: const Color.fromARGB(255, 219, 219, 219)),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/niko_logo.png',
                    width: 150,
                    height: 150,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Vem ajudar o teu Niko!',
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  TestScreen(), // Pass user object here
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        'Jogar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                  Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            NotificationsPage(), // Pass user object here
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ));
                },
                icon: Icon(Icons.notifications_outlined),
              ),
              IconButton(
                onPressed: () {
                  // Navigate to home page
                },
                icon: Icon(
                  Icons.home,
                  color: Color.fromRGBO(140, 82, 255, 1),
                ),
              ),
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
                icon: Icon(Icons.star_outline),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              ProfilePage(), // Pass user object here
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
