import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../entity/AuthService.dart';
import '../entity/Chat.dart';

class PantallaChat extends StatelessWidget {
  final String? currentUser = AuthService.getUserId();

  PantallaChat({Key? key}) : super(key: key);

  Future<void> sendMessage(String message) async {
    final chat = Chat(
      senderId: currentUser ?? 'UsuarioDesconocido',
      content: message,
      timestamp: DateTime.now(),
    );

    await FirebaseFirestore.instance.collection('chat').add(chat.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chat')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final chats = snapshot.data?.docs
                        .map((doc) =>
                            Chat.fromMap(doc.data() as Map<String, dynamic>))
                        .toList() ??
                    [];

                return ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (BuildContext context, int index) {
                    final chat = chats[index];
                    final isMe = chat.senderId == currentUser;
                    return FutureBuilder<Map<String, dynamic>?>(
                      future: AuthService.getUserData(
                          chat.senderId), // Obtener datos del usuario
                      builder: (context,
                          AsyncSnapshot<Map<String, dynamic>?>
                              userDataSnapshot) {
                        if (userDataSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }

                        final senderName = isMe
                            ? 'Yo'
                            : userDataSnapshot.data?['name'] ??
                                'Usuario Desconocido';

                        return _buildMessage(
                          context: context,
                          isMe: isMe,
                          message: chat.content,
                          senderName:
                              senderName, // Usar el nombre del remitente obtenido
                          userPhotoUrl: userDataSnapshot.data?[
                              'img'], // Obtener URL de la foto del usuario
                        );
                      },
                    );
                  },
                );
              },
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
    required String? userPhotoUrl,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe) // Si el mensaje no es del usuario actual
            CircleAvatar(
              backgroundImage: userPhotoUrl != null
                  ? NetworkImage(userPhotoUrl)
                  : AssetImage('assets/imagenes/default_image.png')
                      as ImageProvider<Object>,
              radius: 20.0,
            ),
          SizedBox(
              width: isMe
                  ? 8.0
                  : 0), // Agrega un espacio entre el avatar y el mensaje si es del usuario actual
          Expanded(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    senderName,
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
          ),
          if (isMe) // Si el mensaje es del usuario actual
            CircleAvatar(
              backgroundImage: userPhotoUrl != null
                  ? NetworkImage(userPhotoUrl)
                  : AssetImage('assets/imagenes/default_image.png')
                      as ImageProvider<Object>,
              radius: 20.0,
            ),
          SizedBox(
              width: !isMe
                  ? 8.0
                  : 0), // Agrega un espacio entre el mensaje y el avatar si no es del usuario actual
        ],
      ),
    );
  }

  Widget _buildInputField() {
    TextEditingController messageController = TextEditingController();

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                controller: messageController,
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
              String message = messageController.text;
              if (message.isNotEmpty) {
                sendMessage(message);
                messageController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
