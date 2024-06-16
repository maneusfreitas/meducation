import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ImagePageState createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _fetchImageUrl();
  }

  Future<void> _fetchImageUrl() async {
    try {
      // Get the download URL from Firebase Storage
      String downloadURL = await FirebaseStorage.instance
          .ref('niko/happy_niko.png')
          .getDownloadURL();

      setState(() {
        _imageUrl = downloadURL;
      });
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('My Niko',
            style: TextStyle(color: Color.fromRGBO(140, 82, 255, 1))),
        centerTitle: true,
        toolbarHeight: 40,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15.0),
          )
        ],
      ),
      body: Center(
        child: _imageUrl != null
            ? Image.network(_imageUrl!)
            : const CircularProgressIndicator(),
      ),
    );
  }
}
