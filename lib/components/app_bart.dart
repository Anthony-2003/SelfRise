import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String titleText;

  CustomAppBar({required this.titleText});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: AppBarClipper(), // Aquí aplicamos el ClipPath
      child: Container(
        height: kToolbarHeight +
            40, // Altura estándar de AppBar + padding extra para el texto del título
        color: Color(0xFF2773B9),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.only(
                  bottom:
                      12), // Alinea el texto hacia abajo dentro del contenedor
              alignment: Alignment.center,
              child: Text(
                titleText,
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

class AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    // Aquí definimos el recorte para que tenga las esquinas inferiores redondeadas
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width * 0.25, size.height, size.width * 0.5, size.height);
    path.quadraticBezierTo(
        size.width * 0.75, size.height, size.width, size.height);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // Retorna verdadero si el clipper debe redibujar el path.
    // En este caso, no dependemos de condiciones que cambien, así que puede ser falso.
    return false;
  }
}
