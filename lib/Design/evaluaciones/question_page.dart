import 'package:flutter/material.dart';

class QuestionPage extends StatelessWidget {
  final int questionNumber;
  final ValueChanged<bool?> onAnswerSelected;
  final VoidCallback? onClose;

  const QuestionPage(
      {required this.questionNumber, required this.onAnswerSelected, this.onClose});

  // Lista de preguntas
  static const List<String> questions = [
    "¿Te sientes capaz de enfrentar desafíos y resolver problemas de manera efectiva?",
    "¿Sientes que mereces amor y respeto de los demás?",
    "¿Confías en tus habilidades y talentos?",
    "¿Te comparas constantemente con los demás y te sientes inferior?",
    "¿Puedes aceptar tus errores y aprender de ellos sin sentirte demasiado afectado?",
    "¿Te sientes satisfecho contigo mismo/a en general?",
    "¿Sientes que tienes el control sobre tu vida y tus decisiones?",
    "¿Te sientes cómodo/a expresando tus opiniones y emociones?",
    "¿Te preocupas demasiado por la aprobación de los demás?",
    "¿Tienes una imagen positiva de ti mismo/a y de tu futuro?"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                questions[questionNumber - 1], // Mostrar la pregunta actual
                textAlign: TextAlign.center, // Centrar el texto
                style: TextStyle(fontSize: 18), // Tamaño de la fuente
              ),
            ),
            SizedBox(height: 20),
            _buildAnswerButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            onAnswerSelected(true);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Color(0xFF2773B9), // Color de fondo para la respuesta "Sí"
          ),
          child: Text('Sí', style: TextStyle(color: Colors.white)),
        ),
        SizedBox(width: 10), // Espacio entre los botones
        ElevatedButton(
          onPressed: () {
            onAnswerSelected(false);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Color(0xFF2773B9), // Color de fondo para la respuesta "No"
          ),
          child: Text('No', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
