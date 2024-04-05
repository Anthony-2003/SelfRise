import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Colors/colors.dart';
import 'package:flutter_proyecto_final/Design/habitos_stepper.dart';
import 'package:flutter_proyecto_final/components/app_bart.dart';
import 'package:flutter_proyecto_final/services/AuthService.dart';
import 'package:flutter_proyecto_final/services/habitos_services.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:intl/intl.dart';

class PantallaSeguimientoHabitos extends StatefulWidget {
  @override
  _PantallaSeguimientoHabitosState createState() =>
      _PantallaSeguimientoHabitosState();

  void initializeHabitData() {
    _PantallaSeguimientoHabitosState? state =
        _PantallaSeguimientoHabitosState();
    state._initializeHabitData();
  }
}

class _PantallaSeguimientoHabitosState
    extends State<PantallaSeguimientoHabitos> {
  late StreamController<List<Map<String, dynamic>>> _hoyTabStreamController;
  late List<Map<String, dynamic>> _hoyHabitData = [];
  late List<Map<String, dynamic>> _habitosHabitData = [];
  late DateTime _selectedDate = DateTime.now();
  // ignore: unused_field

  @override
  void initState() {
    super.initState();
    _hoyTabStreamController =
        StreamController<List<Map<String, dynamic>>>.broadcast();
    _initializeHabitData();
  }

  @override
  void dispose() {
    _hoyTabStreamController.close();
    super.dispose();
  }

  void _initializeHabitData() async {
    final String? currentUserId = AuthService.getUserId();
    try {
      final habitData = await HabitosService().obtenerHabitos(currentUserId!);
      final now = DateTime.now();
      _hoyHabitData = habitData.where((habit) {
        final startDate = habit['fechaInicio'].toDate();
        final endDate =
            habit['fechaFinal'] != null ? habit['fechaFinal'].toDate() : null;
        if (endDate != null) {
          final endDateDateTime = endDate;
          return now.isAfter(startDate) && now.isBefore(endDateDateTime);
        } else {
          return now.isAfter(startDate);
        }
      }).toList();
      _habitosHabitData = habitData;
      _updateHoyTabData(_hoyHabitData);
    } catch (e) {
      print('Error al cargar los hábitos: $e');
    }
  }

  void _updateHoyTabData(List<Map<String, dynamic>> data) {
    _hoyTabStreamController.add(data);
  }

  List<DateTime> _generateAllDaysOfYear() {
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final endOfYear = DateTime(now.year, 12, 31);

    final List<DateTime> allDaysOfYear = [];
    for (var date = startOfYear;
        date.isBefore(endOfYear);
        date = date.add(Duration(days: 1))) {
      allDaysOfYear.add(date);
    }
    allDaysOfYear.add(endOfYear); // Agregar el último día del año

    return allDaysOfYear;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: CustomAppBar(titleText: 'Rastreador de hábitos'),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: SizedBox(
                height: 100, // Altura ajustable según sea necesario
                child: DatePicker(
                  DateTime.now(),
                  initialSelectedDate: DateTime.now(),
                  activeDates: _generateAllDaysOfYear(),
                  selectionColor: Color(0xFF2773B9),
                  selectedTextColor: Colors.white,
                  locale: 'es',
                  height: 10,
                  onDateChange: (date) {
                    setState(() {
                      _selectedDate = date; // Actualiza la fecha seleccionada
                    });
                  },
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _buildTab(0),
                  _buildTab(1),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: Container(
          margin: EdgeInsets.only(bottom: 60.0),
          child: FloatingActionButton(
            backgroundColor: Color(0xFF2773B9),
            focusColor: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HabitosPageView(
                    onHabitSaved:
                        _initializeHabitData, // Pasa la función de callback
                  ),
                ),
              );
            },
            child: Icon(Icons.add, color: Colors.white),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      ),
    );
  }

  Widget _buildTab(int index) {
    final streamController = _hoyTabStreamController;

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: streamController.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final habits = snapshot.data ?? [];
          final now = DateTime.now();
          final filteredHabits = index == 0
              ? habits.where((habit) {
                  final startDate = habit['fechaInicio'].toDate();
                  final endDate = habit['fechaFinal'] != null
                      ? habit['fechaFinal'].toDate()
                      : null;
                  if (endDate != null) {
                    final endDateDateTime = endDate;
                    return now.isAfter(startDate) &&
                        now.isBefore(endDateDateTime);
                  } else {
                    return now.isAfter(startDate);
                  }
                }).toList()
              : habits;

          return Column(
            children: [
              Expanded(
                child: filteredHabits.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              index == 0
                                  ? 'No hay nada agendado'
                                  : 'No hay hábitos activos',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(
                              index == 0
                                  ? 'Intenta agregar nuevas actividades.'
                                  : 'Siempre es un buen día para empezar.',
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: SizedBox(
                          height: 200,
                          child: ListView.builder(
                            itemCount: filteredHabits.length,
                            itemBuilder: (context, index) {
                              final habit = filteredHabits[index];
                              Color originalColor = Color(habit['color']);

                              // Reducir los componentes RGB del color original
                              int red = (originalColor.red * 0.8).round();
                              int green = (originalColor.green * 0.8).round();
                              int blue = (originalColor.blue * 0.8).round();

                              // Crear un nuevo color con los componentes RGB reducidos
                              Color darkerColor =
                                  Color.fromRGBO(red, green, blue, 1.0);

                              return Column(
                                children: [
                                  SizedBox(width: 18),
                                  ListTile(
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.all(8.0),
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
                                            SizedBox(width: 8),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  habit['nombreHabito'],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Column(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: darkerColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                      padding:
                                                          EdgeInsets.all(5.0),
                                                      child: Text(
                                                        habit['categoria'],
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    trailing: Transform.scale(
                                      scale: 1.5,
                                      child: Checkbox(
                                        visualDensity: VisualDensity
                                            .adaptivePlatformDensity,
                                        shape: CircleBorder(),
                                        fillColor: MaterialStateProperty
                                            .resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                            if (states.contains(
                                                MaterialState.selected)) {
                                              return Color(0xFF2773B9);
                                            }
                                            return Colors.transparent;
                                          },
                                        ),
                                        value: habit['completado'],
                                        onChanged: (value) async {
                                          if (habit['evaluarProgreso'] ==
                                              'valor numerico') {
                                            // Si el hábito requiere evaluar progreso con valor numérico
                                            if (value!) {
                                              // Si el checkbox se marca
                                              int count =
                                                  habit['metaUsuario'] ?? 0;
                                              // Mostrar el diálogo para ajustar la meta completada
                                              await showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    backgroundColor:
                                                        AppColors.drawer,
                                                    title: Container(
                                                      // Color de fondo de la fila
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              habit[
                                                                  'nombreHabito'],
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            padding: EdgeInsets.all(
                                                                8.0), // Ajusta el padding según sea necesario
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                  habit[
                                                                      'color']),
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            child: Icon(
                                                              IconData(
                                                                habit[
                                                                    'iconoCategoria'],
                                                                fontFamily:
                                                                    'MaterialIcons',
                                                              ),
                                                              size: 24,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    content: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets.all(
                                                              8.0), // Ajusta el padding según sea necesario
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                darkerColor, // Color de fondo del contenedor
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0), // Esquinas redondeadas
                                                          ),
                                                          child: Container(
                                                            // Margen superior de 8.0
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0), // Esquinas redondeadas
                                                            ),
                                                            child: Text(
                                                              DateFormat(
                                                                      'MM/dd/yy')
                                                                  .format(habit[
                                                                          'fechaInicio']
                                                                      .toDate()),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white, // Color del texto
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 8),
                                                        Text('Today'),
                                                        Text(
                                                          '${habit['metaUsuario']}/${habit['meta']}',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        StatefulBuilder(
                                                          builder: (BuildContext
                                                                  context,
                                                              StateSetter
                                                                  setState) {
                                                            return Row(
                                                              children: [
                                                                IconButton(
                                                                  icon: Icon(Icons
                                                                      .remove),
                                                                  onPressed:
                                                                      () async {
                                                                    if (count >
                                                                        0) {
                                                                      try {
                                                                        // Actualizar la metaUsuario del hábito
                                                                        await HabitosService().actualizarMetaUsuario(
                                                                            habit['id'],
                                                                            count);
                                                                        // Actualizar el estado de manera síncrona después de que se haya completado la actualización
                                                                        setState(
                                                                            () {
                                                                          count--;
                                                                        });
                                                                      } catch (e) {
                                                                        print(
                                                                            'Error al actualizar la metaUsuario del hábito: $e');
                                                                        // Manejar el error si es necesario
                                                                      }
                                                                    }
                                                                  },
                                                                ),
                                                                Text(
                                                                  '$count',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          24.0),
                                                                ),
                                                                IconButton(
                                                                  icon: Icon(
                                                                      Icons
                                                                          .add),
                                                                  onPressed:
                                                                      () async {
                                                                    try {
                                                                      // Actualizar la metaUsuario del hábito
                                                                      await HabitosService().actualizarMetaUsuario(
                                                                          habit[
                                                                              'id'],
                                                                          count +
                                                                              1);
                                                                      // Actualizar el estado de manera síncrona después de que se haya completado la actualización
                                                                      setState(
                                                                          () {
                                                                        count++;
                                                                      });
                                                                    } catch (e) {
                                                                      print(
                                                                          'Error al actualizar la metaUsuario del hábito: $e');
                                                                      // Manejar el error si es necesario
                                                                    }
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child: Text('Cancelar'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          setState(() {
                                                            habit['metaUsuario'] =
                                                                count;
                                                          });
                                                          if (habit[
                                                                  'metaUsuario'] >=
                                                              habit['meta']) {
                                                            habit['completado'] =
                                                                true;
                                                          }
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text('Aceptar'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            } else {
                                              // Si el checkbox se desmarca, resetear la metaUsuario a 0
                                              setState(() {
                                                habit['metaUsuario'] = 0;
                                                habit['completado'] = false;
                                              });
                                            }
                                          } else {
                                            // Si el hábito requiere evaluar progreso con sí o no
                                            setState(() {
                                              habit['completado'] = value!;
                                            });
                                          }
                                          // Llamar al método para actualizar el estado del hábito en la base de datos
                                          try {
                                            await HabitosService()
                                                .actualizarEstadoHabito(
                                                    habit['id'], value!);
                                            // Mostrar un mensaje o realizar alguna acción adicional si es necesario
                                          } catch (e) {
                                            print(
                                                'Error al actualizar el estado del hábito: $e');
                                            // Revertir el cambio si hay un error
                                            setState(() {
                                              habit['completado'] = !value!;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    height: 1,
                                    color: Colors.grey,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
              ),
              SizedBox(height: 120.0),
            ],
          );
        }
      },
    );
  }
}
