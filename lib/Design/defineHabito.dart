import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/entity/Habito.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DefineHabitoScreen extends StatefulWidget {
  final Function(String) onHabitoChanged;

  DefineHabitoScreen({Key? key, required this.onHabitoChanged})
      : super(key: key);

  @override
  _DefineHabitoScreenState createState() => _DefineHabitoScreenState();
}

class _DefineHabitoScreenState extends State<DefineHabitoScreen> {
  String _habito = '';
  String _descripcion = '';
  bool _seleccionarDiasSemana = false;
  bool _seleccionarDiasMes = false;
  bool _repetir = false;
  FocusNode _focusNode = FocusNode();
  FocusNode _descripcionFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });

    _descripcionFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _descripcionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(Habito.evaluateProgress);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 50.0),
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
                focusNode: _focusNode,
                onTap: () {
                  setState(() {
                    FocusScope.of(context).requestFocus(_focusNode);
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Hábito',
                  labelStyle: TextStyle(
                    color: _focusNode.hasFocus
                        ? Color.fromARGB(255, 24, 85, 142)
                        : Colors.black,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 24, 85, 142)),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _habito = value;
                    Habito.habitName = _habito;
                  });
                  widget.onHabitoChanged(value);
                },
              ),
              SizedBox(height: 20.0),
              Text(
                'e.j., leer',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              TextFormField(
                focusNode: _descripcionFocusNode,
                decoration: InputDecoration(
                  labelText: 'Descripción (Opcional)',
                  labelStyle: TextStyle(
                    color: _descripcionFocusNode.hasFocus
                        ? Color.fromARGB(255, 24, 85, 142)
                        : Colors.black,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 24, 85, 142)),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _descripcion = value;
                    Habito.habitDescription = _descripcion;
                  });
                },
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
