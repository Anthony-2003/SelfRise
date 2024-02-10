import 'package:flutter/material.dart';

class loginwith extends StatelessWidget {
  final String rute;
  const loginwith({super.key, required this.rute});

  @override
  Widget build(BuildContext context) {
    return Container(
      
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.white),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: Image.asset(
          rute,
          height: 40,
        ));
  }
}
