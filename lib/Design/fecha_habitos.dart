import 'package:flutter/material.dart';

class FechaHabitosScreen extends StatefulWidget {
  @override
  _FechaHabitosScreenState createState() => _FechaHabitosScreenState();
}

class _FechaHabitosScreenState extends State<FechaHabitosScreen> {
  late DateTime _fechaInicio = DateTime.now();
  late DateTime _fechaFinalizacion =
      DateTime.now().add(Duration(days: 7)); // Fecha de hoy + 7 días
  bool _fechaFinalizacionToggle = false;
  int _diasFinalizacion = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Center(
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  '¿Cuando quieres hacerlo?',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: _buildFechaInicioTile(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: _buildFechaFinalizacionTile(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: _buildRecordatoriosTile(),
          ),
        ],
      ),
    );
  }

  Widget _buildFechaInicioTile() {
    return ListTile(
      leading: Icon(Icons.date_range),
      title: Text('Fecha de inicio'),
      subtitle: Container(
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Text(_formattedDate(_fechaInicio)),
            ),
            SizedBox(width: 10),
          ],
        ),
      ),
      onTap: () => _seleccionarFecha(context, true),
    );
  }

  Widget _buildFechaFinalizacionTile() {
    return ListTile(
      leading: Icon(Icons.date_range),
      title: Text('Fecha de finalización'),
      subtitle: _fechaFinalizacionToggle
          ? Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _diasFinalizacion = int.tryParse(value) ?? 0;
                        _fechaFinalizacion = DateTime.now()
                            .add(Duration(days: _diasFinalizacion));
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Días',
                    ),
                  ),
                ),
              ],
            )
          : Text('Seleccionada: ${_formattedDate(_fechaFinalizacion)}'),
      trailing: Switch(
        value: _fechaFinalizacionToggle,
        onChanged: (value) {
          setState(() {
            _fechaFinalizacionToggle = value;
            if (_fechaFinalizacionToggle) {
              _diasFinalizacion = 0;
              _fechaFinalizacion =
                  DateTime.now().add(Duration(days: _diasFinalizacion));
            }
          });
        },
      ),
    );
  }

  Widget _buildRecordatoriosTile() {
    return ListTile(
      leading: Icon(Icons.alarm),
      title: Text('Recordatorios'),
    );
  }

  Future<void> _seleccionarFecha(
      BuildContext context, bool isFechaInicio) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isFechaInicio ? _fechaInicio : _fechaFinalizacion,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        if (isFechaInicio) {
          _fechaInicio = pickedDate;
        } else {
          _fechaFinalizacion = pickedDate;
        }
      });
    }
  }

  String _formattedDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
