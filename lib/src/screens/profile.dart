import 'package:portefolio/src/imports/imports.dart';

class ProfilePage extends StatefulWidget {
  final User? user;

  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _userName = 'Guest';
  String? _photoUrl; // To store the profile photo URL

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
            _photoUrl = userDoc.get('photoUrl'); // Fetch the photo URL
          });
        }
      } catch (e) {
        print('Error fetching user name: $e');
      }
    }
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  Future<void> _deleteAccount() async {
    try {
      bool? confirmed = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text(
              'Are you sure you want to delete your account? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );

      if (confirmed != true) return;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user!.uid)
          .delete();
      await widget.user!.delete();
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting account: $e')),
      );
    }
  }

  Future<void> _checkGoogleSignIn() async {
    if (widget.user != null) {
      try {
        final signInMethods = await FirebaseAuth.instance
            .fetchSignInMethodsForEmail(widget.user!.email!);
        print('Sign-in methods: $signInMethods');
        if (signInMethods.contains('google.com')) {
          print('User is signed in with Google');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Com a utilização da conta Google, não é possível gerir a sua conta.'),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditProfilePage(user: widget.user),
            ),
          );
        }
      } catch (e) {
        print('Error checking sign-in methods: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Perfil',
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
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              if (_photoUrl != null)
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(_photoUrl!),
                )
              else
                const CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      AssetImage('assets/images/profile_example.png'),
                ),
              Text(
                _userName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              Text(
                widget.user?.email ?? 'Guest',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 50),
              TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Colors.white,
                  fixedSize: const Size(275, 50),
                  side: const BorderSide(
                      color: Color.fromARGB(255, 218, 218, 218)),
                ),
                onPressed: () {},
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.analytics),
                    Padding(padding: EdgeInsets.only(left: 2.5, right: 2.5)),
                    Text('Estatísticas')
                  ],
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Colors.white,
                  fixedSize: const Size(275, 50),
                  side: const BorderSide(
                      color: Color.fromARGB(255, 218, 218, 218)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ImagePage()),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.circle),
                    Padding(padding: EdgeInsets.only(left: 2.5, right: 2.5)),
                    Text('myNiko')
                  ],
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: const Color.fromRGBO(60, 0, 90, 1),
                  foregroundColor: Colors.white,
                  fixedSize: const Size(275, 50),
                  side: const BorderSide(
                      color: Color.fromARGB(255, 218, 218, 218)),
                ),
                onPressed: _checkGoogleSignIn,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit),
                    Padding(padding: EdgeInsets.only(left: 2.5, right: 2.5)),
                    Text('Gerir conta')
                  ],
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                  fixedSize: const Size(275, 50),
                  side: const BorderSide(
                      color: Color.fromARGB(255, 218, 218, 218)),
                ),
                onPressed: _deleteAccount,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delete),
                    Padding(padding: EdgeInsets.only(left: 2.5, right: 2.5)),
                    Text('Eliminar conta')
                  ],
                ),
              ),
              const SizedBox(height: 50),
              const Padding(
                padding: EdgeInsets.only(left: 70, right: 70),
                child: Divider(
                    color: Color.fromARGB(255, 218, 218, 218), height: 1),
              ),
              const SizedBox(height: 25),
              TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                  fixedSize: const Size(275, 50),
                  side: const BorderSide(
                      color: Color.fromARGB(255, 218, 218, 218)),
                ),
                onPressed: _signOut,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout),
                    Padding(padding: EdgeInsets.only(left: 2.5, right: 2.5)),
                    Text('Logout')
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
