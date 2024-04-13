import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Colors/colors.dart';
import 'package:flutter_proyecto_final/Design/configuracion/Acercadenosotros.dart';
import 'package:flutter_proyecto_final/Design/configuracion/Licencias.dart';
import 'package:flutter_proyecto_final/Design/configuracion/Terminosycondiciones.dart';
import 'package:flutter_proyecto_final/Design/menu_principal.dart';

class Configuracion extends StatefulWidget {
  const Configuracion({super.key});

  @override
  State<Configuracion> createState() => _ConfiguracionState();
}

class _ConfiguracionState extends State<Configuracion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.textColor,
        automaticallyImplyLeading: false,
        title: Text(
          'Configuración',
          style: TextStyle(
              color: AppColors.appcolor,
              fontWeight: FontWeight.bold,
              fontSize: 25,
              fontFamily: AutofillHints.sublocality),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.appcolor,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PantallaMenuPrincipal(),
              ),
            );
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /*Container(
              margin: EdgeInsets.only(left: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.light_mode,
                    size: 35,
                    color: AppColors.drawer,
                  ),
                  const SizedBox(width: 30),
                  Container(
                    child: TextButton(
                      onPressed: () {
                        //FUNCIONES AQUIIIIII
                      },
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(AppColors.drawer),
                      ),
                      child: const Text(
                        'Apariencia',
                        style: TextStyle(
                            fontSize: 23, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              width: 330,
              child: Divider(
                thickness: 3,
                color: AppColors.drawer,
              ),
            ),*/
            Container(
              margin: EdgeInsets.only(left: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.group,
                    size: 35,
                    color: AppColors.drawer,
                  ),
                  const SizedBox(width: 30),
                  Container(
                    child: TextButton(
                      onPressed: () {
                        //FUNCIONES AQUIIIIII
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => acercade(),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(AppColors.drawer),
                      ),
                      child: const Text(
                        'Acerca de nosotros',
                        style: TextStyle(
                            fontSize: 23, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              width: 330,
              child: Divider(
                thickness: 3,
                color: AppColors.drawer,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.import_contacts_outlined,
                    size: 35,
                    color: AppColors.drawer,
                  ),
                  const SizedBox(width: 30),
                  Container(
                    child: TextButton(
                      onPressed: () {
                        //FUNCIONES AQUIIIIII
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => licencias(),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(AppColors.drawer),
                      ),
                      child: const Text(
                        'Licencias',
                        style: TextStyle(
                            fontSize: 23, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              width: 330,
              child: Divider(
                thickness: 3,
                color: AppColors.drawer,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.description,
                    size: 35,
                    color: AppColors.drawer,
                  ),
                  const SizedBox(width: 30),
                  Container(
                    child: TextButton(
                      onPressed: () {
                        //FUNCIONES AQUIIIIII
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => terminos(),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(AppColors.drawer),
                      ),
                      child: const Text(
                        'Terminos y condiciones',
                        style: TextStyle(
                            fontSize: 23, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              width: 330,
              child: Divider(
                thickness: 3,
                color: AppColors.drawer,
              ),
            )
          ],
        ),
      ),
    );
  }
}
