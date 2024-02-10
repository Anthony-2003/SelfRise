import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/components/mySlides.dart';

class InputsLogin extends StatelessWidget {
  final TextEditingController controller;
  final String hinttxt;
  final bool obscuretxt;
  final IconData icono;

  const InputsLogin(
      {super.key,
      required this.controller,
      required this.hinttxt,
      required this.obscuretxt,
      required this.icono});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: TextField(
        controller: controller,
        obscureText: obscuretxt,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          fillColor: Colors.grey.shade300,
          filled: true,
          prefixIcon: Align(
            widthFactor: 1.0,
            heightFactor: 1.0,
            child: Icon(
              icono,
            ),
          ),
          hintText: hinttxt,
          hintStyle: TextStyle(color: Colors.grey[500]),
          isDense: true, // Added this
          contentPadding: const EdgeInsets.all(8),
        ),
      ),
    );
  }
}
