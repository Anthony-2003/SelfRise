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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(UserRep());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FavoriteProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SelfRise',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            textTheme: GoogleFonts.robotoTextTheme()),
        home: const SlideLoginWithCheck(),
        routes: {
          '/menu_principal': (context) => const PantallaMenuPrincipal(),
          '/login': (context) => LoginPage(),
          '/register': (context) => RegistroScreen(),
        },
      ),
    );
  }
}

class SlideLoginWithCheck extends StatefulWidget {
  const SlideLoginWithCheck({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SlideLoginWithCheckState createState() => _SlideLoginWithCheckState();
}

class _SlideLoginWithCheckState extends State<SlideLoginWithCheck> {
  bool _isFirstTime = true;

  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }

  Future<void> _checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTimeSlideLogin') ?? true;
    setState(() {
      _isFirstTime = isFirstTime;
    });
  }

  Future<void> _setFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTimeSlideLogin', false);
  }

  @override
  Widget build(BuildContext context) {
    return _isFirstTime
        ? SlideLogin(onLoginSuccess: () async {
            await _setFirstTime();
            // ignore: use_build_context_synchronously
            Navigator.pushReplacementNamed(context, '/menu_principal');
          })
        : const PantallaMenuPrincipal();
  }
}
  