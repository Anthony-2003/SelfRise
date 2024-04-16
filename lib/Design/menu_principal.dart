import 'dart:async';
import 'dart:math';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_proyecto_final/Design/drawer_menu.dart';
import 'package:flutter_proyecto_final/Design/modal_emociones.dart';
import 'package:flutter_proyecto_final/components/app_bart.dart';
import 'package:flutter_proyecto_final/components/buttons.dart';
import 'package:flutter_proyecto_final/components/rive_utils.dart';
import 'package:flutter_proyecto_final/services/AuthService.dart';
import 'package:flutter_proyecto_final/services/emociones_service.dart';
import 'package:flutter_proyecto_final/services/frases_motivacionales.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import '../Colors/colors.dart';
import '../services/frases_motivacionales.dart';
import './chat.dart';
import './habitos.dart';
import 'package:intl/date_symbol_data_local.dart';

class PantallaMenuPrincipal extends StatefulWidget {
  const PantallaMenuPrincipal({Key? key}) : super(key: key);

  @override
  _PantallaMenuPrincipalState createState() => _PantallaMenuPrincipalState();
}

class _PantallaMenuPrincipalState extends State<PantallaMenuPrincipal>
    with SingleTickerProviderStateMixin {
  late SMIBool isSideBarClosed;
  bool isSideMenuClose = true;
  bool _isKeyboardVisible = false;

  late AnimationController _animationController;
  late Animation<double> animation;
  late Animation<double> scalAnimation;
  List<Map<String, dynamic>> emociones = [];

  int _selectedTab = 0;
  late String _nombreUsuario = '';
  final String? idUsuarioActual = AuthService.getUserId();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    )..addListener(() {
        setState(() {});
      });

    cargarEmocionesPorUsuario();

    animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));

    scalAnimation = Tween<double>(begin: 1, end: 0.8).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));

    super.initState();
    obtenerNombreUsuario();
  }

  Future<void> cargarEmocionesPorUsuario() async {
    try {
      print(idUsuarioActual);
      emociones =
          await EmocionesService.obtenerTodasEmociones(idUsuarioActual!);

      print(emociones);

      emociones.forEach((emocion) {
        print(emocion);
      });
    } catch (e) {
      print('Error al obtener todas las emociones: $e');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  Future<void> obtenerNombreUsuario() async {
    final nombre = await AuthService.getUserName();
    setState(() {
      _nombreUsuario = nombre ?? 'Usuario';
    });
  }

  final List<Widget> _pages = [
    PantallaPrincipal(),
    PantallaChat(),
    PantallaAsignaciones(),
    PantallaSeguimientoHabitos(),
    PantallaPerfil(),
  ];

  @override
  Widget build(BuildContext context) {
    print(emociones);
    return Scaffold(
      backgroundColor: AppColors.drawer,
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            width: 288,
            left: isSideMenuClose ? -288 : 0,
            height: MediaQuery.of(context).size.height,
            child: DrawerMenu(),
          ),
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(animation.value - 30 * animation.value * pi / 180),
            child: Transform.translate(
              offset: Offset(animation.value * 265, 0),
              child: Transform.scale(
                scale: scalAnimation.value,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                  child: _pages[_selectedTab],
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 200),
            left: isSideMenuClose ? 0 : 220,
            top: 16,
            child: menubtn(
              riveOnInit: (artboard) {
                StateMachineController controller = RiveUtils.getRiveController(
                    artboard,
                    stateMachineName: "Morph");
                isSideBarClosed = controller.findSMI("Boolean 1") as SMIBool;
                isSideBarClosed.value = true;
              },
              press: () {
                isSideBarClosed.value = !isSideBarClosed.value;
                if (isSideMenuClose) {
                  _animationController.forward();
                  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                    systemNavigationBarIconBrightness: Brightness.dark,
                  ));
                } else {
                  _animationController.reverse();
                  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                    statusBarColor: Color.fromARGB(255, 0, 0, 0),
                    systemNavigationBarIconBrightness: Brightness.light,
                    systemNavigationBarColor: Color.fromARGB(255, 0, 0, 0),
                  ));
                }
                setState(() {
                  isSideMenuClose = isSideBarClosed.value;
                });
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Transform.translate(
              offset: _isKeyboardVisible
                  ? Offset(1000, 150 * animation.value)
                  : Offset(0, 150 * animation.value),
              child: CurvedNavigationBar(
                index: _selectedTab,
                height: 50,
                items: _construirNavigationBarItems(),
                backgroundColor: Colors.transparent,
                color: Color(0xFF2773B9),
                animationDuration: const Duration(milliseconds: 300),
                onTap: (int index) {
                  setState(() {
                    _selectedTab = index;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _construirNavigationBarItems() {
    return [
      Icons.home,
      Icons.chat,
      Icons.assignment,
      Icons.directions_run,
      Icons.person,
    ].map((icon) => _construirNavigationBarItem(icon)).toList();
  }

  Widget _construirNavigationBarItem(IconData icon) {
    return Icon(icon, size: 30, color: Colors.white);
  }
}

class PantallaPrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PantallaPrincipalContent(),
    );
  }
}

class PantallaPrincipalContent extends StatefulWidget {
  @override
  _PantallaPrincipalContentState createState() =>
      _PantallaPrincipalContentState();
}

class _PantallaPrincipalContentState extends State<PantallaPrincipalContent> {
  late bool _isVeronoverVisible = false;
  late Timer _veronoverTimer;

  late Map<String, dynamic> _fraseAleatoria = {};

  @override
  void initState() {
    super.initState();
    
    _checkVeronoverVisibility();
    _obtenerFraseAleatoria();
    _veronoverTimer = Timer.periodic(const Duration(hours: 24), (timer) {
      setState(() {
        _isVeronoverVisible = false;
      });
      _saveVeronoverVisibility(false);
      _veronoverTimer.cancel();
    });
    Timer.periodic(const Duration(hours: 24), (timer) {
      _obtenerFraseAleatoria();
    });
  }

  @override
  void dispose() {
    _veronoverTimer.cancel();
    super.dispose();
  }

  Future<void> _checkVeronoverVisibility() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? veronoverVisible = prefs.getBool('veronover_visible');

    if (veronoverVisible != null && veronoverVisible) {
      setState(() {
        _isVeronoverVisible = true;
      });
    }
  }

  Future<void> _saveVeronoverVisibility(bool isVisible) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('veronover_visible', isVisible);
  }

  Future<void> _obtenerFraseAleatoria() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? fraseGuardada = prefs.getString('frase');
      final String? autorGuardado = prefs.getString('autor');
      final String? fechaGuardada = prefs.getString('fecha');

      if (fraseGuardada != null &&
          autorGuardado != null &&
          fechaGuardada != null) {
        final DateTime fechaObtenida = DateTime.parse(fechaGuardada);
        final DateTime fechaActual = DateTime.now();

        if (fechaActual.difference(fechaObtenida).inDays < 1) {
          setState(() {
            _fraseAleatoria = {
              'frase': fraseGuardada,
              'autor': autorGuardado,
            };
          });
          return;
        }
      }
      Map<String, dynamic> frase =
          await FrasesMotivacionales.obtenerFraseAleatoria();
      await prefs.setString('frase', frase['frase']);
      await prefs.setString('autor', frase['autor']);
      await prefs.setString('fecha', DateTime.now().toIso8601String());

      setState(() {
        _fraseAleatoria = frase;
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: CustomAppBar(titleText: 'Inicio'),
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 5, 15, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          FutureBuilder<String?>(
            future: AuthService.getUserName(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              final userName = snapshot.data ?? 'Usuario';
              return _isVeronoverVisible
                  ? Veronover()
                  : _construirTextoBienvenida(userName);
            },
          ),
          _construirTextoSentimientos(),
          _construirFilaIconosSentimientos(),
          const Text(
            'Frase de hoy',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textColor,
            ),
          ),
          if (_fraseAleatoria['frase'] != null)
            Container(
              child: _construirFraseDelDia(
                  _fraseAleatoria['frase'], _fraseAleatoria['autor']),
            ),
        ],
      ),
    );
  }

  Widget _construirTextoBienvenida(String userName) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Text(
        '¡Hola, $userName!',
        style: TextStyle(
          fontSize: 25,
          color: AppColors.textColor,
        ),
      ),
    );
  }

  Widget _construirTextoSentimientos() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Text(
        '¿Cómo te sientes hoy?',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textColor,
        ),
      ),
    );
  }

  Widget _construirIconoConTexto(String nombreAsset, String texto) {
    return GestureDetector(
      onTap: () {
        _mostrarModalEmociones(context, texto);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/iconos/$nombreAsset',
              width: 50,
              height: 50,
            ),
            const SizedBox(height: 5),
            Text(
              texto,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarModalEmociones(BuildContext context, String emocion) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return ModalEmociones(emocion: emocion);
      },
    );

    if (result == true) {
      setState(() {
        _isVeronoverVisible = true;
      });

      _saveVeronoverVisibility(true);

      Timer(Duration(hours: 24), () {
        setState(() {
          _isVeronoverVisible = false;
        });

        _saveVeronoverVisibility(false);
      });
          showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Datos guardados'),
          content: Text('¡Tus emociones han sido guardadas correctamente!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );

    }
  }

  Widget _construirFilaIconosSentimientos() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _construirIconoConTexto('feliz.gif', 'Feliz'),
          _construirIconoConTexto('angel.gif', 'Tranquilo'),
          _construirIconoConTexto('triste.gif', 'Triste'),
          _construirIconoConTexto('neutral.gif', 'Neutral'),
          _construirIconoConTexto('enojado.gif', 'Enojado'),
        ],
      ),
    );
  }

  Widget _construirFraseDelDia(String fraseDelDia, String autor) {
    if (fraseDelDia.isEmpty || autor.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.darkGray,
          borderRadius: BorderRadius.circular(10),
        ),
      );
    }

    return SizedBox(
      child: Center(
        child: Container(
          margin: const EdgeInsets.only(top: 20, bottom: 20),
          decoration: BoxDecoration(
            color: AppColors.darkGray,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                fraseDelDia,
                style: const TextStyle(
                  color: AppColors.textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "-$autor",
                    style: const TextStyle(
                      color: Color.fromARGB(255, 98, 168, 233),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF2773B9),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.share,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    _compartirFrase(fraseDelDia, autor);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _compartirFrase(String texto, String autor) {
    Share.share("$texto\n-$autor", subject: 'Compartir frase del día');
  }
}

class Veronover extends StatelessWidget {
  final Map<String, String> _climaIconos = {
    'Soleado': 'assets/iconos_clima-social/sol.png',
    'Lluvia': 'assets/iconos_clima-social/lluvia.png',
    'Nublado': 'assets/iconos_clima-social/nublado.png',
  };

  final Map<String, String> _estadoAnimoIconos = {
    'Feliz': 'assets/iconos/feliz.gif',
    'Triste': 'assets/iconos/triste.gif',
    'Neutral': 'assets/iconos/neutral.gif',
  };

  final Map<String, String> _entornoSocialIconos = {
    'Familia': 'assets/iconos_clima-social/familia.png',
    'Amigos': 'assets/iconos_clima-social/amigo.png',
    'Trabajo': 'assets/iconos_clima-social/trabajo.png',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 50, 178, 176).withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<String>(
            future: obtenerFechaActual(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox.shrink(); // Mostrar un widget vacío mientras se carga la fecha
              }
              if (snapshot.hasError) {
                return Text('Error al obtener la fecha: ${snapshot.error}');
              }
              final fechaActual = snapshot.data;
              return Text(
                fechaActual ?? 'Fecha no disponible',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              );
            },
          ),
          SizedBox(height: 10),
          FutureBuilder<Map<String, dynamic>>(
            future: _obtenerUltimaEmocionGuardada(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              final data = snapshot.data;
              if (data == null || data.isEmpty) {
                return Text('No hay datos disponibles');
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
            
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          _buildIconWithText(_estadoAnimoIconos[data['estado_animo'] ?? ''] ?? ''),
                        ],
                      ),
                      SizedBox(width: 10),
                      Column(
                        children: [
                          _buildIconWithText(_climaIconos[data['clima'] ?? ''] ?? ''),
                          SizedBox(width: 10),
                          Row(
                            children: [
                              _buildIconWithText(_entornoSocialIconos[data['entorno_social'] ?? ''] ?? ''),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIconWithText(String imagePath, {double iconSize = 48}) {
    return Column(
      children: [
        _buildIconRow(imagePath, iconSize: iconSize),
        SizedBox(height: 5),
        // Text(
        //   text,
        //   style: TextStyle(
        //     fontSize: 12,
        //   ),
        // ),
      ],
    );
  }

  Widget _buildIconRow(String imagePath, {double iconSize = 48}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Image.asset(imagePath, width: iconSize, height: iconSize),
    );
  }

  Future<Map<String, dynamic>> _obtenerUltimaEmocionGuardada() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? estadoAnimo = prefs.getString('estado_animo');
      String? clima = prefs.getString('clima');
      String? entornoSocial = prefs.getString('entorno_social');
      String? textoSentimientos = prefs.getString('texto_sentimientos');

      if (estadoAnimo != null &&
          clima != null &&
          entornoSocial != null &&
          textoSentimientos != null) {
        return {
          'estado_animo': estadoAnimo,
          'clima': clima,
          'entorno_social': entornoSocial,
          'texto_sentimientos': textoSentimientos,
        };
      } else {
        return {}; // Retorna un mapa vacío si no hay datos guardados
      }
    } catch (error) {
      print('Error al obtener la última emoción guardada: $error');
      return {}; // Retorna un mapa vacío en caso de error
    }
  }

Future<String> obtenerFechaActual() async {
  try {
    await initializeDateFormatting('es');
    DateTime fechaActual = DateTime.now();
    DateFormat formatter = DateFormat('EEE, d MMM', 'es');
    String fecha = formatter.format(fechaActual);
    return fecha; // Solo devuelve la cadena de texto formateada
  } catch (error) {
    print('Error al obtener la fecha actual: $error');
    return 'Fecha no disponible';
  }
}

}


class PantallaAsignaciones extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Pantalla de Asignaciones'),
    );
  }
}

class PantallaPerfil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Pantalla de Perfil'),
    );
  }
}

void signOutFromGoogle() async {
  GoogleSignIn googleSignIn = GoogleSignIn();
  await googleSignIn.signOut();
}
