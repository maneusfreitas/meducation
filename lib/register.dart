import 'package:flutter/material.dart';
import 'validation.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double commonWidth = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Registo'),
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
                  'Meducation',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: commonWidth,
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: commonWidth,
                  child: TextField(
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      labelText: 'Palavra-passe',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible ? Icons.visibility : Icons.visibility_off,
                          color: Colors.deepPurple,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: commonWidth,
                  child: TextField(
                    obscureText: !_confirmPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Confirmar Palavra-passe',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          color: Colors.deepPurple,
                        ),
                        onPressed: () {
                          setState(() {
                            _confirmPasswordVisible = !_confirmPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: commonWidth,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Data de Nascimento',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onTap: () async {
                      DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: commonWidth,
                  child: ElevatedButton(
                    onPressed: () {
                      String email = _emailController.text;
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => VerificationPage(email: email)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text('Verificar Conta', style: TextStyle(color: Colors.white)),
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
