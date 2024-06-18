import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({super.key});

  @override
  _ImagePageState createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  String? _currentColor = 'green';
  String? _currentStyle = 'happy';
  String? _imageUrl;
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _fetchSavedImage();
  }

  Future<void> _fetchSavedImage() async {
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();
        if (userDoc.exists) {
          String? savedImage = userDoc.get('currentImage');
          if (savedImage != null) {
            List<String> parts = savedImage.split('_');
            setState(() {
              _currentStyle = parts[0];
              _currentColor = parts[2].split('.').first;
              _fetchImageUrl();
            });
          }
        }
      } catch (e) {
        // Handle error if needed
        return;
      }
    }
  }

  Future<void> _fetchImageUrl() async {
    try {
      if (_currentColor != null && _currentStyle != null) {
        String imageName = '${_currentStyle}_niko_${_currentColor}.png';
        String downloadURL = await FirebaseStorage.instance
            .ref('niko/$imageName')
            .getDownloadURL();

        setState(() {
          _imageUrl = downloadURL;
        });
      }
    } catch (e) {
      // Handle error if needed
      return;
    }
  }

  void _toggleColor() {
    setState(() {
      _currentColor = _currentColor == 'green' ? 'purple' : 'green';
      _fetchImageUrl();
    });
  }

  void _toggleStyle() {
    setState(() {
      _currentStyle = _currentStyle == 'happy' ? 'sad' : 'happy';
      _fetchImageUrl();
    });
  }

  Future<void> _saveImageName() async {
    try {
      if (_currentColor != null && _currentStyle != null) {
        String imageName = '${_currentStyle}_niko_${_currentColor}.png';
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .update({'currentImage': imageName});

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image name saved successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving image name: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'My Niko',
          style: TextStyle(color: Color.fromRGBO(140, 82, 255, 1)),
        ),
        centerTitle: true,
        toolbarHeight: 40,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageUrl != null
                ? Image.network(_imageUrl!)
                : const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: 'toggleColor', // Unique tag
                  onPressed: _toggleColor,
                  backgroundColor: Colors.deepPurple,
                  child: const Icon(Icons.color_lens),
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  heroTag: 'toggleStyle', // Unique tag
                  onPressed: _toggleStyle,
                  backgroundColor: Colors.deepPurple,
                  child: const Icon(Icons.style),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveImageName,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
