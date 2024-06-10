import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
            ]),
        body: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/profile_example.png',
                    width: 100,
                    height: 100,
                  ),
                  const Text(
                    'Emanuel Freitas',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                  const Text(
                    'maneusfreitas@gmail.com',
                    style: TextStyle(
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
                    onPressed: () {},
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
                    onPressed: () {},
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
                    onPressed: () {},
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
                          color: Color.fromARGB(255, 218, 218, 218),
                          height: 1)),
                  const SizedBox(height: 25),
                  const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Color.fromRGBO(60, 0, 90, 1),
                    ),
                  ),
                ],
              ),
            )));
  }
}
