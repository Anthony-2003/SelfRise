  import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/components/app_bart.dart';

class EvaluationScreen extends StatefulWidget {
  @override
  _EvaluationScreenState createState() => _EvaluationScreenState();
}

class _EvaluationScreenState extends State<EvaluationScreen> {
  List<Question> questions = [
    Question(
      statement: "¿Te sientes seguro de ti mismo/a la mayor parte del tiempo?",
      options: ["Sí", "No"],
    ),
    Question(
      statement: "¿Qué tan a menudo te comparas con otras personas?",
      options: ["Nunca", "A veces", "Frecuentemente"],
    ),
    // Agrega más preguntas según sea necesario
  ];

  Map<int, int> answers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          decoration: BoxDecoration(
            color: Color(0xFF2773B9),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
          child: Center(
            child: CustomAppBar(
              titleText: "Ealuación",
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(questions[index].statement),
            trailing: DropdownButton<String>(
              value: answers[index]?.toString(),
              onChanged: (String? newValue) {
                setState(() {
                  answers[index] = int.parse(newValue!);
                });
              },
              items: questions[index]
                  .options
                  .asMap()
                  .entries
                  .map<DropdownMenuItem<String>>(
                    (MapEntry<int, String> entry) {
                  return DropdownMenuItem<String>(
                    value: entry.key.toString(),
                    child: Text(entry.value),
                  );
                }).toList(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Calcula el puntaje total
          int totalScore = 0;
          answers.forEach((index, answer) {
            totalScore += answer;
          });

          // Aquí puedes agregar lógica para determinar el mensaje basado en el puntaje total
          String message = "¡Tu autoestima es alta!";
          if (totalScore < 5) {
            message = "Podrías trabajar en mejorar tu autoestima.";
          } else if (totalScore < 8) {
            message = "Tu autoestima está en un punto intermedio.";
          }

          // Muestra el diálogo con el mensaje
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Resultado de la Evaluación"),
                content: Text(message),
                actions: <Widget>[
                 
                ],
              );
            },
          );
        },
        child: Icon(Icons.check),
      ),
    );
  }
}

class Question {
  final String statement;
  final List<String> options;

  Question({required this.statement, required this.options});
}
