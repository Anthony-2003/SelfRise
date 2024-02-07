import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../Colors/colors.dart';
import '../services/api_frase_diaria.dart';


class PantallaMenuPrincipal extends StatelessWidget {
  const PantallaMenuPrincipal({
    Key ? key
  }): super(key: key);

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
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textColor),
                    ),
                    _construirFutureBuilder(),
              ],
            ),
          ),
      ),
      bottomNavigationBar: _construirNavigationBarInferior(),
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
        style: TextStyle(fontSize: 27, color: AppColors.textColor),
      ),
    );
  }

  Widget _construirTextoSentimientos() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Text(
        '¿Cómo te sientes hoy?',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textColor),
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
              'assets/$nombreAsset',
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

  Widget _construirFraseDelDia(String fraseDelDia) {
  return SizedBox(
    child: Center(
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          color: AppColors.darkGray,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Ajustar el tamaño verticalmente
          children: [
            Text(
              fraseDelDia,
              style: const TextStyle(color: AppColors.textColor, fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            IconButton(
              icon: const Icon(
                Icons.share,
                color: AppColors.textColor,
              ),
              onPressed: () {
                // Acción al presionar el botón de compartir
              },
            ),
          ],
        ),
      ),
    ),
  );
}


  Widget _construirFutureBuilder() {
    return FutureBuilder < Map < String, dynamic >> (
      future: ApiFraseDiaria.fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          if (kDebugMode) {
            print(snapshot.error);
          }
          return const Text('Error al cargar la frase del día');
        } else {
          if (snapshot.data != null) {
            final quote = snapshot.data!['quote'] ?? 'No se pudo obtener la frase del día';
            return _construirFraseDelDia(quote);
          } else {
            return const Text('No se obtuvieron datos');
          }
        }
      },
    );
  }

  Widget _construirNavigationBarInferior() {
    return BottomNavigationBar(
      backgroundColor: Colors.blue,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: 'Evaluación',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.track_changes),
          label: 'Hábitos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    );
  }
}