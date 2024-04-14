// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:typed_data';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_proyecto_final/components/inputs.dart';
import 'package:flutter_proyecto_final/components/pickerImage.dart';
import 'package:flutter_proyecto_final/services/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Colors/colors.dart';
import '../components/buttons.dart';
import 'login.dart';

class RegistroScreen extends StatefulWidget {
  RegistroScreen({super.key});

  bool checkBoxValue = false;

  @override
  // ignore: library_private_types_in_public_api
  _RegistroScreenState createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  int _currentPage = 0;
  bool isComplete = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatpasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime? Dateselected;
  Uint8List? image;

  void selectImage() async {
    Uint8List img = await pickerImage(ImageSource.gallery);
    setState(() {
      image = img;
    });
  }

  Future<bool> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.storage,
    ].request();

    // Verifica si todos los permisos fueron concedidos
    bool allPermissionsGranted =
        statuses.values.every((status) => status == PermissionStatus.granted);

    return allPermissionsGranted;
  }

// En tu función donde quieres solicitar permisos y seleccionar una imagen
  void trySelectImage() async {
    // Asegúrate de que todos los permisos fueron concedidos
    bool permissionsGranted = await requestPermissions();
    if (permissionsGranted) {
      selectImage();
    } else {
      // Maneja el caso donde no todos los permisos fueron concedidos
      // Por ejemplo, mostrando un diálogo al usuario explicando por qué necesitas los permisos
      print("No se concedieron todos los permisos necesarios.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Registro de Usuario',
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/imagenes/ingre_regis.png',
            fit: BoxFit.fill,
          ),
          Theme(
            data: ThemeData(
              canvasColor: Colors.transparent,
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: AppColors.buttonCoLor,
                    shadow: Colors.transparent,
                  ),
            ),
            child: Stepper(
              type: StepperType.horizontal,
              steps: getSteps(),
              currentStep: _currentPage,
              onStepTapped: (step) => setState(() => _currentPage = step),
              onStepContinue: () {
                final isLastStep = _currentPage == getSteps().length - 1;
                if (!isLastStep) {
                  setState(() => _currentPage++);
                } else {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.infoReverse,
                    dialogBackgroundColor: Colors.transparent,
                    headerAnimationLoop: true,
                    animType: AnimType.bottomSlide,
                    title: 'Registrar usuario',
                    titleTextStyle: const TextStyle(
                      color: Colors.white,
                    ),
                    reverseBtnOrder: true,
                    btnOkOnPress: () async {
                      setState(() => isComplete = true);
                      _registerUser();
                    },
                    btnCancelOnPress: () {},
                    desc: "¿Estás seguro que quieres registrar este usuario?",
                    descTextStyle: const TextStyle(
                      color: Colors.white,
                    ),
                    btnOkText: 'Aceptar',
                    btnCancelText: 'Cancelar',
                  ).show();
                }
              },
              onStepCancel: () {
                if (_currentPage != 0) {
                  setState(() => _currentPage--);
                }
              },
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                final isLastStep = _currentPage == getSteps().length - 1;

                return Row(
                  children: [
                    if (_currentPage != 0) ...[
                      CustomBackButton(
                        onTap: details.onStepCancel,
                        text: 'Atras',
                      ),
                    ],
                    const SizedBox(
                      width: 12,
                    ),
                    NextButton(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          bool userExists =
                              await checkIfUserExists(emailController.text);
                          if (!userExists) {
                            if (widget.checkBoxValue &&
                                passwordController.text ==
                                    repeatpasswordController.text) {
                              details.onStepContinue!();
                            } else if (widget.checkBoxValue == false) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                backgroundColor: Colors.orange,
                                content: Text(
                                  'Debes aceptar los términos y condiciones.',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ));
                            } else if (passwordController.text !=
                                repeatpasswordController.text) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                backgroundColor: Colors.orange,
                                content: Text(
                                  'Las contraseñas no coinciden',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ));
                            }
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              backgroundColor: Colors.orange,
                              content: Text(
                                'Ya existe un usuario con este email',
                                style: TextStyle(fontSize: 18),
                              ),
                            ));
                          }
                        }
                      },
                      text: isLastStep ? 'Confirmar' : 'Siguiente',
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _registerUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Crear una cuenta de usuario
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text,
        );

        // Obtener el usuario recién creado
        User? user = userCredential.user;

        // Enviar un correo electrónico de verificación
        if (!user!.emailVerified) {
          await user.sendEmailVerification();
        }

        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          dialogBackgroundColor: Colors.transparent,
          headerAnimationLoop: false,
          showCloseIcon: true,
          animType: AnimType.leftSlide,
          title: 'Usuario registrado',
          titleTextStyle: const TextStyle(
            color: Colors.white,
          ),
          reverseBtnOrder: true,
          btnOkOnPress: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
            );
          },
          btnOkIcon: Icons.check_circle,
          onDismissCallback: (type) {
            debugPrint('Dialog Dissmiss from callback $type');
          },
          desc:
              "Se ha enviado un correo de verificación. Por favor, verifica tu correo antes de ingresar.",
          descTextStyle: const TextStyle(
            color: Colors.white,
          ),
          btnOkText: 'Aceptar',
        ).show();
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Error durante el registro. Inténtalo de nuevo. $error',
            style: TextStyle(fontSize: 18),
          ),
        ));
      }
    }
  }

  List<Step> getSteps() => [
        Step(
          state: _currentPage > 0 ? StepState.complete : StepState.indexed,
          isActive: _currentPage >= 0,
          title: const Text(
            'Cuenta',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          content: Center(
            child: SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      InputsRegister(
                        hinttxt: 'Correo',
                        obscuretxt: false,
                        controller: emailController,
                        icono: Icons.alternate_email,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor introduce el correo electrónico';
                          } else if (!isValidEmail(value)) {
                            return 'Introduce un correo electrónico válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InputsRegister(
                        hinttxt: 'Contraseña',
                        controller: passwordController,
                        obscuretxt: true,
                        icono: Icons.password,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor introduce la contraseña';
                          } else if (value.length < 8) {
                            return 'La contraseña debe tener al menos 8 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InputsRegister(
                        hinttxt: 'Repetir Contraseña',
                        controller: repeatpasswordController,
                        obscuretxt: true,
                        icono: Icons.password,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor repite la contraseña';
                          } else if (value != passwordController.text) {
                            return 'Las contraseñas no coinciden';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                      CheckboxListTile(
                        title: const Text(
                          'Acepto los términos y condiciones',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: widget.checkBoxValue,
                        onChanged: (bool? newValue) {
                          setState(() {
                            widget.checkBoxValue = newValue!;
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Step(
          state: _currentPage > 1 ? StepState.complete : StepState.indexed,
          isActive: _currentPage >= 1,
          title: const Text(
            'Datos personales',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          content: Center(
            child: SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    InputsRegister(
                      hinttxt: 'Nombre',
                      controller: nameController,
                      obscuretxt: false,
                      icono: Icons.person,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor introduce el nombre';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InputsRegister(
                      hinttxt: 'Apellido',
                      controller: lastnameController,
                      obscuretxt: false,
                      icono: Icons.person,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor introduce el apellido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ImputDate(
                      datecontroller: birthdayController,
                      icono: Icons.calendar_month,
                      selectedDate: Dateselected,
                      validator: (value) {
                        if (value == null) {
                          return 'Por favor selecciona la fecha de nacimiento';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Step(
          state: _currentPage > 2 ? StepState.complete : StepState.indexed,
          isActive: _currentPage >= 2,
          title: const Text(
            'Foto',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          content: Center(
            child: SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    if (image != null)
                      CircleAvatar(
                        radius: 200,
                        backgroundImage: MemoryImage(image!),
                      )
                    else
                      const CircleAvatar(
                        radius: 200,
                        backgroundImage: NetworkImage(
                            'https://icons.iconarchive.com/icons/papirus-team/papirus-status/512/avatar-default-icon.png'),
                      ),
                    Positioned(
                      bottom: 40,
                      right: 20,
                      child: IconButton(
                        icon: const Icon(
                          Icons.add_a_photo_rounded,
                          color: Colors.white,
                          size: 60,
                        ),
                        onPressed: () {
                          trySelectImage();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ];

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
