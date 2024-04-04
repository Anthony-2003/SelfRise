import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/services/AuthService.dart';
import 'package:flutter_proyecto_final/services/habitos_services.dart';
import 'habitos_stepper.dart';

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
  late StreamController<List<Map<String, dynamic>>> _habitosTabStreamController;
  late List<Map<String, dynamic>> _hoyHabitData = [];
  late List<Map<String, dynamic>> _habitosHabitData = [];
  // ignore: unused_field
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _hoyTabStreamController =
        StreamController<List<Map<String, dynamic>>>.broadcast();
    _habitosTabStreamController =
        StreamController<List<Map<String, dynamic>>>.broadcast();
    _initializeHabitData();
  }

  @override
  void dispose() {
    _hoyTabStreamController.close();
    _habitosTabStreamController.close();
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
      _updateHabitosTabData(_habitosHabitData);
    } catch (e) {
      print('Error al cargar los hábitos: $e');
    }
  }

  void _updateHoyTabData(List<Map<String, dynamic>> data) {
    _hoyTabStreamController.add(data);
  }

  void _updateHabitosTabData(List<Map<String, dynamic>> data) {
    _habitosTabStreamController.add(data);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Rastreador de hábitos', textAlign: TextAlign.center),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(48.0),
            child: Container(
              margin: EdgeInsets.only(bottom: 8.0),
              child: TabBar(
                tabs: [
                  Tab(text: 'HOY'),
                  Tab(text: 'HÁBITOS'),
                ],
                indicatorColor: Color(0xFF2773B9),
                labelColor: Color(0xFF2773B9),
                 
                onTap: (index) {
                  setState(() {
                    _currentTabIndex = index;
                  });
                  // Llama a _initializeHabitData() cuando se cambie de pestaña
                  _initializeHabitData();
                },
              ),
            ),
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            _buildTab(0),
            _buildTab(1),
          ],
        ),
        floatingActionButton: Container(
          margin: EdgeInsets.only(bottom: 70.0),
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
    final streamController =
        index == 0 ? _hoyTabStreamController : _habitosTabStreamController;

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
                          padding: EdgeInsets.only(bottom: 16.0),
                          child: ListView.builder(
                            itemCount: filteredHabits.length,
                            itemBuilder: (context, index) {
                              final habit = filteredHabits[index];
                              return Column(
                                children: [
                                  ListTile(
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              IconData(habit['iconoCategoria'],
                                                  fontFamily: 'MaterialIcons'),
                                              size: 24,
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
                                                if (habit['descripcionHabito'] !=
                                                        null &&
                                                    habit['descripcionHabito']
                                                        .isNotEmpty)
                                                  Column(
                                                    children: [
                                                      SizedBox(
                                                          height:
                                                              8), // Espacio entre el título y la descripción
                                                      Text(
                                                        habit[
                                                            'descripcionHabito'],
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ],
                                                  ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    trailing: Checkbox(
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
                SizedBox(height: 120.0),
              ],
            );
          }
        });
  }
}
