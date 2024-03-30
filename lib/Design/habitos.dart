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
          child: habits.isEmpty
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
                  itemCount: habits.length,
                  itemBuilder: (context, index) {
                    final habit = habits[index];
                    return ListTile(
                      title: Text(Habito.habitName),
                      subtitle: Text(Habito.habitDescription ?? ''),
                      trailing: Checkbox(
                        value: Habito.isTracked,
                        onChanged: (value) {
                          setState(() {
                            Habito.isTracked = value ?? false;
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
          child: habits.isEmpty
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
                      title: Text(Habito.habitName),
                      subtitle: Text(Habito.habitDescription ?? ''),
                      trailing: Checkbox(
                        value: Habito.isTracked,
                        onChanged: (value) {
                          setState(() {
                            Habito.isTracked = value ?? false;
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
