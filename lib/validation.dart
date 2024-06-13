import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'register.dart'; // Update this with the correct import for RegisterPage
import 'home.dart'; // Replace with your home page import

class VerificationPage extends StatefulWidget {
  final String email;

  const VerificationPage({required this.email});

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  TextEditingController _codeController = TextEditingController();
  int _attemptsRemaining = 3;
  Duration _timerDuration = Duration(minutes: 5);
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timerDuration.inSeconds > 0) {
        setState(() {
          _timerDuration = Duration(seconds: _timerDuration.inSeconds - 1);
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _codeController.dispose();
    super.dispose();
  }

  void _resendCode() {
    if (_attemptsRemaining > 0) {
      setState(() {
        _attemptsRemaining--;
        _timerDuration = Duration(minutes: 5);
        _startTimer();
      });
      // Implement resend verification code logic here
      // Example: FirebaseAuth.instance.sendEmailVerification();
    }
  }

  void _verifyCode() async {
    try {
      // Verify the code entered by the user
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: widget.email, password: _codeController.text);

      // Check if the user's email is verified
      if (userCredential.user!.emailVerified) {
        // Navigate to home page or any other screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(user: userCredential.user)),
        );
      } else {
        // Email not verified, handle accordingly
        // Example: Show error message or prompt to resend verification
      }
    } catch (e) {
      print("Error verifying code: $e");
      // Handle verification errors
      // Example: Show error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    final double commonWidth = MediaQuery.of(context).size.width * 0.8;
    String timerText =
        "${_timerDuration.inMinutes}:${(_timerDuration.inSeconds % 60).toString().padLeft(2, '0')}";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Email Verification'),
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
                SizedBox(height: 10),
                Text(
                  'We have sent a verification code to the email',
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                Text(
                  widget.email,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Container(
                  width: commonWidth,
                  child: TextField(
                    controller: _codeController,
                    decoration: InputDecoration(
                      labelText: 'Verification Code',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                SizedBox(height: 20),
                Text(timerText, style: TextStyle(fontSize: 20)),
                SizedBox(height: 20),
                Container(
                  width: commonWidth,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[300],
                      padding:
                          EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text('Cancel Registration',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: commonWidth,
                  child: ElevatedButton(
                    onPressed: _attemptsRemaining > 0 ? _resendCode : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Colors.black),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: RichText(
                      text: TextSpan(
                        text: 'Resend Code ',
                        style: TextStyle(color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: '($_attemptsRemaining attempts)',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: commonWidth,
                  child: ElevatedButton(
                    onPressed: _verifyCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[900],
                      padding:
                          EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text('Verify Registration',
                        style: TextStyle(color: Colors.white)),
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
