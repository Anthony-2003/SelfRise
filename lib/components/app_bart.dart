import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String titleText;
  final bool showBackButton;
  final IconData? icon;

  CustomAppBar({
    required this.titleText,
    this.showBackButton = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
        padding: EdgeInsets.only(
            top: 35), // Modificar el padding según el texto del título
        alignment: Alignment.centerLeft,
        child: Stack(
          children: [
            // Título
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (showBackButton)
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: 15), // Ajusta este valor según sea necesario
                    child: IconButton(
                      icon: Icon(Icons.arrow_back),
                      color: Colors.white,
                      iconSize: 30,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                Expanded(
                  child: Container(
                    alignment:
                        icon == null ? Alignment.center : Alignment.centerLeft,
                    padding: EdgeInsets.only(
                        right: titleText == "Mis hábitos" ? 15 : 0,
                        bottom: titleText == "Mis hábitos"
                            ? 15
                            : (icon != null ? 15 : 0)),
                    child: Text(
                      titleText,
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                if (icon != null)
                  Padding(
                    padding: EdgeInsets.only(bottom: 20), // Ajusta el relleno según sea necesario
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
              ],
            ),
            // Icono superpuesto
          ],
        ),
      ),
    );
  }
}
