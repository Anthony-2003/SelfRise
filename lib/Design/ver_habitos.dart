import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Colors/colors.dart';
import 'package:flutter_proyecto_final/Design/editar_habito.dart';
import 'package:flutter_proyecto_final/Design/habitos_stepper.dart';
import 'package:flutter_proyecto_final/components/app_bart.dart';
import 'package:flutter_proyecto_final/entity/AuthService.dart';
import 'package:flutter_proyecto_final/services/habitos_services.dart';
import 'package:flutter_proyecto_final/utils/ajustar_brillo_color.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_dialogs/material_dialogs.dart';

class VerHabitosScreen extends StatefulWidget {
  @override
  _VerHabitosScreenState createState() => _VerHabitosScreenState();
}

class _VerHabitosScreenState extends State<VerHabitosScreen> {
  late List<Map<String, dynamic>> habitosUsuario = [];
  final String? idUsuarioActual = AuthService.getUserId();
  DateTime now = DateTime.now();
  List<String> weekDays = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];

  @override
  void initState() {
    super.initState();
    cargarHabitos();
  }

  Future<void> cargarHabitos() async {
    print("gg easy");
    List<Map<String, dynamic>> habitosCargados =
        await HabitosService().obtenerHabitos(idUsuarioActual!);

    setState(() {
      habitosUsuario = habitosCargados;
    });
  }

  void closeDialog() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: CustomAppBar(
          titleText: 'Mis hábitos',
          showBackButton: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            habitosUsuario.isEmpty
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 320),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No hay hábitos activos.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            'Siempre es un buen día para empezar.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.only(bottom: 80),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: habitosUsuario.length,
                    itemBuilder: (context, index) {
                      final habito = habitosUsuario[index];
                      return buildHabitoCard(habito);
                    },
                  ),
          ],
        ),
      ),
      floatingActionButton: _construirBotonFlotante(),
    );
  }

  Widget construirIconoConTexto(Map<String, dynamic> habito) {
    return Column(
      children: [
        ListTile(
          // Color de fondo del ListTile
          leading: Icon(
            Icons.analytics_rounded,
            color: Colors.white,
          ),
          title: Text('Estadísticas', style: TextStyle(color: Colors.white)),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditarHabito(
                      initialTabIndex: 0,
                      habito: habito,
                      cargarHabitos: cargarHabitos,
                      closeDialogs: closeDialog)), // Llama a EditarHabito
            );
          },
        ),
        ListTile(
          // Color de fondo del ListTile
          leading: Icon(
            Icons.edit,
            color: Colors.white,
          ),
          title: Text('Editar', style: TextStyle(color: Colors.white)),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditarHabito(
                      initialTabIndex: 1,
                      habito: habito,
                      cargarHabitos: cargarHabitos,
                      closeDialogs: closeDialog)), // Llama a EditarHabito
            );
          },
        ),
        ListTile(
// Color de fondo del ListTile
          leading: Icon(
            Icons.delete,
            color: Colors.white,
          ),
          title: Text('Eliminar', style: TextStyle(color: Colors.white)),
          onTap: () {
            // Agregar lógica para la opción de Eliminar
            _mostrarDialogoEliminarHabito(context, habito, () {
              // Función de cierre para cerrar ambos diálogos
              Navigator.of(context).popUntil((route) => true);
            });
          },
        ),
      ],
    );
  }

  void _mostrarDialogoEliminarHabito(
      BuildContext context, Map<String, dynamic> habito,
      [Function? closeDialogs]) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.drawer, // Color de fondo azul
          title: Text(
            'Eliminar habito',
            style: TextStyle(color: Colors.white), // Texto blanco
          ),
          content: Text(
            '¿Estás seguro de que deseas eliminar este habito?',
            style: TextStyle(color: Colors.white), // Texto blanco
          ),
          actions: <Widget>[
            // Botón Cancelar
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue, // Color de fondo azul
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0), // Bordes redondos
                ),
              ),
              child: Text(
                'Cancelar',
                style: TextStyle(color: Colors.white), // Texto blanco
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
            // Botón Eliminar
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor:
                    ajustarBrilloColor(Colors.red), // Color de fondo azul
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0), // Bordes redondos
                ),
              ),
              child: Text(
                'Eliminar',
                style: TextStyle(color: Colors.white), // Texto blanco
              ),
              onPressed: () async {
                HabitosService().borrarHabito(habito['id']);

                Fluttertoast.showToast(
                  msg: "Habito borrado correctamente",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                );
                await cargarHabitos();

                closeDialog();

                Navigator.pop(context);
                // Cierra el diálogo
              },
            ),
          ],
        );
      },
    );
  }

  void mostrarDialogo(Map<String, dynamic> habito, BuildContext context) {
    Dialogs.bottomMaterialDialog(
      color: AppColors.drawer,
      context: context,
      actions: [
        Padding(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.zero,
                child: buildHabitoInfo(habito, color: Colors.white),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.zero,
                child: buildDivider(color: Colors.white),
              ),
              SizedBox(height: 10),
              construirIconoConTexto(habito)
              // Agregar más widgets según sea necesario
            ],
          ),
        ),
      ],
    );
  }

  Widget buildHabitoCard(Map<String, dynamic> habito) {
    return Card(
      margin: EdgeInsets.all(8.0),
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: Colors.grey, width: 1.0),
      ),
      child: InkWell(
        onTap: () {
          mostrarDialogo(habito, context);
        },
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHabitoInfo(habito),
              buildDivider(),
              SizedBox(height: 15),
              buildWeekDays(),
              SizedBox(height: 15),
              buildDivider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.more_vert),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construirBotonFlotante() {
    return FloatingActionButton(
      backgroundColor: Color(0xFF2773B9),
      focusColor: Colors.white,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HabitosPageView(
              manejarHabitoGuardado: cargarHabitos,
            ), // No se pasa ningún parámetro opcional
          ),
        );
      },
      child: Icon(Icons.add, color: Colors.white),
    );
  }

  Widget buildHabitoInfo(Map<String, dynamic> habito, {Color? color}) {
    Color nombreColor = color ?? Colors.black;
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildHabitoName(habito, color: nombreColor),
          buildHabitoIcon(habito),
        ],
      ),
    );
  }

  Widget buildHabitoName(Map<String, dynamic> habito, {Color? color}) {
    Color nombreColor = color ?? Colors.black;
    Color colorAjustado = ajustarBrilloColor(Color(habito['color']));
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            habito['nombreHabito'],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: nombreColor,
            ),
          ),
          SizedBox(height: 4),
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: colorAjustado,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              habito['frecuenciaHabito'],
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHabitoIcon(Map<String, dynamic> habito) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Color(habito['color']),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Icon(
        IconData(
          habito['iconoCategoria'],
          fontFamily: 'MaterialIcons',
        ),
        size: 24,
        color: Colors.black,
      ),
    );
  }

  Widget buildDivider({Color? color}) {
    return Divider(
      color: color ??
          Colors
              .black, // Establecer un color por defecto si no se proporciona ninguno
      height: 15,
    );
  }

  Widget buildWeekDays() {
    List<DateTime> weekDaysList = [];
    // Generar la lista de días de la semana actual
    for (int i = 6; i >= 0; i--) {
      DateTime day = now.subtract(Duration(days: i));
      weekDaysList.add(day);
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: weekDaysList.map((day) {
            String dayName =
                weekDays[day.weekday - 1]; // Obtener el nombre del día
            int dayOfMonth = day.day;
            return Column(
              children: [
                Text(
                  dayName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Text(
                    '$dayOfMonth',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
