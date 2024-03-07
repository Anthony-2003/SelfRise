import 'package:flutter/material.dart';
import 'frecuenciaHabito.dart'; // Importa el archivo de la pantalla de frecuencia

class DefineHabitoScreen extends StatefulWidget {
  @override
  _DefineHabitoScreenState createState() => _DefineHabitoScreenState();
}

class _DefineHabitoScreenState extends State<DefineHabitoScreen> {
  String _habito = '';
  String _descripcion = '';
  bool _seleccionarDiasSemana = false;
  bool _seleccionarDiasMes = false;
  bool _repetir = false;

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
              onChanged: (value) {
                setState(() {
                  _habito = value;
                });
              },
            ),
            SizedBox(height: 20.0),
            Text(
              'e.j., leer',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Descripción (Opcional)',
              ),
              onChanged: (value) {
                setState(() {
                  _descripcion = value;
                });
              },
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Aquí guardamos el hábito y navegamos a la pantalla de frecuencia
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FrecuenciaScreen(
                      repetir: _repetir, // Pasa el valor de repetir a la pantalla de frecuencia
                    ),
                  ),
                );
              },
              child: Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
