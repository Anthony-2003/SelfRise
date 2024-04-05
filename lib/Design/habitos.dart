import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Design/habitos_stepper.dart';
import 'package:flutter_proyecto_final/components/app_bart.dart';
import 'package:flutter_proyecto_final/services/AuthService.dart';
import 'package:flutter_proyecto_final/services/habitos_services.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

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
                          padding: EdgeInsets.symmetric(
                              vertical: 10), // Margen superior de 20 píxeles
                          child: SizedBox(
                            height: 200,
                            child: ListView.builder(
                              itemCount: filteredHabits.length,
                              itemBuilder: (context, index) {
                                final habit = filteredHabits[index];
                                Color originalColor = Color(habit['color']);

// Reducir los componentes RGB del color original
                                int red = (originalColor.red * 0.8)
                                    .round(); // Reducir el componente rojo en un 20%
                                int green = (originalColor.green * 0.8)
                                    .round(); // Reducir el componente verde en un 20%
                                int blue = (originalColor.blue * 0.8)
                                    .round(); // Reducir el componente azul en un 20%

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
                                                margin: EdgeInsets.all(
                                                    8.0), // Ajusta el valor según sea necesario
                                                padding: EdgeInsets.all(
                                                    8.0), // Ajusta el valor según sea necesario
                                                decoration: BoxDecoration(
                                                  color: Color(habit[
                                                      'color']), // Color de fondo del círculo
                                                  shape: BoxShape
                                                      .circle, // Forma del borde (círculo)
                                                ),
                                                child: Icon(
                                                  IconData(
                                                    habit['iconoCategoria'],
                                                    fontFamily: 'MaterialIcons',
                                                  ),
                                                  size: 24,
                                                  color: Colors
                                                      .black, // Color del icono dentro del círculo
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
                                                        // Espacio entre el título y la descripción
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                darkerColor, // Color de fondo del contenedor
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0), // Radio de borde del contenedor
                                                          ),
                                                          padding: EdgeInsets.all(
                                                              5.0), // Espaciado interno del contenedor
                                                          child: Text(
                                                            habit[
                                                                'categoria'],
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .white, // Color del texto dentro del contenedor
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
                                        scale:
                                            1.5, // Factor de escala para aumentar el tamaño del checkbox
                                        child: Checkbox(
                                          visualDensity: VisualDensity
                                              .adaptivePlatformDensity,
                                          shape: CircleBorder(),
                                          fillColor: MaterialStateProperty
                                              .resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                              // Cambia el color de fondo del checkbox cuando está seleccionado
                                              if (states.contains(
                                                  MaterialState.selected)) {
                                                return Color(
                                                    0xFF2773B9); // Color cuando está seleccionado
                                              }
                                              return Colors
                                                  .transparent; // Color por defecto
                                            },
                                          ),
                                          value: habit['completado'],
                                          onChanged: (value) async {
                                            // Actualizar el estado del hábito localmente
                                            setState(() {
                                              habit['completado'] = value;
                                            });

                                            // Llamar al método para actualizar el estado del hábito en la base de datos
                                            try {
                                              await HabitosService()
                                                  .actualizarEstadoHabito(
                                                      habit['id'], value!);
                                              // Mostrar un mensaje o realizar alguna acción adicional si es necesario
                                            } catch (e) {
                                              print(
                                                  'Error al actualizar el estado del hábito: $e');
                                              // Si ocurre un error, puedes revertir el cambio del estado local si es necesario
                                              setState(() {
                                                habit['completado'] = !value!;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      // Agrega una línea debajo de cada ListTile
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
        });
  }
}
