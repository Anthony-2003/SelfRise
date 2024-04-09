import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/components/app_bart.dart';
import 'package:flutter_proyecto_final/entity/BarraCircularProgreso.dart';
import 'package:flutter_proyecto_final/services/habitos_services.dart';

class EditarHabito extends StatefulWidget {
  final int initialTabIndex;
  final Map<String, dynamic> habito;

  EditarHabito({required this.initialTabIndex, required this.habito});

  @override
  _EditarHabitoState createState() => _EditarHabitoState();
}

class _EditarHabitoState extends State<EditarHabito>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int conteoHabito = 0;
  int conteoMes = 0;
  int conteoSemana = 0;
  int conteoAnio = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 2, vsync: this, initialIndex: widget.initialTabIndex);
    _tabController.addListener(_tabChanged);
    _fetchConteoHabito();
    _fetchConteosAdicionales();
  }

  void _fetchConteoHabito() {
    String habitId = widget.habito['id'];
    HabitosService().obtenerConteoHabitosCompletados(habitId).then((value) {
      setState(() {
        conteoHabito = value;
      });
    }).catchError((error) {
      print('Error al obtener el conteo de hábitos completados: $error');
      // Maneja el error según sea necesario
    });
  }

  void _fetchConteosAdicionales() async {
    String habitId = widget.habito['id'];
    List<Map<String, dynamic>>? registros =
        await HabitosService().obtenerRegistrosCompletadosPorId(habitId);

    if (registros != null) {
      // Obtener fecha actual
      DateTime now = DateTime.now();
      // Obtener fecha de inicio de semana
      DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      // Obtener fecha de inicio de mes
      DateTime startOfMonth = DateTime(now.year, now.month, 1);
      // Obtener fecha de inicio de año
      DateTime startOfYear = DateTime(now.year, 1, 1);

      int total = registros.length;
      int mes = registros
          .where((registro) => (registro['fechaCompletado'] as Timestamp)
              .toDate()
              .isAfter(startOfMonth))
          .length;
      int semana = registros
          .where((registro) => (registro['fechaCompletado'] as Timestamp)
              .toDate()
              .isAfter(startOfWeek))
          .length;
      int anio = registros
          .where((registro) => (registro['fechaCompletado'] as Timestamp)
              .toDate()
              .isAfter(startOfYear))
          .length;

      setState(() {
        conteoMes = mes;
        conteoSemana = semana;
        conteoAnio = anio;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _tabChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: CustomAppBar(
          titleText: widget.habito['nombreHabito'],
          showBackButton: true,
          icon: IconData(widget.habito['iconoCategoria'],
              fontFamily: 'MaterialIcons'),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 8), // Espacio adicional
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Estadísticas'),
              Tab(text: 'Editar'),
            ],
            labelColor: Colors.black,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight
                    .normal), // Texto en negrita para la pestaña activa
            indicatorColor: Color(
                0xFF2773B9), // Color de la raya debajo de la pestaña activa
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Contenido de la pestaña de estadísticas
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressBar(
                        percentage: conteoHabito
                            .toDouble(), // Porcentaje de progreso total
                        number: conteoHabito, // Cantidad total
                      ),
                      Text('Total: $conteoHabito'),
                      Text('Mes: $conteoMes'),
                      Text('Semana: $conteoSemana'),
                      Text('Año: $conteoAnio'),
                    ],
                  ),
                ),
                // Contenido de la pestaña de editar
                Center(
                  child: Text(
                    'Contenido de editar aquí',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
