import 'package:flutter/material.dart';
import 'habitos_stepper.dart';
import 'package:flutter_proyecto_final/entity/Habito.dart';

class PantallaSeguimientoHabitos extends StatefulWidget {
  @override
  _PantallaSeguimientoHabitosState createState() =>
      _PantallaSeguimientoHabitosState();
}

class _PantallaSeguimientoHabitosState
    extends State<PantallaSeguimientoHabitos> {
  List<Habito> habits = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildCustomAppBar(), // Mostrar el encabezado personalizado
          Expanded(
            child: _buildHabitsList(), // Contenido principal
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
            bottom: 60.0), // Ajusta los márgenes según sea necesario
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
    );
  }

  Widget _buildCustomAppBar() {
    return Container(
      // Color de fondo del encabezado
      padding: EdgeInsets.only(top: 65.0), // Espaciado interno
      alignment: Alignment.center, // Alineación del contenido al centro
      child: Text(
        'Rastreador de hábitos',
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildHabitsList() {
    return habits.isEmpty
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
            itemCount: habits.length,
            itemBuilder: (context, index) {
              final habit = habits[index];
              return ListTile(
                title: Text(habit.name),
                subtitle: Text(habit.description),
                trailing: Checkbox(
                  value: habit.isTracked,
                  onChanged: (value) {
                    setState(() {
                      habit.isTracked = value ?? false;
                    });
                  },
                ),
              );
            },
          );
  }
}
