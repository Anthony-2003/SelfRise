import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Design/defineHabito.dart';
import 'package:flutter_proyecto_final/Design/evaluar_progreso.dart';
import 'package:flutter_proyecto_final/Design/fecha_habitos.dart';
import 'package:flutter_proyecto_final/Design/seleccionar_categoria.dart';
import 'package:flutter_proyecto_final/services/AuthService.dart';
import 'package:flutter_proyecto_final/entity/Frecuencia.dart';
import 'package:flutter_proyecto_final/entity/Habito.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'frecuenciaHabito.dart';
import 'package:flutter_proyecto_final/services/habitos_services.dart';

class HabitosPageView extends StatefulWidget {
  final Function() onHabitSaved;

  HabitosPageView({required this.onHabitSaved});

  @override
  _HabitosPageViewState createState() => _HabitosPageViewState();
}

class _HabitosPageViewState extends State<HabitosPageView> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPageIndex = 0;
  String _habito = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 5,
            onPageChanged: (int index) {
              setState(() {
                _currentPageIndex = index;
              });
            },
            itemBuilder: (BuildContext context, int index) {
              switch (index) {
                case 0:
                  return SeleccionarCategoriaPantalla(_pageController);
                case 1:
                  return EvaluarProgresoScreen(
                    pageController: _pageController,
                  );
                case 2:
                  return DefineHabitoScreen(
                    onHabitoChanged: (value) {
                      setState(() {
                        _habito = value;
                      });
                    },
                  );
                case 3:
                  return FrecuenciaScreen();
                case 4:
                  return FechaHabitosScreen();
              }
              return null;
            },
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      color: Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Container(
                    width: 100,
                    child: TextButton(
                      onPressed: () {
                        if (_currentPageIndex != 0) {
                          _pageController.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        _currentPageIndex != 0 ? 'Atrás' : 'Cancelar',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      for (int i = 0; i < 5; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 1.0),
                          child: Icon(
                            Icons.circle,
                            size: 16.0,
                            color: i == _currentPageIndex
                                ? Colors.blue
                                : Colors.grey,
                          ),
                        ),
                    ],
                  ),
                ),
                Flexible(
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 300),
                    opacity: _currentPageIndex > 1 ? 1.0 : 0.0,
                    child: IgnorePointer(
                      ignoring: _currentPageIndex <= 1,
                      child: Container(
                        width: 100,
                        child: TextButton(
                          onPressed: () async {
                            if (_habito.isEmpty) {
                              Fluttertoast.showToast(
                                msg: "Por favor ingresa un hábito",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                              );
                            } else if (_currentPageIndex == 4) {
                              print("Guardando hábito...");

                              dynamic frecuenciaValor;
                              String? userId = AuthService.getUserId();

                              switch (Habito.frequency.nombre) {
                                case 'Cada día':
                                  frecuenciaValor = Frecuencia.cadaDia;
                                  break;
                                case 'Días específicos de la semana':
                                  frecuenciaValor = Frecuencia.diasSemana;
                                  break;
                                case 'Días específicos del mes':
                                  frecuenciaValor = Frecuencia.diasMes;
                                  break;
                                case 'Repetir':
                                  frecuenciaValor = Frecuencia.diasDespues;
                                  break;
                                default:
                                  throw ArgumentError(
                                      'Frecuencia no válida: ${Habito.frequency.nombre}');
                              }

                              try {
                                await HabitosService().guardarHabito(
                                  userId,
                                  Habito.category,
                                  Habito.categoryIcon,
                                  Habito.habitName,
                                  Habito.evaluateProgress,
                                  Habito.frequency,
                                  frecuenciaValor,
                                  Habito.startDate,
                                  Habito.endDate,
                                  false,
                                  Habito.habitDescription,
                                );

                                widget.onHabitSaved();

                                Fluttertoast.showToast(
                                  msg: "Hábito guardado correctamente!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                );
                              } catch (e) {
                                print('Error al guardar el hábito: $e');
                              }

                              Habito.category = "";
                              Habito.categoryIcon = Icons.sports_soccer;
                              Habito.habitName = "";
                              Habito.evaluateProgress = "";
                              Habito.frequency = Frecuencia.CADA_DIA;
                              Habito.startDate = DateTime.now();
                              Habito.endDate = null;
                              Habito.habitDescription = "";

                              Navigator.pop(context);
                            } else {
                              _pageController.nextPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          child: Text(
                            _currentPageIndex == 4 ? 'Finalizar' : 'Siguiente',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
