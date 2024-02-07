import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Design/menu_principal.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SelfRise',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: GoogleFonts.robotoTextTheme()
      ),
      home: const PantallaMenuPrincipal(), 
    );
  }
}

