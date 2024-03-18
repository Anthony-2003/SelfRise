import 'package:flutter/material.dart';

class EvaluarProgresoScreen extends StatefulWidget {
  final PageController pageController;

  EvaluarProgresoScreen(this.pageController);

  @override
  _EvaluarProgresoScreenState createState() => _EvaluarProgresoScreenState();
}

class _EvaluarProgresoScreenState extends State<EvaluarProgresoScreen> {
  void animateToPage() {
    widget.pageController.animateToPage(
      2,
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(
              20.0),
          child: ListView(
            children: [
              SizedBox(height: 20.0),
              Text(
                '¿Cómo quieres evaluar tu progreso?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  animateToPage();
                },
                child: Text('Con si o no'),
              ),
              SizedBox(height: 10.0),
              Text(
                'Si solo desea registrar si tuvo éxito con la actividad o no',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  animateToPage();
                },
                child: Text('Con valor numérico'),
              ),
              SizedBox(height: 10.0),
              Text(
                'Si solo quieres establecer un valor como meta diaria o límite para el hábito',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
