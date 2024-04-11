import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Providers/habitos_provider.dart';
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
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest_10y.dart' as tz;

void main() async {
  tz.initializeTimeZones();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicialización del plugin FlutterLocalNotificationsPlugin
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  var initializationSettingsIOS = DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );
  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  flutterLocalNotificationsPlugin.initialize(initializationSettings);

  Get.put(UserRep());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider( // Utiliza MultiProvider para envolver tu MaterialApp con varios providers
      providers: [
        ChangeNotifierProvider(create: (context) => FavoriteProvider()),
        ChangeNotifierProvider(create: (context) => HabitoProvider()),
        // Agrega otros providers si los necesitas
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SelfRise',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          textTheme: GoogleFonts.robotoTextTheme(),
        ),
        home: const SlideLogin(),
        routes: {
          '/menu_principal': (context) => const PantallaMenuPrincipal(),
          '/login': (context) => LoginPage(),
          '/register': (context) => RegistroScreen(),
        },
      ),
    );
  }
}