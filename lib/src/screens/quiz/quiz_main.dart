import 'package:flutter/material.dart';
import 'package:portefolio/src/dataset/dataset.dart';
import 'package:portefolio/src/screens/quiz/quiz_result.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizState();
}

class _QuizState extends State<QuizScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double windowWidth = MediaQuery.sizeOf(context).width;
    List<Widget> listW = [];

    for (var quiz in quizDatasetCopy) {
      listW.add(Text(quiz.title, style: const TextStyle(fontSize: 15)));

      for (var question in quiz.questions) {
        listW.add(const SizedBox(height: 50));  
        listW.add(Text(question.title,
            style:
                const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)));
        listW.add(const SizedBox(height: 10));

        for (var answer in question.answers) {
          listW.add(CheckboxListTile(
              title: Text(
                answer.title,
                style: const TextStyle(fontSize: 10),
              ),
              value: answer.result,
              onChanged: (value) {
                setState(() {
                  answer.result = !answer.result;
                });
              }));

          listW.add(const SizedBox(height: 5));
        }
      }
    }

    listW.add(const SizedBox(height: 50));  

    listW.add(ElevatedButton(
      onPressed: () {
        Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) =>
                  const ResultScreen(), // Pass user object here
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        padding: const EdgeInsets.symmetric(horizontal: 125, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
      ),
      child: const Text(
        'Submit',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    ));

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          forceMaterialTransparency: true,
          backgroundColor: Colors.white,
          title: const Text('Quiz',
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
        body: Center(
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(25.0),
                child: Column(children: listW))));
  }
}
