import 'package:flutter/material.dart';

class EvaluarProgresoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(20.0),
          children: [
            Text(
              '¿Cómo quieres evaluar tu progreso?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                DefineHabitoScreen();
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
                // Navegar a la pantalla de progreso con valor numérico
              },
              child: Text('Con valor numérico'),
            ),
            SizedBox(height: 10.0),
            Text(
              'si solo quieres establecer un valor como meta diaria o límite para el hábito',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla de progreso con temporizador
              },
              child: Text('Con temporizador'),
            ),
            SizedBox(height: 10.0),
            Text(
              'si quieres establecer un valor de tiempo como meta diaria o límite para el hábito',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class DefineHabitoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(20.0),
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Hábito',
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Texto aquí',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Descripción (Opcional)',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Aquí puedes implementar la lógica para guardar el hábito
              },
              child: Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}