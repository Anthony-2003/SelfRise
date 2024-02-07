import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiFraseDiaria {

  static const apiKey = 'SeuqhDmik2yOtkO42dqgwQ==jtZAhB8LkM8vnrAt';
  static Future<Map<String, dynamic>> fetchData() async {
    final url = Uri.parse('https://api.api-ninjas.com/v1/quotes?category=happiness');
    final response = await http.get(url, headers: {'X-Api-Key': apiKey});

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        return data[0];
      } else {
        throw Exception('No se encontraron datos');
      }
    } else {
      throw Exception('Error al cargar los datos: ${response.statusCode}');
    }
  }
}
