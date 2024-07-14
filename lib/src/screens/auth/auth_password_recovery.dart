import 'package:portefolio/src/imports/imports.dart';

class PasswordRecoveryPage extends StatefulWidget {
  const PasswordRecoveryPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PasswordRecoveryPageState createState() => _PasswordRecoveryPageState();
}

class _PasswordRecoveryPageState extends State<PasswordRecoveryPage> {
  final TextEditingController _emailController = TextEditingController();

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Future<void> _saveUserData(User user) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!userDoc.exists) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': user.displayName,
        'email': user.email,
        'photoUrl': user.photoURL,
        'currentImage': 'sad_niko_purple.png',
      });
    }
  }

  Future<User?> _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        return null;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        await _saveUserData(user);
      }

      return user;
    } catch (error) {
      return null;
    }
  }

  Future<void> _resetPassword() async {
    String email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter an email address."),
        ),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              "If an account exists for this email, a password reset email has been sent."),
        ),
      );
      _emailController.clear();
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error resetting password, please try again."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double commonWidth = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        forceMaterialTransparency: true,
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'M',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.normal,
                  color: Colors.deepPurple,
                ),
              ),
              TextSpan(
                text: 'education',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        toolbarHeight: 70,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Insere o teu e-mail para repor a palavra-passe',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: commonWidth,
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: commonWidth,
                  child: ElevatedButton(
                    onPressed: _resetPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 80, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text('Enviar recuperação',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: commonWidth,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      User? user = await _handleGoogleSignIn();
                      if (user != null) {
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  HomePage(
                              ), // Pass user object here
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ));
                      }
                    },
                    icon: Image.asset(
                      'assets/images/gmail_icon.png',
                      width: 24,
                      height: 24,
                    ),
                    label: RichText(
                      text: const TextSpan(
                        text: 'Continuar com ',
                        style: TextStyle(color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Google',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                        side: const BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              LoginPage(), // Pass user object here
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ));
                  },
                  child: RichText(
                    text: const TextSpan(
                      text: "Já tens uma conta? ",
                      style: TextStyle(color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Entra aqui',
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
