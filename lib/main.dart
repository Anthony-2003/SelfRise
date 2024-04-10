import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/components/favorite_provider.dart';
import 'package:flutter_proyecto_final/services/database.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'Design/login.dart';
import 'Design/menu_principal.dart';
import 'Design/register.dart';
import 'Design/slide_login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(UserRep());
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
      ]),
      builder: (context, snapshot) {
        // Verifica si Firebase se ha inicializado correctamente
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(home: Center(child: const CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          return MaterialApp(home: Center(child: Text('Error: ${snapshot.error}')));
        }

        // Escucha los cambios en el estado de autenticación
        return StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, authSnapshot) {
            if (authSnapshot.connectionState == ConnectionState.active) {
              // Usuario actual
              User? user = authSnapshot.data;
              
              // Si hay un usuario (ya ha iniciado sesión), redirige directamente a la pantalla de inicio de sesión
              // en lugar del carrusel de introducción, asumiendo que desean volver a iniciar sesión.
              if (user != null) {
                return ChangeNotifierProvider(
                  create: (context) => FavoriteProvider(),
                  child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'SelfRise',
                    theme: ThemeData(
                      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                      useMaterial3: true,
                      textTheme: GoogleFonts.robotoTextTheme(),
                    ),
                    // Modifica esta línea para llevar al usuario al LoginPage directamente
                    home: LoginPage(), // Usuario ya autenticado, lleva al Login para continuar
                    routes: {
                      '/menu_principal': (context) => const PantallaMenuPrincipal(),
                      '/login': (context) => LoginPage(),
                      '/register': (context) => RegistroScreen(),
                    },
                  ),
                );
              } else {
                // No hay usuario, muestra SlideLogin para autenticación o registro
                return ChangeNotifierProvider(
                  create: (context) => FavoriteProvider(),
                  child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'SelfRise',
                    theme: ThemeData(
                      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                      useMaterial3: true,
                      textTheme: GoogleFonts.robotoTextTheme(),
                    ),
                    home: const SlideLogin(), // Primera vez, muestra introducción
                    routes: {
                      '/menu_principal': (context) => const PantallaMenuPrincipal(),
                      '/login': (context) => LoginPage(),
                      '/register': (context) => RegistroScreen(),
                    },
                  ),
                );
              }
            }

            // Esperando determinar si hay un usuario autenticado o no
            return MaterialApp(home: Center(child:const CircularProgressIndicator()));
          },
        );
      },
    );
  }
}