import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portefolio/src/screens/profile.dart';
import 'package:portefolio/src/screens/quiz/case.dart';
import 'package:portefolio/src/screens/search.dart';

class HomePage extends StatefulWidget {
  final User? user;

  const HomePage({super.key, required this.user});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _userName = 'Guest';
  List something = [];

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    if (widget.user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.user!.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            _userName = userDoc.get('name') ?? 'Guest';
          });
        }
      } catch (e) {
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Meducation'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Hello, $_userName',
                style: const TextStyle(
                  color: Color.fromARGB(255, 1, 1, 1),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Implement file picking logic
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
                'Introduce Questions',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Display file name or any other content based on your logic
          ],
        ),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Case(),
                    ),
                  );
                },
                icon: Image.asset(
                  'assets/icons/heart.png',
                  width: 24,
                  height: 24,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SearchPage()),
                  );
                },
                icon: Image.asset(
                  'assets/icons/search.png',
                  width: 24,
                  height: 24,
                ),
              ),
              IconButton(
                onPressed: () {
                  // Navigate to home page
                },
                icon: Image.asset(
                  'assets/icons/home.png',
                  width: 24,
                  height: 24,
                ),
              ),
              IconButton(
                onPressed: () {
                  // Implement star logic
                },
                icon: Image.asset(
                  'assets/icons/star.png',
                  width: 24,
                  height: 24,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            ProfilePage(
                                user: widget.user), // Pass user object here
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ));
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
}
