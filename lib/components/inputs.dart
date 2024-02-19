import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Colors/colors.dart';

class InputsLogin extends StatelessWidget {
  final TextEditingController? controller;
  final String hinttxt;
  final bool obscuretxt;
  final IconData icono;
  final String? Function(String?)? validator;

  const InputsLogin(
      {super.key,
      this.controller,
      required this.hinttxt,
      required this.obscuretxt,
      required this.icono,
      required this.validator});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: TextFormField(
        validator: validator,
        controller: controller,
        obscureText: obscuretxt,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.buttonCoLor, width: 3),
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

class InputsRegister extends StatelessWidget {
  final TextEditingController? controller;
  final String hinttxt;
  final bool obscuretxt;
  final IconData icono;

  const InputsRegister(
      {super.key,
      this.controller,
      required this.hinttxt,
      required this.obscuretxt,
      required this.icono});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
    );
  }
}
