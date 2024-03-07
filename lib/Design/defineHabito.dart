import 'package:flutter/material.dart';

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
              'Texto aquí',
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
                      seleccionarDiasSemana: _seleccionarDiasSemana,
                      seleccionarDiasMes: _seleccionarDiasMes,
                      repetir: _repetir,
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

class FrecuenciaScreen extends StatefulWidget {
  final bool seleccionarDiasSemana;
  final bool seleccionarDiasMes;
  final bool repetir;

  FrecuenciaScreen({
    required this.seleccionarDiasSemana,
    required this.seleccionarDiasMes,
    required this.repetir,
  });

  @override
  _FrecuenciaScreenState createState() => _FrecuenciaScreenState();
}

class _FrecuenciaScreenState extends State<FrecuenciaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Frecuencia')),
      body: Column(
        children: [
          CheckboxListTile(
            title: Text('Cada día'),
            value: widget.seleccionarDiasSemana,
            onChanged: (value) {
              setState(() {
                // Lógica para manejar el cambio en la selección
              });
            },
          ),
          CheckboxListTile(
            title: Text('Días específicos de la semana'),
            value: widget.seleccionarDiasMes,
            onChanged: (value) {
              setState(() {
                // Lógica para manejar el cambio en la selección
              });
            },
          ),
          CheckboxListTile(
            title: Text('Días específicos del mes'),
            value: widget.repetir,
            onChanged: (value) {
              setState(() {
                // Lógica para manejar el cambio en la selección
              });
            },
          ),
          if (widget.seleccionarDiasSemana)
            Column(
              children: [
                CheckboxListTile(
                  title: Text('Lunes'),
                  value: widget.seleccionarDiasSemana,
                  onChanged: (value) {
                    setState(() {
                      // Lógica para seleccionar/deseleccionar el lunes
                    });
                  },
                ),
                // Repetir para cada día de la semana
              ],
            ),
          if (widget.seleccionarDiasMes)
            Column(
              children: [
                // Lógica para seleccionar los días del mes
              ],
            ),
          if (widget.repetir)
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Repetir cada (en días)',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  // Lógica para actualizar la repetición
                });
              },
            ),
        ],
      ),
    );
  }
}
