import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String titleText; // Nuevo atributo para almacenar el texto del título
  final bool showBackButton; // Nuevo atributo para mostrar u ocultar el botón de "Atrás"

  CustomAppBar({required this.titleText, this.showBackButton = false}); // Constructor que recibe el texto del título y el valor predeterminado para showBackButton

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Color(0xFF2773B9),
      automaticallyImplyLeading: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      shadowColor: Color(0xFF000000).withOpacity(1),
      title: Container(
        padding: EdgeInsets.only(top: 35),
        alignment: Alignment.center,
        child: Stack(
          children: [
            if (showBackButton) // Condición para mostrar el botón de "Atrás" si showBackButton es true
              Positioned(
                left: 0,
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  color: Colors.white,
                  iconSize: 30, // Tamaño del icono
                  onPressed: () {
                    Navigator.pop(context); // Navegar hacia atrás cuando se presiona el botón
                  },
                ),
              ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              alignment: Alignment.center,
              child: Text(
                titleText, // Usar el texto del título recibido como parámetro
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
