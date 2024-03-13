import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Design/defineHabito.dart';
import 'package:flutter_proyecto_final/Design/seleccionar_categoria.dart';
import 'frecuenciaHabito.dart';

class HabitosPageView extends StatefulWidget {
  @override
  _HabitosPageViewState createState() => _HabitosPageViewState();
}

class _HabitosPageViewState extends State<HabitosPageView> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            itemCount: 3,
            onPageChanged: (int index) {
              setState(() {
                _currentPageIndex = index;
              });
            },
            itemBuilder: (BuildContext context, int index) {
              switch (index) {
                case 0:
                  return SeleccionarCategoriaPantalla();
                case 1:
                  return DefineHabitoScreen();
                default:
                  return FrecuenciaScreen(repetir: true);
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      color: Colors.grey[200], // Color de fondo del contenedor
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancelar',
                      style: TextStyle(color: Colors.black),
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
                  child: TextButton(
                    onPressed: () {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Text(
                      'Siguiente',
                      style: TextStyle(color: Colors.black),
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
