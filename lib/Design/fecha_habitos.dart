import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;

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
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.notifications),
              SizedBox(width: 10),
              Text('Recordatorio'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Título'),
                  onChanged: (value) {
                    titulo = value;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Hora (HH:mm)'),
                  onChanged: (value) {
                    hora = value;
                  },
                ),
                SizedBox(height: 10),
                DropdownButton<String>(
                  value: tipoRecordatorio,
                  onChanged: (String? value) {
                    setState(() {
                      tipoRecordatorio = value!;
                    });
                  },
                  items: <String>['No recordarme', 'Notificación', 'Alarma']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 10),
                Text('Horario del recordatorio:'),
                Column(
                  children: [
                    RadioListTile<String>(
                      title: Text('Siempre disponible'),
                      value: 'Siempre disponible',
                      groupValue: horarioRecordatorio,
                      onChanged: (value) {
                        setState(() {
                          horarioRecordatorio = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Text('Días específicos de la semana'),
                      value: 'Días específicos de la semana',
                      groupValue: horarioRecordatorio,
                      onChanged: (value) {
                        setState(() {
                          horarioRecordatorio = value!;
                        });
                      },
                    ),
                    if (horarioRecordatorio == 'Días específicos de la semana')
                      Row(
                        children: [
                          for (String dia in [
                            'Lun',
                            'Mar',
                            'Mié',
                            'Jue',
                            'Vie',
                            'Sáb',
                            'Dom'
                          ])
                            Expanded(
                              child: CheckboxListTile(
                                title: Text(dia),
                                value: diaElegido == dia,
                                onChanged: (value) {
                                  setState(() {
                                    if (value!)
                                      diaElegido = dia;
                                    else if (diaElegido == dia)
                                      diaElegido = null;
                                  });
                                },
                              ),
                            ),
                        ],
                      ),
                    RadioListTile<String>(
                      title: Text('Días después de hoy'),
                      value: 'Días después de hoy',
                      groupValue: horarioRecordatorio,
                      onChanged: (value) {
                        setState(() {
                          horarioRecordatorio = value!;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                // Crear la zona horaria local
                String? timeZoneName;
                try {
                  timeZoneName = await FlutterTimezone.getLocalTimezone();
                } catch (e) {
                  debugPrint('Error obteniendo zona horaria: $e');
                }

                // Convertir la hora ingresada a DateTime
                DateTime? recordatorioDateTime;
                try {
                  recordatorioDateTime = DateTime.parse(
                      DateTime.now().toIso8601String().substring(0, 11) +
                          hora +
                          ':00');
                } catch (e) {
                  debugPrint('Error parsing hora: $e');
                }

                // Configurar la notificación o alarma
                if (recordatorioDateTime != null && timeZoneName != null) {
                  var androidPlatformChannelSpecifics =
                      AndroidNotificationDetails(
                    'recordatorio_channel',
                    'Recordatorio',
                    channelDescription:
                        'Canal para recordatorios de habitNow', // Argumento con nombre
                    icon:
                        'app_icon', // Especifica el nombre correcto del icono aquí
                    largeIcon: DrawableResourceAndroidBitmap('app_icon'),
                  );

                  var iOSPlatformChannelSpecifics =
                      DarwinNotificationDetails(); // Usar DarwinNotificationDetails en lugar de DarwinInitializationSettings
                  var platformChannelSpecifics = NotificationDetails(
                    android: androidPlatformChannelSpecifics,
                    iOS: iOSPlatformChannelSpecifics,
                  );

                  // Programar la notificación o alarma
                  await flutterLocalNotificationsPlugin.zonedSchedule(
                    0,
                    titulo,
                    '',
                    tz.TZDateTime.from(
                      recordatorioDateTime,
                      tz.getLocation(timeZoneName),
                    ),
                    platformChannelSpecifics,
                    // ignore: deprecated_member_use
                    androidAllowWhileIdle: true,
                    uiLocalNotificationDateInterpretation:
                        UILocalNotificationDateInterpretation.absoluteTime,
                    matchDateTimeComponents: DateTimeComponents.time,
                  );

                  // Agregar el recordatorio a la lista
                  setState(() {
                    _recordatorios.add('$titulo - $hora - $tipoRecordatorio');
                  });

                  Navigator.of(context).pop();
                }
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}
