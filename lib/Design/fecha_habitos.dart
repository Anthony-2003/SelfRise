import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FechaHabitosScreen extends StatefulWidget {
  @override
  _FechaHabitosScreenState createState() => _FechaHabitosScreenState();
}

class _FechaHabitosScreenState extends State<FechaHabitosScreen> {
  late DateTime _fechaInicio = DateTime.now();
  late DateTime _fechaFinalizacion = DateTime.now();
  bool _fechaFinalizacionToggle = false;
  int _diasFinalizacion = 0;
  List<String> _recordatorios = [];
  TimeOfDay? _horaSeleccionada;
  late AlertDialog? _currentAlertDialog;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();

    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: onSelectNotification,
    );

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> onSelectNotification(
      int id, String? title, String? body, String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Center(
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
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
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: _buildFechaInicioTile(context),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: _buildFechaFinalizacionTile(),
          ),
          SizedBox(height: _fechaFinalizacionToggle ? 10 : 0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: _fechaFinalizacionToggle ? _buildDiasInput() : SizedBox(),
          ),
          SizedBox(height: _fechaFinalizacionToggle ? 10 : 0),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0),
            child: _buildRecordatoriosTile(),
          ),
          SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _recordatorios
                .map(
                  (recordatorio) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      recordatorio,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFechaInicioTile(BuildContext context) {
    return GestureDetector(
      onTap: () => _seleccionarFecha(context, true),
      child: Container(
        child: Row(
          children: [
            Icon(Icons.date_range),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Fecha de inicio',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _fechaInicio.year == DateTime.now().year &&
                        _fechaInicio.month == DateTime.now().month &&
                        _fechaInicio.day == DateTime.now().day
                    ? 'Hoy'
                    : _formattedDate(_fechaInicio),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFechaFinalizacionTile() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _fechaFinalizacionToggle = !_fechaFinalizacionToggle;
        });
      },
      child: Container(
        margin: EdgeInsets.only(top: 10),
        child: Row(
          children: [
            Icon(Icons.date_range),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Fecha de finalización',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            Switch(
              value: _fechaFinalizacionToggle,
              onChanged: (value) {
                setState(() {
                  _fechaFinalizacionToggle = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiasInput() {
    // Calcula la fecha de finalización basada en la fecha de inicio y los días ingresados
    DateTime fechaFinal = _fechaInicio.add(Duration(days: _diasFinalizacion));

    // Actualiza la fecha de finalización en el estado del widget
    _fechaFinalizacion = fechaFinal;

    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildFechaFinalizacionSpan(), // Muestra la fecha final actualizada
          SizedBox(width: 10), // Agrega un espacio entre los widgets
          Container(
            width: 80, // Establece el ancho deseado aquí
            child: TextFormField(
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              onChanged: (value) {
                setState(() {
                  _diasFinalizacion = int.tryParse(value) ?? 0;
                  // Recalcula la fecha final basada en la nueva cantidad de días
                  fechaFinal =
                      _fechaInicio.add(Duration(days: _diasFinalizacion));
                  // Actualiza la fecha de finalización en el estado del widget
                  _fechaFinalizacion = fechaFinal;
                });
              },
            ),
          ),
          SizedBox(width: 10),
          Text('días'),
        ],
      ),
    );
  }

  Widget _buildFechaFinalizacionSpan() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      margin: EdgeInsets.only(top: 10),
      constraints: BoxConstraints(maxWidth: 100),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        _formattedDate(_fechaFinalizacion),
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildRecordatoriosTile() {
    return Container(
      padding: EdgeInsets.all(0),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        onTap: () => _mostrarDialogoRecordatorios(context),
        leading: Icon(Icons.alarm),
        title: Text('Recordatorios'),
      ),
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

  void _mostrarDialogoRecordatorios(BuildContext context) {
    String titulo = '';
    String hora = '';
    String tipoRecordatorio = 'No recordarme';
    String horarioRecordatorio = 'Siempre disponible';
    String? diaElegido;

    showDialog(
      context: context,
      builder: (BuildContext scaffoldContext) {
        return AlertDialog(
          title: Center(child: Text('Recordatorios')),
          content: Container(
            constraints:
                BoxConstraints(maxWidth: 400), // Ancho máximo del contenedor
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  child: Divider(),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/imagenes/notification.png',
                      width: 120,
                      height: 120,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'No hay recordatorios en esta actividad',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(height: 10),
                Divider(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(scaffoldContext); // Cierra el diálogo actual
                    _mostrarDialogoNuevoRecordatorio(context);
                  },
                  child: Text('Nuevo recordatorio'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue, // Cambia el color del texto
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                Divider(),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(scaffoldContext).pop();
                  },
                  child: Text('Cerrar'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.grey, // Cambia el color del texto
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _mostrarSelectorHora(BuildContext context) async {
    final TimeOfDay? horaSeleccionada = await showTimePicker(
      context: context,
      initialTime: _horaSeleccionada ?? TimeOfDay.now(),
    );

    if (horaSeleccionada != null) {
      setState(() {
        _horaSeleccionada = horaSeleccionada;
      });

      // Cierra el diálogo actual si existe
      if (_currentAlertDialog != null) {
        Navigator.of(context).pop();
      }

      // Llama a _mostrarDialogoNuevoRecordatorio solo si _horaSeleccionada no es nulo
      if (_horaSeleccionada != null) {
        _mostrarDialogoNuevoRecordatorio(context);
      }
    }
  }

  void _mostrarDialogoNuevoRecordatorio(BuildContext context) {
    // Crea el diálogo y asigna la referencia a _currentAlertDialog
    _currentAlertDialog = AlertDialog(
      title: Text('Nuevo Recordatorio'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(),
          // Sección de la hora y el tipo de recordatorio
          ListTile(
            title: Text(
              _horaSeleccionada != null
                  ? _horaSeleccionada!.format(context)
                  : '12:00 PM',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            subtitle: Text(
              'Tiempo del recordatorio',
              textAlign: TextAlign.center,
            ),
            onTap: () {
              // Mostrar selector de hora al tocar esta sección
              _mostrarSelectorHora(context);
            },
          ),
        ],
      ),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _currentAlertDialog!;
      },
    );
  }
}
