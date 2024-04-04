import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String titleText; // Nuevo atributo para almacenar el texto del título

  CustomAppBar({required this.titleText}); // Constructor que recibe el texto del título

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
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              titleText, // Usar el texto del título recibido como parámetro
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
  }
}