import 'package:flutter/material.dart';

class PantallaChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                _buildMessage(
                  context: context,
                  isMe: true,
                  message: 'Hola, ¿cómo estás?',
                  senderName: 'Yo',
                  imageUrl: 'assets/toji.jpg',
                ),
                _buildMessage(
                  context: context,
                  isMe: false,
                  message: '¡Hola! Estoy bien, ¿y tú?',
                  senderName: 'Otro Usuario',
                  imageUrl: 'assets/weekend.jpg',
                ),
                // Agrega más mensajes aquí
              ],
            ),
          ),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildMessage({
    required BuildContext context,
    required bool isMe,
    required String message,
    required String senderName,
    required String imageUrl,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isMe
              ? SizedBox(width: 8.0)
              : CircleAvatar(
                  backgroundImage: AssetImage(imageUrl),
                  radius: 20.0,
                ),
          Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  isMe ? 'Yo' : senderName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 4.0),
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: isMe ? Colors.blue : Colors.grey[300],
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Text(
                  message,
                  style: TextStyle(
                    color: isMe ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ],
          ),
          isMe
              ? CircleAvatar(
                  backgroundImage: AssetImage(imageUrl),
                  radius: 20.0,
                )
              : SizedBox(width: 8.0),
        ],
      ),
    );
  }

  Widget _buildInputField() {
  return Container(
    padding: EdgeInsets.all(16.0),
    child: Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Escribe tu mensaje...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 8.0),
        IconButton(
          icon: Icon(Icons.send),
          onPressed: () {
            // Lógica para enviar el mensaje
          },
        ),
      ],
    ),
  );
}

}
