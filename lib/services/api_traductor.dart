import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiTraductor {
  static const String _apiKey = '172eb51bddmshc1202cf63eb580fp1a45f0jsnfdd87db2aa48';
  static const String _host = 'text-translator2.p.rapidapi.com';
  static const String _url = 'https://text-translator2.p.rapidapi.com/translate';

  static Future<Map<String, dynamic>> traducirFrase(String text) async {
    final headers = {
      'content-type': 'application/x-www-form-urlencoded',
      'X-RapidAPI-Key': _apiKey,
      'X-RapidAPI-Host': _host,
    };
    final body = {
      'source_language': 'en',
      'target_language': 'es',
      'text': text,
    };

    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return result;
      } else {
        throw Exception('Petición fallida, status: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }
}

