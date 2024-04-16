import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Colors/colors.dart';
import 'package:flutter_proyecto_final/components/app_bart.dart';
import 'package:flutter_proyecto_final/entity/authservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ModalEmociones extends StatefulWidget {
  final String emocion;

  const ModalEmociones({Key? key, required this.emocion}) : super(key: key);

  @override
  _ModalEmocionesState createState() => _ModalEmocionesState();
}

class _ModalEmocionesState extends State<ModalEmociones> {
  String? _selectedWeather;
  String? _selectedSocial;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          decoration: BoxDecoration(
            color: Color(0xFF2773B9),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
          child: Center(
            child: CustomAppBar(titleText: "Estado de animo: ${widget.emocion}"),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEmotionEmoji(),
            const SizedBox(height: 20),
            _buildQuestion(),
            const SizedBox(height: 20),
            _buildWeatherSection(),
            const SizedBox(height: 20),
            _buildSocialSection(),
            const SizedBox(height: 20),
            _buildFeelingsTextField(),
            const SizedBox(height: 20),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmotionEmoji() {
    String emojiPath = _getEmojiForEmotion(widget.emocion);
    return Container(
        alignment: Alignment.center,
        child: Image.asset(
          emojiPath,
          width: 90,
          height: 90,
        ));
  }

  String _getEmojiForEmotion(String emocion, {double size = 24.0}) {
    Map<String, String> emotionEmojiMap = {
      'Feliz': 'assets/iconos/feliz.gif',
      'Triste': 'assets/iconos/triste.gif',
      'Enojado': 'assets/iconos/enojado.gif',
      'Angel': 'assets/iconos/angel.gif',
    };

    return emotionEmojiMap[emocion] ??
        'assets/iconos/neutral.gif'; // Emoticono neutro por defecto
  }

  Widget _buildQuestion() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Text(
        '¿Qué actividades te hacen sentir ${widget.emocion}?',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildWeatherSection() {
    return SizedBox(
      width: double.infinity,
      height: 120,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey),
           color: Color.fromARGB(255, 137, 179, 214).withOpacity(0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Clima:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                ),
            ),
            const SizedBox(height: 5),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  _buildWeatherOption(
                      'Soleado', 'assets/iconos_clima-social/sol.png'),
                  _buildWeatherOption(
                      'Nublado', 'assets/iconos_clima-social/nublado.png'),
                  _buildWeatherOption(
                      'Lluvioso', 'assets/iconos_clima-social/lluvia.png'),
                  _buildWeatherOption(
                      'Nevado', 'assets/iconos_clima-social/nevando.png'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherOption(String weather, String imagePath) {
    return GestureDetector(
      onTap: () => setState(() => _selectedWeather = weather),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          children: [
            Image.asset(
              imagePath,
              width: 36,
              height: 36,
              color: _selectedWeather == weather ? Colors.blue : null,
            ),
            const SizedBox(height: 5),
            Text(
              weather,
              style: TextStyle(
                color: _selectedWeather == weather ? Colors.blue : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialSection() {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey),
          color: Color.fromARGB(255, 137, 179, 214).withOpacity(0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Social:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Wrap(
              children: <Widget>[
                _buildSocialOption(
                    'Familia', 'assets/iconos_clima-social/familia.png'),
                _buildSocialOption(
                    'Amigos', 'assets/iconos_clima-social/amigo.png'),
                _buildSocialOption(
                    'Trabajo', 'assets/iconos_clima-social/trabajo.png'),
                _buildSocialOption(
                    'Pareja', 'assets/iconos_clima-social/pareja.png'),
                _buildSocialOption(
                    'Cita', 'assets/iconos_clima-social/cita.png'),
                _buildSocialOption(
                    'Fiesta', 'assets/iconos_clima-social/Fiesta.png'),
                _buildSocialOption(
                    'Viaje', 'assets/iconos_clima-social/Viaje.png'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialOption(String option, String imagePath) {
    return GestureDetector(
      onTap: () => setState(() => _selectedSocial = option),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          children: [
            Image.asset(
              imagePath,
              width: 36,
              height: 36,
              color: _selectedSocial == option ? Colors.blue : null,
            ),
            const SizedBox(height: 5),
            Text(
              option,
              style: TextStyle(
                color: _selectedSocial == option ? Colors.blue : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeelingsTextField() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey),
        color: Color.fromARGB(255, 137, 179, 214).withOpacity(0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                hintText: 'Escribe aquí...',
                border: InputBorder.none,
              ),
              maxLines: 3,
            ),
          ),
          SizedBox(width: 10),
          IconButton(
            onPressed: () {
              // Acción para subir imagen
            },
            icon: Icon(Icons.image),
          ),
          IconButton(
            onPressed: () {
              // Acción para seleccionar emojis
            },
            icon: Icon(Icons.emoji_emotions),
          ),
        ],
      ),
    );
  }

Widget _buildSaveButton() {
  return Container(
    alignment: Alignment.center,
    width: 400, // Ancho fijo del botón
    height: 70, // Altura del botón
    child: ElevatedButton(
      onPressed: () {
        _guardarEmociones().then((success) {
          if (success) {
            Navigator.of(context).pop(
                true); // Envía true si las emociones se guardaron correctamente
          } else {
            Navigator.of(context).pop(
                false); // Envía false si hubo un error al guardar las emociones
          }
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        'Guardar',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20, // Tamaño del texto
        ),
      ),
    ),
  );
}


  Future<bool> _guardarEmociones() async {
    try {
      await FirebaseFirestore.instance.collection('emociones').add({
        'estado_animo': widget.emocion,
        'clima': _selectedWeather,
        'entorno_social': _selectedSocial,
        'id_usuario': AuthService.getUserId(),
        'texto_sentimientos': _textEditingController.text,
      });

      // Guardar las emociones en las preferencias compartidas
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('estado_animo', widget.emocion);
      await prefs.setString('clima', _selectedWeather ?? '');
      await prefs.setString('entorno_social', _selectedSocial ?? '');
      await prefs.setString('texto_sentimientos', _textEditingController.text);

      return true; // Emociones guardadas exitosamente
    } catch (e) {
      print('Error al guardar emociones: $e');
      return false; // Error al guardar emociones
    }
  }
}
