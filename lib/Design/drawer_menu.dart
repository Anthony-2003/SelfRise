import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Colors/colors.dart';
import 'package:flutter_proyecto_final/Design/menu_principal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_proyecto_final/components/profilProvider.dart';
import 'package:flutter_proyecto_final/services/AuthService.dart';
import 'package:flutter_proyecto_final/Design/booksPage.dart';
import 'package:provider/provider.dart';

import '../components/imageprovider.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({super.key});

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  @override
  Widget build(BuildContext context) {
    final userDataProvider =
        Provider.of<UserDataProvider>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: 288,
          height: double.infinity,
          color: AppColors.drawer,
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5, vertical: 16),
                child: InfoCard(),
              ),
              Container(
                margin: EdgeInsets.only(left: 10, bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 32, bottom: 0),
                  child: Text("Explorar".toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: AppColors.white_trans)),
                ),
              ),
              //    ***** BOTON PSICOLOGO ******
              Container(
                //LEFT, TOP, RIGHT, BOTTOM
                margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Divider(
                        color: AppColors.linecolor,
                        height: 1,
                      ),
                    ),
                    Container(
                      //LEFT, TOP, RIGHT, BOTTOM
                      margin: EdgeInsets.fromLTRB(5, 9, 5, 0),
                      child: Stack(
                        children: [
                          ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 15),
                              onTap: () {},
                              leading: SizedBox(
                                height: 34,
                                width: 34,
                                child: Image.asset(
                                    "assets/icon-menu/psicologo.png"),
                              ),
                              title: Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  "Psicologo",
                                  style: TextStyle(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              //   ***** FINAL BOTON PSICOLOGO *****
              //   ***** BOTON LIBROS ******
              Container(
                //LEFT, TOP, RIGHT, BOTTOM
                margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Divider(
                        color: AppColors.linecolor,
                        height: 1,
                      ),
                    ),
                    Container(
                      //LEFT, TOP, RIGHT, BOTTOM
                      margin: EdgeInsets.fromLTRB(5, 9, 5, 0),
                      child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BookListScreen(), // Aquí se crea la instancia de BookListScreen
                              ),
                            );
                          },
                          leading: SizedBox(
                            height: 34,
                            width: 34,
                            child: Image.asset("assets/icon-menu/libros.png"),
                          ),
                          title: Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "Libros",
                              style: TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              //   ***** FINAL BOTON LIBROS *****
              //   ***** BOTON PODCAST ******
              Container(
                //LEFT, TOP, RIGHT, BOTTOM
                margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Divider(
                        color: AppColors.linecolor,
                        height: 1,
                      ),
                    ),
                    Container(
                      //LEFT, TOP, RIGHT, BOTTOM
                      margin: EdgeInsets.fromLTRB(5, 9, 5, 0),
                      child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          onTap: () {
                            //FUNCIONES AQUIIIIIIIIII
                          },
                          leading: SizedBox(
                            height: 34,
                            width: 34,
                            child: Image.asset("assets/icon-menu/podcast.png"),
                          ),
                          title: Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "Podcast",
                              style: TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              //   ***** FINAL BOTON PODCAST *****
              Container(
                margin: EdgeInsets.only(left: 10, bottom: 4, top: 40),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 32, bottom: 0),
                  child: Text("Mas Opciones".toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: AppColors.white_trans)),
                ),
              ),

              //   ***** BOTON CONFIGURACION ******
              Container(
                //LEFT, TOP, RIGHT, BOTTOM
                margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Divider(
                        color: AppColors.linecolor,
                        height: 1,
                      ),
                    ),
                    Container(
                      //LEFT, TOP, RIGHT, BOTTOM
                      margin: EdgeInsets.fromLTRB(5, 9, 5, 0),
                      child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          onTap: () {
                            //FUNCIONES AQUIIIIIIIIII
                          },
                          leading: SizedBox(
                            height: 34,
                            width: 34,
                            child: Image.asset(
                                "assets/icon-menu/configuracion.png"),
                          ),
                          title: Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "Configuracion",
                              style: TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              //   ***** FINAL BOTON CONFIGURACION *****
              //   ***** BOTON SALIR ******
              Container(
                //LEFT, TOP, RIGHT, BOTTOM
                margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Divider(
                        color: AppColors.linecolor,
                        height: 1,
                      ),
                    ),
                    Container(
                      //LEFT, TOP, RIGHT, BOTTOM
                      margin: EdgeInsets.fromLTRB(5, 9, 5, 0),
                      child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          onTap: () {
                            FirebaseAuth.instance.signOut();
                            signOutFromGoogle();
                            userDataProvider.setImageUrl('');
                            userDataProvider.setCorreo('');
                            userDataProvider.setNombre('');
                            Navigator.pushNamed(context, '/login');
                          },
                          leading: SizedBox(
                            height: 34,
                            width: 34,
                            child: Image.asset("assets/icon-menu/salir.png"),
                          ),
                          title: Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "Salir",
                              style: TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              //   ***** FINAL BOTON SALIR *****
            ]),
          ),
        ),
      ),
    );
  }
}

//INFORMACION DEL USUARIO
class InfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataProvider>(context);
    final name = userData.nombre ?? 'Nombre no disponible';
    final email = userData.correo ?? 'Email no disponible';
    final imageUrl = userData.imageUrl;

    return Padding(
      padding: const EdgeInsets.only(top: 60.0),
      child: ListTile(
        leading: ClipOval(
          child: CircleAvatar(
            backgroundColor: AppColors.white_trans,
            radius: 25,
            backgroundImage:
                imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
          ),
        ),
        title: Text(name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Text(email, style: TextStyle(fontSize: 10)),
        textColor: AppColors.white,
      ),
    );
  }
}
