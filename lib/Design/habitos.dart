import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Design/seleccionar_categoria.dart';
import 'package:flutter_proyecto_final/entity/Habito.dart';

class PantallaSeguimientoHabitos extends StatefulWidget {
  @override
  _PantallaSeguimientoHabitosState createState() =>
      _PantallaSeguimientoHabitosState();
}

class _PantallaSeguimientoHabitosState
    extends State<PantallaSeguimientoHabitos> {
  List<Habito> habits = []; // Lista para almacenar hábitos

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Rastreador de Hábitos'),
      ),
      body: _buildHabitsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SeleccionarCategoriaPantalla()),
          );
        },
        child: Icon(Icons.add),
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

  void _addNewHabit() async {
    final newHabit = await showDialog<Habito>(
      context: context,
      builder: (context) => AddHabitDialog(),
    );

    if (newHabit != null) {
      setState(() {
        habits.add(newHabit);
      });
    }
  }
}

// Paso 4: Diálogo para agregar un nuevo hábito
class AddHabitDialog extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Agregar Nuevo Hábito'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Nombre del hábito'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'Descripción del hábito'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            final newHabit = Habito(
              name: _nameController.text,
              description: _descriptionController.text,
              frequency:
                  'Daily', // Definir la frecuencia predeterminada o agregar lógica para configurarla
              isTracked: false,
            );
            Navigator.pop(context, newHabit);
          },
          child: Text('Guardar'),
        ),
      ],
    );
  }
}
