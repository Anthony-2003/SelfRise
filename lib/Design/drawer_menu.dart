import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Colors/colors.dart';
import 'package:flutter_proyecto_final/Design/menu_principal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_proyecto_final/services/AuthService.dart';
import 'package:flutter_proyecto_final/Design/booksPage.dart';
import 'package:flutter_proyecto_final/services/openAIservices.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: AppColors.drawer,
        child: ListView(
          // Usar ListView para permitir el desplazamiento
          padding: EdgeInsets.zero,
          children: <Widget>[
            const SizedBox(
                height: 48), // Espacio adicional en la parte superior
            const InfoCard(),
            Divider(color: AppColors.linecolor),
            _buildDrawerItem(
              icon: Icons.psychology,
              text: 'Psicólogo',
              onTap: () {
                // Acción para Psicólogo
              },
            ),
            _buildDrawerItem(
              icon: Icons.book,
              text: 'Libros',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BookListScreen()));
              },
            ),
            _buildDrawerItem(
              icon: Icons.podcasts,
              text: 'Podcast',
              onTap: () {
                // Acción para Podcast
              },
            ),
            _buildDrawerItem(
              icon: Icons.computer,
              text: 'Chat con IA',
              onTap: () {
                final OpenAIServices openai = OpenAIServices();
                openai.chatGPTAPI('soy leny');
              },
            ),
            Divider(color: AppColors.linecolor),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                "Más Opciones".toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: AppColors.white_trans),
              ),
            ),
            _buildDrawerItem(
              icon: Icons.settings,
              text: 'Configuración',
              onTap: () {
                // Acción para Configuración
              },
            ),
            _buildDrawerItem(
              icon: Icons.exit_to_app,
              text: 'Salir',
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                // signOutFromGoogle(); // Asegúrate de que este método esté implementado si usas Google Sign-In
                Navigator.pushNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
      {required IconData icon, required String text, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.white),
      title: Text(text,
          style:
              TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
      onTap: onTap,
    );
  }
}

//INFORMACIÓN DEL USUARIO
class InfoCard extends StatelessWidget {
  const InfoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: AuthService.getUserData(AuthService.getUserId()),
      builder: (BuildContext context,
          AsyncSnapshot<Map<String, dynamic>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          if (snapshot.hasError || snapshot.data == null) {
            return const Text('Error al obtener los datos del usuario');
          } else {
            final userData = snapshot.data!;
            final name = userData['name'] ?? 'Nombre de usuario no disponible';
            final photoUrl = userData['imageLink'];
            final email = userData['email'] ?? 'Email no disponible';
            return ListTile(
              leading: ClipOval(
                child: CircleAvatar(
                  backgroundColor: AppColors.white_trans,
                  radius: 25,
                  child: photoUrl != null
                      ? Image.network(photoUrl, fit: BoxFit.cover)
                      : const Icon(Icons.account_circle),
                ),
              ),
              title: Text(name,
                  style: TextStyle(
                      color: AppColors.white, fontWeight: FontWeight.bold)),
              subtitle: Text(email, style: TextStyle(color: AppColors.white)),
            );
          }
        }
      },
    );
  }
}
