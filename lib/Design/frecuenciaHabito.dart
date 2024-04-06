import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/entity/Frecuencia.dart';
import 'package:flutter_proyecto_final/entity/Habito.dart';
import 'package:get/get.dart';

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
  void initState() {
    super.initState();
    Habito.frequency = Frecuencia.CADA_DIA;
  
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 40.0), // Ajusta el valor de top según sea necesario
            child: Center(
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  '¿Con qué frecuencia planeas realizar el hábito?',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          _buildPage(),
        ],
      ),
    );
  }

  Widget _buildPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform.scale(
          scale: 1.1, // Factor de escala ajustable según tus necesidades
          child: RadioListTile(
            title: Text(
              'Cada día',
              style: TextStyle(
                fontSize:
                    18.0, // Ajusta el tamaño de fuente según tus necesidades
              ),
            ),
            value: 0,
            groupValue: _currentIndex,
            onChanged: (value) {
              setState(() {
                _currentIndex = value as int;
                Habito.frequency = Frecuencia.CADA_DIA;
              });
            },
          ),
        ),
        Transform.scale(
          scale: 1.1, // Factor de escala ajustable según tus necesidades
          child: RadioListTile(
            title: Text(
              'Días específicos de la semana',
              style: TextStyle(
                fontSize:
                    18.0, // Ajusta el tamaño de fuente según tus necesidades
              ),
            ),
            value: 1,
            groupValue: _currentIndex,
            onChanged: (value) {
              setState(() {
                _currentIndex = value as int;
                Habito.frequency = Frecuencia.DIAS_ESPECIFICOS;
              });
            },
          ),
        ),
        if (_currentIndex == 1) _buildDiasSemanaCheckboxes(),
        Transform.scale(
          scale: 1.1, // Factor de escala ajustable según tus necesidades
          child: RadioListTile(
            title: Text(
              'Días específicos del mes',
              style: TextStyle(
                fontSize:
                    18.0, // Ajusta el tamaño de fuente según tus necesidades
              ),
            ),
            value: 2,
            groupValue: _currentIndex,
            onChanged: (value) {
              setState(() {
                _currentIndex = value as int;
                Habito.frequency = Frecuencia.DIAS_MES;
                print(Habito.frequency.nombre);
              });
            },
          ),
        ),
        if (_currentIndex == 2) _buildDiasMesCheckboxes(),
        Transform.scale(
          scale: 1.1, // Factor de escala ajustable según tus necesidades
          child: RadioListTile(
            title: Text(
              'Repetir',
              style: TextStyle(
                fontSize:
                    18.0, // Ajusta el tamaño de fuente según tus necesidades
              ),
            ),
            value: 3,
            groupValue: _currentIndex,
            onChanged: (value) {
              setState(() {
                _currentIndex = value as int;
                Habito.frequency = Frecuencia.REPETIR;
              });
            },
          ),
        ),
        if (_currentIndex == 3) _buildRepetirTextBox(),
      ],
    );
  }

  Widget _buildDiasSemanaCheckboxes() {
    List<Widget> checkboxes = _diasSeleccionados.keys.map((dia) {
      return GestureDetector(
        onTap: () {
          setState(() {
            _diasSeleccionados[dia] = !_diasSeleccionados[dia]!;
            Frecuencia.actualizarDiasSemana(_diasSeleccionados.keys
                .where((dia) => _diasSeleccionados[dia]!)
                .toSet());
          });
        },
        child: Container(
          child: Row(
            children: [
              Checkbox(
                value: _diasSeleccionados[dia],
                onChanged: (value) {
                  setState(() {
                    _diasSeleccionados[dia] = value!;
                  });
                },
              ),
              Text(
                dia,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 2.5, // Ajusta este valor según el alto que desees
      children: checkboxes,
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
                    Habito.frequency = Frecuencia.DIAS_MES;
                    Frecuencia.actualizarDiasMes(_isSelected.keys
                        .toList()
                        .where((day) => _isSelected[day]!)
                        .toList()
                        .cast<int>()
                        .toSet());
                    print(Frecuencia.diasMes);
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

    _controller.addListener(() {
      Frecuencia.actualizarDiasDespues(_controller.text);
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Repetir cada',
            style: TextStyle(
                fontSize:
                    18), // Tamaño de fuente ajustable según tus necesidades
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
