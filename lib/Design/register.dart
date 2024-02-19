import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/components/inputs.dart';
import 'package:flutter_proyecto_final/components/pickerImage.dart';
import 'package:image_picker/image_picker.dart';
import '../Colors/colors.dart';
import '../components/buttons.dart';
import 'login.dart';

// ignore: must_be_immutable
class RegistroScreen extends StatefulWidget {
  RegistroScreen({Key? key}) : super(key: key);
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool checkBoxValue = false;

  @override
  _RegistroScreenState createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  int _currentPage = 0;
  bool isComplete = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:
            Text('Registro de Usuario', style: TextStyle(color: Colors.white)),
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
                  //enviar datos al servidor
                  setState(() => isComplete = true);
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
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
                          onTap: details.onStepCancel, text: 'Atras'),
                    ],
                    const SizedBox(
                      width: 12,
                    ),
                    NextButton(
                      onTap: () {
                        if (widget.checkBoxValue) {
                          details.onStepContinue!();
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
                child:
                    //correo
                    Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    const InputsRegister(
                        hinttxt: 'Correo',
                        obscuretxt: false,
                        icono: Icons.alternate_email),
                    const SizedBox(
                      height: 20,
                    ),
                    //contrase;a
                    const InputsRegister(
                        hinttxt: 'Contraseña',
                        obscuretxt: false,
                        icono: Icons.password),
                    const SizedBox(
                      height: 10,
                    ),

                    //text

                    const Text(
                      'Ingresa una contraseña segura que contenga al menos 8 caracteres, incluyendo letras mayúsculas, minúsculas, números y caracteres especiales.',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //contrase;a
                    const InputsRegister(
                        hinttxt: 'Contraseña',
                        obscuretxt: false,
                        icono: Icons.password),
                    const SizedBox(
                      height: 10,
                    ),

                    //text
                    const Text(
                        'Por favor, ingresa la misma contraseña nuevamente para confirmar que la has ingresado correctamente.',
                        style: TextStyle(color: Colors.grey)),
                    const SizedBox(
                      height: 80,
                    ),
                    //marca la casilla

                    CheckboxListTile(
                      title: const Text(
                          'Por favor, marca la casilla para aceptar nuestros términos y condiciones antes de continuar.',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                      controlAffinity: ListTileControlAffinity
                          .leading, // Coloca el Checkbox a la derecha
                      value: widget.checkBoxValue,
                      fillColor: MaterialStateProperty.resolveWith(
                          (states) => AppColors.textColor),
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
        Step(
          state: _currentPage > 1 ? StepState.complete : StepState.indexed,
          isActive: _currentPage >= 1,
          title: const Text('datos personales',
              style: TextStyle(color: Colors.white, fontSize: 12)),
          content: Center(
            child: SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                child: const Column(
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    //nombre
                    InputsRegister(
                        hinttxt: 'Nombre',
                        obscuretxt: false,
                        icono: Icons.person),
                    SizedBox(
                      height: 20,
                    ),
                    //apellido
                    InputsRegister(
                        hinttxt: 'Apellido',
                        obscuretxt: false,
                        icono: Icons.person),
                    SizedBox(
                      height: 20,
                    ),

                    //fecha
                    InputsRegister(
                        hinttxt: 'Fecha',
                        obscuretxt: false,
                        icono: Icons.calendar_month),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    //localidad
                    InputsRegister(
                        hinttxt: 'Localidad',
                        obscuretxt: false,
                        icono: Icons.location_on),
                    SizedBox(
                      height: 10,
                    ),

                    SizedBox(
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
          title: const Text('foto',
              style: TextStyle(color: Colors.white, fontSize: 12)),
          content: Center(
            child: SingleChildScrollView(
                child: Container(
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        image != null
                            ? CircleAvatar(
                                radius: 200,
                                backgroundImage: MemoryImage(image!),
                              )
                            : CircleAvatar(
                                radius: 200, // Ajustar el tamaño del círculo
                                backgroundImage: NetworkImage(
                                    'https://icons.iconarchive.com/icons/papirus-team/papirus-status/512/avatar-default-icon.png'),
                              ),
                        Positioned(
                          child: IconButton(
                            icon: Icon(
                              Icons.add_a_photo_rounded,
                              color: Colors.white,
                              size: 60,
                            ),
                            onPressed: () {
                              selectImage();
                            },
                          ),
                          bottom: 40, // Ajustar la posición vertical
                          right: 20, // Ajustar la posición horizontal
                        )
                      ],
                    ))),
          ),
        ),
      ];
  Uint8List? image;
  void selectImage() async {
    Uint8List img = await pickerImage(ImageSource.gallery);
    setState(() {
      image = img;
    });
  }
}
