import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:flutter/foundation.dart';
import '../Colors/colors.dart';
import '../services/api_frase_diaria.dart';
import '../services/api_traductor.dart';
import './chat.dart';

class PantallaMenuPrincipal extends StatefulWidget {
  const PantallaMenuPrincipal({Key? key}) : super(key: key);

  @override
  _PantallaMenuPrincipalState createState() => _PantallaMenuPrincipalState();
}

class _PantallaMenuPrincipalState extends State<PantallaMenuPrincipal> {
  int _selectedTab = 0;

  final List<Widget> _pages = [
    PantallaPrincipal(),
    PantallaChat(),
    PantallaAsignaciones(),
    PantallaSeguimientoCambios(),
    PantallaPerfil(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedTab],
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedTab,
        height: 50,
        items: <Widget>[
          _construirNavigationBarItem(Icons.home),
          _construirNavigationBarItem(Icons.chat),
          _construirNavigationBarItem(Icons.assignment),
          _construirNavigationBarItem(Icons.track_changes),
          _construirNavigationBarItem(Icons.person),
        ],
        backgroundColor: Colors.white,
        color: const Color.fromARGB(255, 104, 174, 240),
        animationDuration: const Duration(milliseconds: 300),
        onTap: (int index) {
          setState(() {
            _selectedTab = index;
          });
        },
      ),
    );
  }

  Widget _construirNavigationBarItem(IconData icon) {
    return Icon(icon, size: 30);
  }
}

class PantallaPrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              _construirBotonMenu(),
              _construirTextoBienvenida(),
              _construirTextoSentimientos(),
              _construirFilaIconosSentimientos(),
              const Text(
                'Frase de hoy',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor),
              ),
              _construirFutureBuilder(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construirBotonMenu() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: IconButton(
        icon: const Icon(Icons.menu, size: 35, color: AppColors.textColor),
        onPressed: () {},
        key: const Key('menu_button'),
      ),
    );
  }

  Widget _construirTextoBienvenida() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 15.0),
      child: Text(
        '¡Bienvenido de vuelta, Emilia!',
        style: TextStyle(fontSize: 25, color: AppColors.textColor),
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
            color: AppColors.textColor),
      ),
    );
  }

  Widget _construirIconoConTexto(String nombreAsset, String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/iconos/$nombreAsset',
            width: 50,
            height: 50,
          ),
          const SizedBox(height: 5), // Espacio entre la imagen y el texto
          Text(
            texto,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
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

  Widget _construirFutureBuilder() {
    return FutureBuilder<Map<String, dynamic>>(
      future: ApiFraseDiaria.fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _construirIndicadorProgreso();
        } else if (snapshot.hasError) {
          if (kDebugMode) {
            print(snapshot.error);
          }
          return _construirTextoError('Error al cargar la frase del día');
        } else {
          final frase = snapshot.data!['quote'];
          final autor = snapshot.data!['author'];
          return _traducirFrase(frase, autor);
        }
      },
    );
  }

  Widget _construirIndicadorProgreso() {
    return const CircularProgressIndicator();
  }

  Widget _construirTextoError(String mensaje) {
    return Text(mensaje);
  }

  Widget _traducirFrase(String frase, String autor) {
    return FutureBuilder<Map<String, dynamic>>(
      future: ApiTraductor.traducirFrase(frase),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _construirIndicadorProgreso();
        } else if (snapshot.hasError) {
          return _construirTextoError('Error al traducir la frase');
        } else {
          final fraseTraducida = snapshot.data!['data']['translatedText'];
          return _construirFraseDelDia(fraseTraducida, autor);
        }
      },
    );
  }

  Widget _construirFraseDelDia(String fraseDelDia, String autor) {
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
                    fontWeight: FontWeight.bold),
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
                        fontStyle: FontStyle.italic),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              IconButton(
                icon: const Icon(
                  Icons.share,
                  color: AppColors.textColor,
                  size: 30,
                ),
                onPressed: () {
                  _compartirFrase(fraseDelDia, autor);
                },
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

class PantallaAsignaciones extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Pantalla de Asignaciones'),
    );
  }
}

class PantallaSeguimientoCambios extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Pantalla de Seguimiento de Cambios'),
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
