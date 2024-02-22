import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

class FrasesMotivacionales {
  static Future<Map<String, dynamic>> obtenerFraseAleatoria() async {
    try {
      String jsonString = await rootBundle.loadString('lib/data/frases_motivacionales.json');
      Map<String, dynamic> jsonData = json.decode(jsonString);
      List<dynamic> frases = jsonData['frases_motivacionales'];
      
      Random random = Random();
      int index = random.nextInt(frases.length);

      Map<String, dynamic> fraseAleatoria = frases[index];

      return fraseAleatoria;
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
