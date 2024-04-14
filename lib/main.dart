import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/components/favorite_provider.dart'; // Asegúrate de importar FavoriteProvider
import 'package:flutter_proyecto_final/components/imageprovider.dart';
import 'package:flutter_proyecto_final/components/profilProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Design/login.dart';
import 'Design/menu_principal.dart';
import 'Design/register.dart';
import 'Design/slide_login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool seen = prefs.getBool('seen') ?? false;

  runApp(MyApp(seen: seen));
}

class MyApp extends StatelessWidget {
  final bool seen;
  const MyApp({Key? key, required this.seen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(
            create: (_) => UserDataProvider(
                '', '', '')), // Ajustado para incluir tres argumentos vacíos
        // Aquí puedes añadir más providers si es necesario
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SelfRise',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: seen ? LoginPage() : SlideLogin(),
        routes: {
          '/menu_principal': (context) => const PantallaMenuPrincipal(),
          '/login': (context) => LoginPage(),
          '/register': (context) => RegistroScreen(),
        },
      ),
    );
  }
}
