import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/entity/AuthService.dart';
import 'package:flutter_proyecto_final/services/habitos_services.dart';
import 'habitos_stepper.dart';
import 'package:flutter_proyecto_final/entity/Habito.dart';

class PantallaSeguimientoHabitos extends StatefulWidget {
  @override
  _PantallaSeguimientoHabitosState createState() =>
      _PantallaSeguimientoHabitosState();
}

class _PantallaSeguimientoHabitosState
    extends State<PantallaSeguimientoHabitos> {
  List<Map<String, dynamic>> habitData = [];

  @override
  void initState() {
    super.initState();
    // Llenar la lista de hábitos al iniciar la pantalla
    _loadHabits();
    print(habitData);
  }

  // Método para cargar los hábitos del usuario actual
  void _loadHabits() async {
    final String? currentUserId = AuthService.getUserId();
    try {
      habitData = await HabitosService().obtenerHabitos(currentUserId!);

      if (habitData.isEmpty) {
        print('No se encontraron hábitos para el usuario actual.');
      } else {
        print('Se encontraron hábitos para el usuario actual.');
        print(habitData);
      }

      setState(() {});
    } catch (e) {
      print('Error al cargar los hábitos: $e');
    }
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
            preferredSize: Size.fromHeight(48.0), // Altura del TabBar
            child: Container(
              margin: EdgeInsets.only(
                  bottom: 8.0), // Ajusta el margen inferior según sea necesario
              child: TabBar(
                tabs: [
                  Tab(text: 'HOY'),
                  Tab(text: 'HÁBITOS'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildHoyTab(),
            _buildHabitosTab(),
          ],
        ),
        floatingActionButton: Container(
          margin: EdgeInsets.only(bottom: 60.0),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HabitosPageView(),
                ),
              );
            },
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  Widget _buildHoyTab() {
    return Column(
      children: [
        Expanded(
          child: habitData.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No hay nada agendado',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Intenta agregar nuevas actividades.',
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: habitData.length,
                  itemBuilder: (context, index) {
                    final habit = habitData[index];
                    return ListTile(
                      title: Text(habit['nombreHabito']),
                      subtitle: Text(habit['descripcionHabito'] ?? ''),
                      trailing: Checkbox(
                        value: habit['completado'],
                        onChanged: (value) {
                          setState(() {
                            // Actualizar el estado del checkbox
                            habitData[index]['completado'] = value;
                            // Actualizar la base de datos con el cambio de estado
                            // Aquí deberías llamar a un método para actualizar el hábito en la base de datos
                          });
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildHabitosTab() {
    return Column(
      children: [
        Expanded(
          child: habitData.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No hay hábitos activos',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Siempre es un buen día para empezar.',
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: habitData.length,
                  itemBuilder: (context, index) {
                    final habit = habitData[index];
                    return ListTile(
                      title: Text(habit['nombreHabito']),
                      subtitle: Text(habit['descripcionHabito'] ?? ''),
                      trailing: Checkbox(
                        value: habit['completado'],
                        onChanged: (value) {
                          setState(() {
                            // Actualizar el estado del checkbox
                            habitData[index]['completado'] = value;
                            // Actualizar la base de datos con el cambio de estado
                            // Aquí deberías llamar a un método para actualizar el hábito en la base de datos
                          });
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
