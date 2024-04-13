import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Colors/colors.dart';
import 'package:flutter_proyecto_final/Design/configuracion/Configuracion.dart';
import 'package:flutter_proyecto_final/Design/menu_principal.dart';

class terminos extends StatefulWidget {
  const terminos({Key? key});

  @override
  State<terminos> createState() => _terminosState();
}

class _terminosState extends State<terminos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.textColor,
        automaticallyImplyLeading: false,
        title: Text(
          'Términos y Condiciones',
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
                builder: (context) => Configuracion(),
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 50),
                child: Text(
                  "Términos y Condiciones de Uso",
                  style: TextStyle(
                    fontSize: 20,
                    color: AppColors.drawer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  width: 320,
                  child: Divider(
                    thickness: 2,
                    color: AppColors.drawer,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "1. Uso de la Plataforma",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.drawer,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "1.1. Acceso a la Plataforma: Al utilizar nuestra Plataforma, garantizas que tienes al menos 18 años" +
                          "de edad o que cuentas con la autorización de un adulto para utilizarla.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: AppColors.drawer,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "1.2. Contenido: El contenido disponible en nuestra Plataforma, incluyendo pero no limitado a texto, imágenes, " +
                          "videos y otros materiales ('Contenido'), es propiedad de Selfrise o de sus licenciantes. No podrás utilizar, " +
                          "reproducir o distribuir el Contenido sin nuestro consentimiento previo por escrito.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: AppColors.drawer,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "1.3. Cuentas de Usuario: Al registrarte para obtener una cuenta en nuestra Plataforma, garantizas que toda la " +
                          "información proporcionada es precisa y completa. Eres responsable de mantener la confidencialidad de tu cuenta y " +
                          "de todas las actividades que ocurran bajo tu cuenta.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: AppColors.drawer,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "2. Responsabilidades del Usuario",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.drawer,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "2.1. Uso Adecuado: Te comprometes a utilizar nuestra Plataforma de manera adecuada y conforme a la ley aplicable. " +
                          "No podrás utilizar nuestra Plataforma con fines ilegales o no autorizados.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: AppColors.drawer,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "2.2. Contenido Generado por el Usuario: Si eliges publicar contenido en nuestra Plataforma, garantizas que " +
                          "tienes los derechos necesarios sobre dicho contenido y que no viola los derechos de terceros ni los " +
                          "presentes Términos.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: AppColors.drawer,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "3. Limitación de Responsabilidad",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.drawer,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "3.1. Exención de Responsabilidad: En la medida permitida por la ley aplicable, Selfrise no " +
                          "será responsable de ningún daño directo, indirecto, incidental, especial, consecuente o punitivo " +
                          "que surja del uso o la imposibilidad de utilizar nuestra Plataforma.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: AppColors.drawer,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "4. Modificaciones de los Términos",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.drawer,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "4.1. Modificaciones: Selfrise se reserva el derecho de modificar estos Términos en cualquier momento " +
                          "y a su entera discreción. Te recomendamos que revises periódicamente estos Términos para estar al tanto " +
                          "de cualquier cambio.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: AppColors.drawer,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "5. Ley Aplicable",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.drawer,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "5.1. Jurisdicción: Estos Términos se regirán e interpretarán de acuerdo con las leyes de República " +
                          "Dominicana, sin tener en cuenta sus disposiciones sobre conflictos de leyes.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: AppColors.drawer,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "6. Contacto",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.drawer,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "6.1. Contacto: Si tienes alguna pregunta sobre estos Términos, por favor contáctanos a " +
                          "través de deparamentoselfrise@gmail.com",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: AppColors.drawer,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
