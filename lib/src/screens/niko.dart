import 'package:portefolio/src/imports/imports.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({super.key});

  @override
  _ImagePageState createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage>
    with SingleTickerProviderStateMixin {
  String _currentStyle = 'happy';
  final User? user = FirebaseAuth.instance.currentUser;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  Map<String, String> _imageUrls = {}; // Map to store image URLs

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _preloadImageUrls();
  }

  Future<void> _preloadImageUrls() async {
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();
        if (userDoc.exists) {
          String? savedImage = userDoc.get('currentImage');
          if (savedImage != null) {
            setState(() {
              _currentStyle = savedImage.split('.').first;
            });
          }
        }
      } catch (e) {
        print('Error fetching saved image: $e');
      }
    }
    List<String> styles = ['happy', 'happy2', 'happy3', 'happy4', 'happy5'];
    for (String style in styles) {
      try {
        String imageName = '$style.png';
        String downloadURL = await FirebaseStorage.instance
            .ref('niko/$imageName')
            .getDownloadURL();
        _imageUrls[style] = downloadURL;
      } catch (e) {
        // Handle error if needed
        print('Error loading image URL for style $style: $e');
      }
    }
    setState(() {
      _controller.forward();
    });
  }

  void _toggleStyle() {
    setState(() {
      switch (_currentStyle) {
        case 'happy':
          _currentStyle = 'happy2';
          break;
        case 'happy2':
          _currentStyle = 'happy3';
          break;
        case 'happy3':
          _currentStyle = 'happy4';
          break;
        case 'happy4':
          _currentStyle = 'happy5';
          break;
        case 'happy5':
          _currentStyle = 'happy';
          break;
        default:
          _currentStyle = 'happy';
      }
      _controller.reset();
      _controller.forward();
    });
  }

  Future<void> _saveImageName() async {
    try {
      if (_currentStyle.isNotEmpty) {
        String imageName = '$_currentStyle.png';
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
      backgroundColor: Colors.white, // Set background to white
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
            _imageUrls[_currentStyle] != null
                ? FadeTransition(
                    opacity: _fadeAnimation,
                    child: SizedBox(
                      width: 400, // Increased width
                      height: 400, // Increased height
                      child: Image.network(_imageUrls[_currentStyle]!),
                    ),
                  )
                : const CircularProgressIndicator(),
            const SizedBox(height: 20),
            FloatingActionButton(
              heroTag: 'toggleStyle', // Unique tag
              onPressed: _toggleStyle,
              backgroundColor: Colors.deepPurple,
              child: const Icon(Icons.style),
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
