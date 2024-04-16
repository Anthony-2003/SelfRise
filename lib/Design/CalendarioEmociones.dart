import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarioEmociones extends StatefulWidget {
  @override
  _CalendarioEmocionesState createState() => _CalendarioEmocionesState();
}

class _CalendarioEmocionesState extends State<CalendarioEmociones> {
  late Map<DateTime, List<dynamic>> _events;
  late List<dynamic> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _events = {};
    _selectedEvents = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendario de Emociones'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Emociones').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No hay datos disponibles'),
            );
          }
          _events = _convertirDocumentosAEventos(snapshot.data!.docs);
          return Column(
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                eventLoader: _cargarEventos,
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedEvents = _events[selectedDay] ?? [];
                  });
                },
              ),
              Expanded(
                child: _buildEventList(),
              ),
            ],
          );
        },
      ),
    );
  }

  Map<DateTime, List<dynamic>> _convertirDocumentosAEventos(List<DocumentSnapshot> documentos) {
    Map<DateTime, List<dynamic>> eventos = {};
    for (var documento in documentos) {
      final data = documento.data() as Map<String, dynamic>;
      final fecha = data['Fecha'] as Timestamp;
      final fechaDateTime = fecha.toDate();
      eventos[fechaDateTime] = [data['Estado de animo'] ?? ''];
    }
    return eventos;
  }

  List<dynamic> _cargarEventos(DateTime day) {
    return _events[day] ?? [];
  }

  Widget _buildEventList() {
    return ListView.builder(
      itemCount: _selectedEvents.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_selectedEvents[index]),
          // You can add more information here from the event if needed
        );
      },
    );
  }
}
