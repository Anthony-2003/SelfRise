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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 50.0), // Margen top deseado
                child: Text(
                  'Define tu hábito',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
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
            ],
          ),
        ),
      ),
    );
  }
}
