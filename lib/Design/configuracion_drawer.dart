import 'package:flutter/material.dart';
import '../Colors/colors.dart';

List<BoxShadow> shadowList = [
  BoxShadow(color: AppColors.darkGray, blurRadius: 30, offset: Offset(0, 10))
];

List<Map> drawerItems = [
  {'iconPath': 'assets/icon-menu/psicologo.png', 'title': 'Psicologo'},
  {'iconPath': 'assets/icon-menu/libros.png', 'title': 'Libros'},
  {'iconPath': 'assets/icon-menu/podcast.png', 'title': 'Podcast'},
  {'iconPath': 'assets/icon-menu/nutricion.png', 'title': 'Nutricion'},
  {'iconPath': 'assets/icon-menu/configuracion.png', 'title': 'Configuracion'},
  {'iconPath': 'assets/icon-menu/salir.png', 'title': 'Salir'},
];
