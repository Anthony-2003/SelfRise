import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/services/database.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Design/login.dart';
import 'Design/menu_principal.dart';
import 'Design/drawer_menu.dart';
import 'Design/register.dart';
import 'Design/slide_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';
import '../Colors/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(UserRep());
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: AppColors.drawer,
    systemNavigationBarIconBrightness: Brightness.light,
    systemNavigationBarColor: AppColors
        .white, // Puedes ajustar el color de fondo según tus necesidades
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SelfRise',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          textTheme: GoogleFonts.robotoTextTheme()),
      home: const PantallaMenuPrincipal(),
    );
  }
}
