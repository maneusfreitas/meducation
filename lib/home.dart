import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:portefolio/profile.dart';
import 'search.dart';

class HomePage extends StatefulWidget {
  final User? user;

  const HomePage({super.key, this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _file;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _file = File(result.files.single.path!);
      });
    } else {
      // User canceled the picker
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
                'Hello, ${widget.user?.displayName ?? 'Guest'}',
                style: const TextStyle(
                    color: Color.fromARGB(255, 1, 1, 1),
                    fontWeight: FontWeight.bold),
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
              onPressed: _pickFile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple, // Background color
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
            if (_file != null) Text('File selected: ${_file!.path}')
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
                onPressed: () {},
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
                    MaterialPageRoute(builder: (context) => SearchPage()),
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
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage()),
                        );
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
