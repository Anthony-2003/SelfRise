import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Design/menu_principal.dart';
import '../Colors/colors.dart';

class ButtonsLogin extends StatelessWidget {
  final Function()? ontap;

  const ButtonsLogin({super.key, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navegar a la pantalla de registro al presionar "Regístrate ahora"
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const PantallaMenuPrincipal()), // Reemplaza "RegistroScreen()" con la pantalla a la que deseas redirigir
        );
      },
      child: Container(
        height: 50,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 50),
        decoration: const BoxDecoration(
          color: AppColors.buttonCoLor,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: const Center(
          child: Text(
            'Ingresar',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
