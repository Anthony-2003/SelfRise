import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/components/inputs.dart';
import 'package:flutter_proyecto_final/services/firebase_auth.dart';
import '../Colors/colors.dart';
import '../components/buttons.dart';
import '../components/loginwith.dart';
import 'menu_principal.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuthServ _auth = FirebaseAuthServ();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //para loguearse

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/imagenes/ingre_regis.png',
            fit: BoxFit.fill,
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Logo
                  const SizedBox(
                    height: 50,
                  ),
                  Image.asset(
                    'assets/iconos/Selfriselogoblanco.png',
                    width: 124,
                    height: 124,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  //Bienvenido
                  Text(
                    'Bienvenido a tu nueva vida',
                    style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 30,
                  ),

                  //username textfield
                  InputsLogin(
                    controller: emailController,
                    hinttxt: 'Correo electronico',
                    obscuretxt: false,
                    icono: Icons.alternate_email,
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  //pass textfield
                  InputsLogin(
                    controller: passwordController,
                    hinttxt: 'Contraseña',
                    obscuretxt: true,
                    icono: Icons.lock,
                  ),

                  //login button
                  const SizedBox(
                    height: 20,
                  ),
                  ButtonsLogin(
                    ontap: singUserIn,
                    // () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) =>
                    //             const PantallaMenuPrincipal()), // Reemplaza "RegistroScreen()" con la pantalla a la que deseas redirigir
                    //   );
                    // },
                    txt: 'Ingresar',
                  ),
                  const SizedBox(
                    height: 50,
                  ),

                  //or

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'O continua con',
                          style: TextStyle(
                            color: Colors.grey[350],
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[300],
                          ),
                        ),
                      ],
                    ),
                  ),

                  //google + fb + apple
                  const SizedBox(height: 20),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      loginwith(
                        rute: 'assets/iconos/google.png',
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      loginwith(
                        rute: 'assets/iconos/apple.png',
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  //si no tienes una cuenta registrate
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '¿No tienes una cuenta todavía?',
                        style: TextStyle(
                          color: Colors.grey[350],
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegistroScreen()),
                          );
                        },
                        child: const Text(
                          'Regístrate ahora',
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void singUserIn() async {
    String email = emailController.text;
    String password = passwordController.text;

    User? user = await _auth.SignInPassAndEmail(email, password);

    if (user != null) {
      print('Se ha ingresado correctamente el usuario');
      Navigator.pushNamed(context, '/menu_principal');
    } else {
      print('Se ha ingresado incorrectamente el usuario');
    }
  }
}
