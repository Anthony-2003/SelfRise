import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Colors/colors.dart';
import 'package:flutter_proyecto_final/Design/habitos_stepper.dart';
import 'package:flutter_proyecto_final/components/app_bart.dart';
import 'package:flutter_proyecto_final/dialogs/ingresar_meta_dialog.dart';
import 'package:flutter_proyecto_final/services/AuthService.dart';
import 'package:flutter_proyecto_final/services/habitos_services.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:intl/intl.dart';

class PantallaSeguimientoHabitos extends StatefulWidget {
  @override
  _PantallaSeguimientoHabitosState createState() =>
      _PantallaSeguimientoHabitosState();
}

class _PantallaSeguimientoHabitosState
    extends State<PantallaSeguimientoHabitos> {
  late StreamController<List<Map<String, dynamic>>> _streamControllerHabitos;
  late DateTime _fechaSeleccionadCalendario = DateTime.now();
  bool elHabitoEstaCompletado = false;

  final String? idUsuarioActual = AuthService.getUserId();
  // ignore: unused_field

  @override
  void initState() {
    super.initState();
    _streamControllerHabitos =
        StreamController<List<Map<String, dynamic>>>.broadcast();
    _inicializarDatos();
  }

  void _inicializarDatos() async {
    try {
      final habitData = await HabitosService().obtenerHabitos(idUsuarioActual!);
      _streamControllerHabitos.add(habitData);
      print(habitData);
    } catch (error) {
      print("Error al cargar hábitos: $error");
    }
  }

  @override
  void dispose() {
    _streamControllerHabitos.close();
    super.dispose();
  }

  Widget construirCalendario(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 100,
          width: double.infinity, // Ancho máximo disponible
          child: DatePicker(
            DateTime.now(),
            initialSelectedDate: DateTime.now(),
            selectionColor: Color(0xFF2773B9),
            selectedTextColor: Colors.white,
            height: 100,
            locale: 'es',
            onDateChange: (date) {
              // New date selected
              setState(() {
                _fechaSeleccionadCalendario = date;
              });
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: CustomAppBar(titleText: 'Rastreador de hábitos'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: SizedBox(height: 100, child: construirCalendario(context)),
          ),
          _construirHabitoStream()
        ],
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 60.0),
        child: _construirBotonFlotante(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Widget _construirBotonFlotante() {
    return FloatingActionButton(
      backgroundColor: Color(0xFF2773B9),
      focusColor: Colors.white,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HabitosPageView(
              manejarHabitoGuardado: _inicializarDatos,
            ), // No se pasa ningún parámetro opcional
          ),
        );
      },
      child: Icon(Icons.add, color: Colors.white),
    );
  }

  Widget _construirHabitoStream() {
    return Expanded(
      child: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _streamControllerHabitos?.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _construirListaHabitos(snapshot.data!);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _construirListaHabitos(List<Map<String, dynamic>> habitData) {
    if (habitData.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.only(bottom: 180),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No hay hábitos agendados',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '¡Es un buen día para empezar!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Padding(
        padding:
            EdgeInsets.only(bottom: 120), // Agregar margen en la parte inferior
        child: ListView.builder(
          itemCount: habitData.length,
          itemBuilder: (BuildContext context, int index) {
            final habit = habitData[index];
            return Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 8), // Ajustar el espacio vertical entre elementos
              child: _construirHabito(habit),
            );
          },
        ),
      );
    }
  }

  Widget _construirHabito(Map<String, dynamic> habito) {
    Color color = Color(habito['color']);
    Color colorAjustado = ajustarBrilloColor(color);

    return GestureDetector(
      onTap: () => _manejarClicEnHabito(habito),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 1, horizontal: 20),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _construirContenedorIcono(habito),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _construirNombreHabito(habito),
                  SizedBox(height: 4),
                  _construirContenedorCategoria(habito, colorAjustado),
                ],
              ),
            ),
            SizedBox(width: 8),
            FutureBuilder<Widget>(
              future: _construirCheckbox(habito),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Puedes mostrar un indicador de carga mientras esperas
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return snapshot.data!;
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirContenedorIcono(Map<String, dynamic> habito) {
    Color colorIcono = Colors.black;
    IconData iconoDatos = IconData(
      habito['iconoCategoria'],
      fontFamily: 'MaterialIcons',
    );

    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Color(habito['color']),
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconoDatos,
        size: 24,
        color: colorIcono,
      ),
    );
  }

  Widget _construirNombreHabito(Map<String, dynamic> habito) {
    String nombreHabito = habito['nombreHabito'] ?? '';
    return Text(
      nombreHabito,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }

  Widget _construirContenedorCategoria(
      Map<String, dynamic> habito, Color color) {
    String categoria = habito['categoria'] ?? '';
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.all(5.0),
      child: Text(
        categoria,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<Widget> _construirCheckbox(Map<String, dynamic> habito) async {
    int verificarValor = await HabitosService()
        .obtenerHabitoPorDefault(habito['id'], DateTime.now());
        print(verificarValor);
    bool elHabitoEstaCompletado = (verificarValor >
        0); // Aquí establece la lógica para determinar si el hábito está completado o no

    return Transform.scale(
      scale: 1.5,
      child: Checkbox(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        shape: CircleBorder(),
        fillColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> estados) {
            if (estados.contains(MaterialState.selected)) {
              return Color(0xFF2773B9);
            }
            return Colors.transparent;
          },
        ),
        value: elHabitoEstaCompletado,
        onChanged: (bool? value) {
          // Aquí puedes agregar la lógica para manejar el cambio de estado del checkbox si es necesario
        },
      ),
    );
  }

  void _manejarClicEnHabito(Map<String, dynamic> habito) {
    print('Hábito seleccionado: ${habito['nombreHabito']}');

    if (habito['evaluarProgreso'] == 'valor numerico') {
      _mostrarDialogo(context, habito);
    }
  }

  void _mostrarDialogo(BuildContext context, Map<String, dynamic> habito) {
    showDialog(
      context: context,
      builder: (context) {
        // Crear una instancia de IngresarMetaDialog y pasarle el mapa habito
        return IngresarMetaDialog(habit: habito);
      },
    );
  }

  Color ajustarBrilloColor(Color color) {
    int rojo = (color.red * 0.8).round();
    int verde = (color.green * 0.8).round();
    int azul = (color.blue * 0.8).round();
    return Color.fromRGBO(rojo, verde, azul, 1);
  }
}
