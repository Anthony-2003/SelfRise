  import 'package:flutter/material.dart';

  class FrecuenciaScreen extends StatefulWidget {
    final bool repetir;

    FrecuenciaScreen({this.repetir = false});

    @override
    _FrecuenciaScreenState createState() => _FrecuenciaScreenState();
  }

  class _FrecuenciaScreenState extends State<FrecuenciaScreen> {
    Map<String, bool> _diasSeleccionados = {
      'Lunes': false,
      'Martes': false,
      'Miércoles': false,
      'Jueves': false,
      'Viernes': false,
      'Sábado': false,
      'Domingo': false,
    };
    int _currentIndex = 0;

    // Definir _isSelected fuera del método build
    Map<int, bool> _isSelected = {};

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: _buildPage(),
      );
    }

    Widget _buildPage() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RadioListTile(
            title: Text('Cada día'),
            value: 0,
            groupValue: _currentIndex,
            onChanged: (value) {
              setState(() {
                _currentIndex = value as int;
              });
            },
          ),
          RadioListTile(
            title: Text('Días específicos de la semana'),
            value: 1,
            groupValue: _currentIndex,
            onChanged: (value) {
              setState(() {
                _currentIndex = value as int;
              });
            },
          ),
          if (_currentIndex == 1) _buildDiasSemanaCheckboxes(),
          RadioListTile(
            title: Text('Días específicos del mes'),
            value: 2,
            groupValue: _currentIndex,
            onChanged: (value) {
              setState(() {
                _currentIndex = value as int;
              });
            },
          ),
          if (_currentIndex == 2) _buildDiasMesCheckboxes(),
          RadioListTile(
            title: Text('Repetir'),
            value: 3,
            groupValue: _currentIndex,
            onChanged: (value) {
              setState(() {
                _currentIndex = value as int;
              });
            },
          ),
          if (_currentIndex == 3) _buildRepetirTextBox(),
        ],
      );
    }

    Widget _buildDiasSemanaCheckboxes() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.start,
            spacing: 10.0,
            runSpacing: 10.0,
            children: _diasSeleccionados.keys.map((dia) {
              return CheckboxListTile(
                title: Text(dia),
                value: _diasSeleccionados[dia],
                onChanged: (value) {
                  setState(() {
                    _diasSeleccionados[dia] = value!;
                  });
                },
              );
            }).toList(),
          ),
        ],
      );
    }

    Widget _buildDiasMesCheckboxes() {
      final DateTime now = DateTime.now();
      final int daysInMonth = DateTime(now.year, now.month + 1, 0).day;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 1.0,
              ),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: daysInMonth,
              itemBuilder: (context, index) {
                final int day = index + 1;

                _isSelected.putIfAbsent(day, () => false);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _isSelected.update(day, (isSelected) => !isSelected);
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isSelected[day]!
                          ? Colors.lightBlueAccent
                          : Colors.transparent,
                    ),
                    child: Center(
                      child: Text(
                        '$day',
                        style: TextStyle(
                          fontSize: 15,
                          color: _isSelected[day]! ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    }

    Widget _buildRepetirTextBox() {
      TextEditingController _controller = TextEditingController();

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
            'Repetir cada',
            style: TextStyle(fontSize: 18), // Tamaño de fuente ajustable según tus necesidades
          ),
            SizedBox(width: 5), // Espacio entre el texto y el TextField
            SizedBox(
              width: 100, //  Ancho ajustable según tus necesidades
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: '',
                ),
              ),
            ),
            SizedBox(width: 5), // Espacio entre el TextField y el texto
            Text('día(s)', style: TextStyle(fontSize: 18)),
          ],
        ),
      );
    }
  }

