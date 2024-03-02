import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Colors/colors.dart';
import 'package:flutter_proyecto_final/Design/menu_principal.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({super.key});

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: 288,
          height: double.infinity,
          color: AppColors.drawer,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 16),
              child: const InfoCard(),
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
                            onTap: () {
                              //FUNCIONES AQUIIIIIIIIII
                            },
                            leading: SizedBox(
                              height: 34,
                              width: 34,
                              child:
                                  Image.asset("assets/icon-menu/psicologo.png"),
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
                          //FUNCIONES AQUIIIIIIIIII
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
            //   ***** BOTON NUTRICION ******
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
                          child: Image.asset("assets/icon-menu/nutricion.png"),
                        ),
                        title: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Nutricion",
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
            //   ***** FINAL BOTON NUTRICION *****

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
                          child:
                              Image.asset("assets/icon-menu/configuracion.png"),
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
                          //FUNCIONES AQUIIIIIIIIII
                          FirebaseAuth.instance.signOut();
                          signOutFromGoogle();
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
    );
  }
}

//INFORMACION DEL USUARIO
class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.white_trans,
        radius: 30,
        child: Image.asset('assets/icon-menu/user-icon.png'),
      ),
      title: Text(
        "Julio Alimaña",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text("Usuario: @julioali"),
      textColor: AppColors.white,
    );
  }
}
