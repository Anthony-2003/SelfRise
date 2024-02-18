import 'package:flutter/material.dart';

class loginwith extends StatelessWidget {
  final String rute;
  final Function()? onTap;
  const loginwith({super.key, required this.rute, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.white),
              borderRadius: const BorderRadius.all(Radius.circular(8))),
          child: Image.asset(
            rute,
            height: 45,
          )),
    );
  }
}
