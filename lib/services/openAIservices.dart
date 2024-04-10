import 'dart:convert';

import 'package:flutter_proyecto_final/entity/openaikey.dart';
import 'package:http/http.dart' as http;

class OpenAIServices {
  Future<String> chatGPTAPI(String prompt) async {
    try {
      final res = await http.post(
          Uri.parse('https://api.openai.com/v1/chat/completions'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $openAIKey',
          },
          body: jsonEncode({
            "model": "gpt-3.5-turbo",
            "messages": [
              {"role": "user", "content": "Hello! $prompt"}
            ]
          }));
      print(res.body);
      if (res.statusCode == 200) {
        print('se conecto');
      }
      return 'ai';
    } catch (e) {
      return e.toString();
    }
  }
}
