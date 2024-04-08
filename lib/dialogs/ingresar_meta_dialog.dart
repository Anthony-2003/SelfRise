import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Colors/colors.dart';
import 'package:flutter_proyecto_final/services/habitos_services.dart';
import 'package:intl/intl.dart';

class IngresarMetaDialog extends StatefulWidget {
  final Map<String, dynamic> habit;

  IngresarMetaDialog({required this.habit});
  @override
  _IngresarMetaDialogState createState() => _IngresarMetaDialogState();
}

class _IngresarMetaDialogState extends State<IngresarMetaDialog> {
  late int count; // Variable de estado para almacenar el conteo

  @override
  Widget build(BuildContext context) {
    return _construirContenidoDialogo(widget.habit);
  }

  Color ajustarBrilloColor(Color color) {
    int rojo = (color.red * 0.8).round();
    int verde = (color.green * 0.8).round();
    int azul = (color.blue * 0.8).round();
    return Color.fromRGBO(rojo, verde, azul, 1);
  }

  Widget _construirContenidoDialogo(Map<String, dynamic> habit) {
    Color darkerColor = ajustarBrilloColor(Color(habit['color']));

    return AlertDialog(
      backgroundColor: AppColors.drawer,
      title: _construirTitulo(habit, darkerColor),
      content: _construirContenido(habit),
      actions: _construirAcciones(context, habit),
    );
  }

  Widget _construirTitulo(Map<String, dynamic> habit, Color darkerColor) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                habit['nombreHabito'],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: darkerColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  DateFormat('MM/dd/yy').format(habit['fechaInicio'].toDate()),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Color(habit['color']),
              shape: BoxShape.circle,
            ),
            child: Icon(
              IconData(
                habit['iconoCategoria'],
                fontFamily: 'MaterialIcons',
              ),
              size: 24,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirContenido(Map<String, dynamic> habit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(),
        SizedBox(height: 8),
        _construirContador(habit),
        SizedBox(height: 8),
        Center(
          child: Expanded(
            child: _construirMeta(habit),
          ),
        ),
      ],
    );
  }

  Widget _construirContador(Map<String, dynamic> habit) {
    count = habit['metaUsuario'];
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove, color: Colors.white),
                onPressed: () async {
                  if (count > 0) {
                    try {
                      await HabitosService()
                          .actualizarMetaUsuario(habit['id'], count - 1);
                      setState(() {
                        count--;
                      });
                    } catch (e) {
                      print(
                          'Error al actualizar la metaUsuario del hábito: $e');
                    }
                  }
                },
              ),
              Expanded(
                child: Text(
                  '$count',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24.0, color: Colors.white),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add, color: Colors.white),
                onPressed: () async {
                  try {
                    await HabitosService()
                        .actualizarMetaUsuario(habit['id'], count + 1);
                    setState(() {
                      count++;
                    });
                  } catch (e) {
                    print('Error al actualizar la metaUsuario del hábito: $e');
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _construirMeta(Map<String, dynamic> habit) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Hoy',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${habit['metaUsuario']}/',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          TextSpan(
                            text: '${habit['meta']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _construirAcciones(
      BuildContext context, Map<String, dynamic> habit) {
    return [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF2773B9),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Text(
            'Cancelar',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      SizedBox(width: 20),
      TextButton(
        onPressed: () async {
          DateTime fechaActual = DateTime.now();
          DateTime fechaSinHora =
              DateTime(fechaActual.year, fechaActual.month, fechaActual.day);

          print(fechaSinHora);
          print(habit['id']);

          habit['metaUsuario'] = count;
          if (habit['metaUsuario'] >= habit['meta']) {

            bool elHabitoCompletadoExiste = await HabitosService()
                .verificarHabitoCompletadoExistente(habit['id'], fechaSinHora);


            if (elHabitoCompletadoExiste) {
              String? idDocumentoHabitoCompletado = await HabitosService().obtenerIdDocumentoHabitoCompletado(habit['id'], fechaSinHora);

              await HabitosService()
                  .actualizarValorHabito(idDocumentoHabitoCompletado!, habit['metaUsuario']);
            } else {
              await HabitosService().guardarHabitoCompletado(
                  habit['id'], fechaSinHora, habit['metaUsuario']);
            }
          } else {
            await HabitosService()
                .borrarHabitoCompletado(habit['id'], fechaSinHora);
          }
          Navigator.pop(context);
        },
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF2773B9),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Text(
            'Aceptar',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    ];
  }
}
