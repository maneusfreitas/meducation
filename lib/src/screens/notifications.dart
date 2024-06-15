import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Meducation'),
        centerTitle: true,
      ),
      body: const Center(),
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
                  // ícone da lupa
                },
                icon: Image.asset(
                  'assets/icons/heart.png',
                  width: 24,
                  height: 24,
                ),
              ),
              IconButton(
                onPressed: () {
                  // ícone do coração
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
                  // ícone do usuário
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

void main() {
  runApp(const MaterialApp(
    home: HomePage(),
  ));
}
