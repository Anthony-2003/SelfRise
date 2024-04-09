import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_proyecto_final/entity/Frecuencia.dart';
import 'package:flutter_proyecto_final/entity/Habito.dart';

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
  TimeOfDay? _horaSeleccionada = TimeOfDay(hour: 12, minute: 0);
  late AlertDialog? _currentAlertDialog;
  bool _notificacionSeleccionada = true;
  bool _alarmaSeleccionada = false;
  int? _calendarioSeleccionado = 1;
  List<String> _diasSemanaSeleccionados = [];
  int? _diasDespuesSeleccionados = 1;

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
    print(Habito.habitName);
    print(Habito.habitDescription);
    print(Habito.frequency?.nombre);

    if (Habito.frequency != null &&
        Habito.frequency!.nombre == 'Días específicos de la semana') {
      print(Frecuencia.diasSemana);
    }

    if (Habito.frequency != null &&
        Habito.frequency!.nombre == 'Días específicos del mes') {
      print(Frecuencia.diasMes);
    }

    if (Habito.frequency != null && Habito.frequency!.nombre == 'Repetir') {
      print(Frecuencia.diasDespues);
    }

    print(Habito.category);
    print(Habito.categoryIcon);

    Habito.startDate = _fechaInicio;

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
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFechaFinalizacionTile(),
                SizedBox(height: _fechaFinalizacionToggle ? 10 : 0),
                if (_fechaFinalizacionToggle) ...[
                  _buildDiasInput(),
                  Divider(),
                ],
              ],
            ),
          ),
          if (!_fechaFinalizacionToggle) Divider(),
          SizedBox(height: _fechaFinalizacionToggle ? 10 : 0),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0),
            child: _buildRecordatoriosTile(),
          ),
          SizedBox(height: 20),
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
                color: Color(0xFF2773B9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _fechaInicio.year == DateTime.now().year &&
                        _fechaInicio.month == DateTime.now().month &&
                        _fechaInicio.day == DateTime.now().day
                    ? 'Hoy'
                    : _formattedDate(_fechaInicio),
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
                  if (_fechaFinalizacionToggle == true) {
                    Habito.endDate == _fechaFinalizacion;
                    print(_fechaFinalizacion);
                  } else {
                    Habito.endDate = null;
                  }
                });
              },
              activeTrackColor: Color(0xFF2773B9),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiasInput() {
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
                  fechaFinal =
                      _fechaInicio.add(Duration(days: _diasFinalizacion));
                  _fechaFinalizacion = fechaFinal;
                  Habito.endDate = _fechaFinalizacion;
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
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      margin: EdgeInsets.only(top: 10),
      constraints: BoxConstraints(maxWidth: 100),
      decoration: BoxDecoration(
        color: Color(0xFF2773B9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        _formattedDate(_fechaFinalizacion),
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget _buildRecordatoriosTile() {
    return InkWell(
      onTap: () => _mostrarDialogoRecordatorios(context),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.alarm),
                SizedBox(width: 10),
                Text('Recordatorios',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF2773B9),
              ),
              padding: EdgeInsets.all(10),
              child: Text(
                '${_recordatorios.length}',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
          ],
        ),
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

  void _eliminarRecordatorio(String recordatorio) {
    setState(() {
      _recordatorios.remove(recordatorio); // Marca el diálogo como cerrado
    });
    _mostrarDialogoRecordatorios(
        context); // Llama a la función para mostrar el diálogo de recordatorios actualizado
  }

  void _mostrarDialogoRecordatorios(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext scaffoldContext) {
        return AlertDialog(
          title: Center(child: Text('Recordatorios')),
          content: Container(
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
                // Aquí se muestran los recordatorios actuales
                if (_recordatorios.isNotEmpty)
                  Column(
                    children: _recordatorios.map((recordatorio) {
                      List<String> parts = recordatorio.split('\n');
                      String tipoRecordatorio = parts[0].split(' - ')[0];
                      String horaRecordatorio = parts[0].split(' - ')[1];
                      String diasRecordatorio =
                          parts.length > 1 ? parts[1] : '';

                      return Container(
                        child: ListTile(
                          contentPadding: EdgeInsets.all(
                              0), // Elimina el padding predeterminado del ListTile
                          leading: tipoRecordatorio == 'Notificación'
                              ? Icon(Icons.notifications)
                              : Icon(Icons.alarm),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      horaRecordatorio,
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          trailing: Container(
                            // Contenedor para el IconButton
                            padding: EdgeInsets
                                .zero, // Elimina el padding del contenedor
                            child: IconButton(
                              padding: EdgeInsets.all(0),
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  Navigator.pop(scaffoldContext);
                                  _eliminarRecordatorio(recordatorio);
                                });
                              },
                            ),
                          ),
                          subtitle: Text(
                            diasRecordatorio,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors
                                  .blue, // Cambia "Colors.blue" al color que desees
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  )
                else
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/imagenes/notification.png',
                        width: 100,
                        height: 120,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'No hay recordatorios en esta actividad',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
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

  void _mostrarSelectorHora(BuildContext context, StateSetter setState) async {
    final TimeOfDay? horaSeleccionada = await showTimePicker(
      context: context,
      initialTime: _horaSeleccionada ?? TimeOfDay.now(),
    );

    if (horaSeleccionada != null) {
      setState(() {
        _horaSeleccionada = horaSeleccionada;
      });
    }
  }

  void _guardarRecordatorio() {
    String tipoRecordatorio =
        _notificacionSeleccionada ? 'Notificación' : 'Alarma';
    String horaRecordatorio = _horaSeleccionada != null
        ? _horaSeleccionada!.format(context)
        : '12:00 PM';
    String opcionesSeleccionadas = '';

    if (_calendarioSeleccionado == 1) {
      opcionesSeleccionadas = 'Siempre disponible';
    } else if (_calendarioSeleccionado == 2) {
      opcionesSeleccionadas = _diasSemanaSeleccionados.join(', ');
    } else if (_calendarioSeleccionado == 3) {
      opcionesSeleccionadas = '$_diasDespuesSeleccionados días después';
    }

    String recordatorio =
        '$tipoRecordatorio - $horaRecordatorio\n$opcionesSeleccionadas';

    print("xddd" + opcionesSeleccionadas);

    // Actualizar la interfaz de usuario
    setState(() {
      _recordatorios.add(recordatorio);
    });
  }

  void _mostrarDialogoNuevoRecordatorio(BuildContext context) {
    // Crea el diálogo y asigna la referencia a _currentAlertDialog
    _currentAlertDialog = AlertDialog(
      title: Text(
        'Nuevo recordatorio',
        textAlign: TextAlign.center,
      ),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(),
              ListTile(
                title: Text(
                  _horaSeleccionada != null
                      ? _horaSeleccionada!.format(context)
                      : '12:00 PM',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
                subtitle: Text(
                  'Tiempo del recordatorio',
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  _mostrarSelectorHora(context, setState);
                },
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Tipo de recordatorio',
                  textAlign: TextAlign.left, // Alineado a la izquierda
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _notificacionSeleccionada = true;
                        _alarmaSeleccionada = false;
                      });
                    },
                    child: Column(
                      children: [
                        Icon(Icons.notifications,
                            color: _notificacionSeleccionada
                                ? Colors.blue
                                : Colors.black),
                        Text(
                          'Notificación',
                          style: TextStyle(
                            color: _notificacionSeleccionada
                                ? Colors.blue
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _notificacionSeleccionada = false;
                        _alarmaSeleccionada = true;
                      });
                    },
                    child: Column(
                      children: [
                        Icon(Icons.alarm,
                            color: _alarmaSeleccionada
                                ? Colors.blue
                                : Colors.black),
                        Text(
                          'Alarma',
                          style: TextStyle(
                            color: _alarmaSeleccionada
                                ? Colors.blue
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(),
              Text(
                'Calendario de recordatorio',
                textAlign: TextAlign.left, // Alineado a la izquierda
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              Container(
                // Color de fondo deseado
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RadioListTile(
                      title: Text('Siempre disponible',
                          style: TextStyle(fontSize: 14)),
                      contentPadding: EdgeInsets.zero,
                      value: 1,
                      groupValue: _calendarioSeleccionado,
                      onChanged: (value) {
                        setState(() {
                          _calendarioSeleccionado = value;
                          if (value == 2) {
                            _diasSemanaSeleccionados.clear();
                          } // Limpia la selección de días de la semana
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text('Días específicos de la semana',
                          style: TextStyle(fontSize: 14)),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      value: 2,
                      groupValue: _calendarioSeleccionado,
                      onChanged: (value) {
                        setState(() {
                          _calendarioSeleccionado = value;
                        });
                      },
                    ),
                    if (_calendarioSeleccionado == 2) ...[
                      // Muestra los días de la semana si se selecciona "Días específicos de la semana"
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (final day in [
                            'Lun',
                            'Mar',
                            'Mié',
                            'Jue',
                            'Vie',
                            'Sáb',
                            'Dom'
                          ])
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (_diasSemanaSeleccionados.contains(day)) {
                                    _diasSemanaSeleccionados.remove(day);
                                  } else {
                                    _diasSemanaSeleccionados.add(day);
                                  }
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: _diasSemanaSeleccionados.contains(day)
                                      ? Colors.blue.withOpacity(0.5)
                                      : null,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  day,
                                  style: TextStyle(
                                    color:
                                        _diasSemanaSeleccionados.contains(day)
                                            ? Colors.white
                                            : null,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                    RadioListTile(
                      title:
                          Text('Días después', style: TextStyle(fontSize: 14)),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      value: 3,
                      groupValue: _calendarioSeleccionado,
                      onChanged: (value) {
                        setState(() {
                          _calendarioSeleccionado = value;
                          _diasSemanaSeleccionados
                              .clear(); // Limpia la selección de días de la semana
                        });
                      },
                    ),
                    if (_calendarioSeleccionado == 3) ...[
                      // Muestra un campo de entrada para ingresar los días después si se selecciona "Días después"
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 100, // Ancho deseado para el TextFormField
                            child: TextFormField(
                              initialValue: '1', // Valor predeterminado
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              onChanged: (value) {
                                setState(() {
                                  // Actualiza el valor de _diasDespuesSeleccionados cuando el campo de entrada cambie
                                  _diasDespuesSeleccionados =
                                      int.tryParse(value);
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            'días después',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                // Implementa aquí la lógica para guardar el recordatorio con la configuración seleccionada
                _guardarRecordatorio(); // Llama al método para guardar el recordatorio
                Navigator.of(context).pop();
                _mostrarDialogoRecordatorios(context); // Cierra el diálogo
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Color de fondo azul
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Guardar',
                style: TextStyle(color: Colors.white), // Texto en blanco
              ),
            ),

            SizedBox(width: 5.0), // Añade un espacio entre los botones
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Color de fondo rojo
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Cancelar',
                style: TextStyle(color: Colors.white), // Texto en blanco
              ),
            ),
          ],
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: SingleChildScrollView(
            child: _currentAlertDialog!,
          ),
        );
      },
    );
  }
}
