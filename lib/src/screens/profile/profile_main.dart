import 'package:portefolio/src/imports/imports.dart';
import 'package:portefolio/src/screens/profile/profile_niko.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _userName = 'Guest';
  String? _photoUrl;

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
          _userName = userDoc.get('name') ?? 'Guest';
          _photoUrl = userDoc.get('photoUrl');
        });
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> _deleteAccount() async {
    try {
      bool? confirmed = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirmação'),
          content: const Text(
              'Tens a certeza que pertendes eliminar a conta? Esta ação não é reversível!'),
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
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .delete();
      await FirebaseAuth.instance.currentUser!.delete();
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting account: $e')),
      );
    }
  }

  Future<void> _checkGoogleSignIn() async {
    if (FirebaseAuth.instance.currentUser!.uid != null) {
      try {
        final providers = FirebaseAuth.instance.currentUser!.providerData;
        bool isGoogleSignIn =
            providers.any((provider) => provider.providerId == 'google.com');

        if (isGoogleSignIn) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Com a utilização da conta Google, não é possível gerir a sua conta.'),
            ),
          );
        } else {
          Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    EditProfilePage(
                  user: null,
                ), // Pass user object here
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print(_photoUrl);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Color.fromRGBO(140, 82, 255, 1)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        title: Text('Perfil',
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
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              if (_photoUrl != null)
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(_photoUrl!),
                )
              else
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(
                      'https://www.hotelbooqi.com/wp-content/uploads/2021/12/128-1280406_view-user-icon-png-user-circle-icon-png.png'),
                ),
              SizedBox(
                height: 15,
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
                FirebaseAuth.instance.currentUser?.email ?? 'Guest',
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
                    Icon(Icons.analytics,
                        color: Color.fromRGBO(140, 82, 255, 1)),
                    Padding(padding: EdgeInsets.only(left: 2.5, right: 2.5)),
                    Text(
                      'Estatísticas',
                      style: TextStyle(color: Color.fromRGBO(140, 82, 255, 1)),
                    )
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
                onPressed: () {},
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.circle,
                      color: Color.fromRGBO(140, 82, 255, 1),
                    ),
                    Padding(padding: EdgeInsets.only(left: 2.5, right: 2.5)),
                    Text(
                      'myNiko',
                      style: TextStyle(color: Color.fromRGBO(140, 82, 255, 1)),
                    )
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
                onPressed: _signOut,
                style: ButtonStyle(overlayColor: WidgetStateColor.transparent),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout,
                      color: Colors.grey,
                    ),
                    Padding(padding: EdgeInsets.only(left: 5, right: 5)),
                    Text(
                      'Logout',
                      style: TextStyle(color: Colors.grey),
                    )
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
