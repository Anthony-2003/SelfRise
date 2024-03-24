import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Design/defineHabito.dart';
import 'package:flutter_proyecto_final/Design/evaluar_progreso.dart';
import 'package:flutter_proyecto_final/Design/fecha_habitos.dart';
import 'package:flutter_proyecto_final/Design/seleccionar_categoria.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'frecuenciaHabito.dart';

class HabitosPageView extends StatefulWidget {
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
                  return EvaluarProgresoScreen(_pageController);
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
                          onPressed: () {
                            if (_habito.isEmpty) {
                              Fluttertoast.showToast(
                                msg: "Por favor ingresa un hábito",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                              );
                            } else if (_currentPageIndex == 4) {
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