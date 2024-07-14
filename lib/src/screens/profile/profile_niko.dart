import 'package:portefolio/src/imports/imports.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ImagePageState createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage>
    with SingleTickerProviderStateMixin {
  String _currentStyle = 'happy';
  final User? user = FirebaseAuth.instance.currentUser;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  final Map<String, String> _imageUrls = {}; // Map to store image URLs

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
        // ignore: empty_catches
      } catch (e) {}
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

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image name saved successfully')),
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving image name: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Color.fromRGBO(140, 82, 255, 1)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        title: Text('myNiko',
            style: TextStyle(color: Color.fromRGBO(140, 82, 255, 1))),
        centerTitle: false,
        toolbarHeight: 70,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 25.0),
            child: Icon(Icons.apps, color: Color.fromRGBO(140, 82, 255, 1)),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageUrls[_currentStyle] != null
                ? FadeTransition(
                    opacity: _fadeAnimation,
                    child: SizedBox(
                      width: 350, // Increased width
                      height: 350, // Increased height
                      child: Image.network(_imageUrls[_currentStyle]!),
                    ),
                  )
                : const CircularProgressIndicator(),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _toggleStyle,
                  child: const Icon(
                    Icons.color_lens,
                    color: Colors.white,
                    size: 22.5,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                ElevatedButton(
                  onPressed: _saveImageName,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(140, 82, 255, 1),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Guardar alterações',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
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
