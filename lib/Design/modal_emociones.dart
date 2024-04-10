import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ModalEmociones extends StatefulWidget {
  final String emocion;

  const ModalEmociones({Key? key, required this.emocion}) : super(key: key);

  @override
  _ModalEmocionesState createState() => _ModalEmocionesState();
}

class _ModalEmocionesState extends State<ModalEmociones> {
  String? _selectedWeather;
  String? _selectedSocial;
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Estado de ánimo: ${widget.emocion}'),
      content: SingleChildScrollView(
        child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('¿Qué actividades te hacen sentir ${widget.emocion}?'),
          SizedBox(height: 20),
          Text('Selecciona el clima:'),
          _buildWeatherSection(),
          SizedBox(height: 20),
          Text('Selecciona tu entorno social:'),
          _buildSocialSection(),
          SizedBox(height: 20),
          Text('Escribe algo o expresa cómo te sientes:'),
          TextField(
            decoration: InputDecoration(
              hintText: 'Escribe aquí...',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          SizedBox(height: 20),
          Text('Graba un mensaje de voz:'),
          _buildVoiceRecordingSection(),
        ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Guardar'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cerrar'),
        )
      ],
    );
  }


  Widget _buildWeatherSection() {
    return Row(
      children: <Widget>[
        _buildWeatherOption('Soleado', Icons.wb_sunny ),
        _buildWeatherOption('Nublado', Icons.cloud),
        _buildWeatherOption('Lluvioso', Icons.beach_access),
        _buildWeatherOption('Nevado', Icons.ac_unit),
      ],
    );
  }

  Widget _buildWeatherOption(String weather, IconData icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedWeather = weather;
        });
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: _selectedWeather == weather ? Colors.blue : Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            Icon(icon),
            SizedBox(height: 5),
            Text(weather),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialSection() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
      children: <Widget>[
        _buildSocialOption('Familia', Icons.family_restroom),
        _buildSocialOption('Amigos', Icons.people),
        _buildSocialOption('Trabajo', Icons.work),
        _buildSocialOption('Pareja', Icons.favorite),
        _buildSocialOption('Fiesta', Icons.party_mode), 
        _buildSocialOption('Viaje', Icons.flight), 
      ],
      ),
    );
  }

  Widget _buildSocialOption(String option, IconData icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSocial = option;
        });
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: _selectedSocial == option ? Colors.blue : Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            Icon(icon),
            SizedBox(height: 5),
            Text(option),
          ],
        ),
      ),
    );
  }

Widget _buildVoiceRecordingSection() {
  bool _isRecording = false;

  return Row(
    children: <Widget>[
      IconButton(
        icon: Icon(_isRecording ? Icons.stop : Icons.mic),
        onPressed: () {
          setState(() {
            _isRecording = !_isRecording;
          });
          if (_isRecording) {
            //*Iniciar grabación
            //*lógica para iniciar la grabación de voz
          } else {
            // Detener grabación
            //*lógica para detener la grabación de voz
          }
        },
      ),
      SizedBox(width: 8),
      Text(
        _isRecording ? 'Grabando...' : 'Presiona para grabar',
        style: TextStyle(
          fontWeight: _isRecording ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    ],
  );
}

}