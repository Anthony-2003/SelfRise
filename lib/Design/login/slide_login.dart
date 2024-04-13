import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/components/mySlides.dart';

class SlideLogin extends StatefulWidget {
  const SlideLogin({Key? key}) : super(key: key);

  @override
  State<SlideLogin> createState() => _SlideLoginState();
}

class _SlideLoginState extends State<SlideLogin> {
  int currentPage = 0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controller,
            onPageChanged: (int page) {
              setState(() {
                currentPage = page;
              });
            },
            children: [
              buildSlide(
                context,
                'assets/imagenes/slide 1.png',
                '¡Hola! Bienvenido a SelfRaise, tu compañero para la mejora mental y física. Aquí encontrarás herramientas y técnicas para cuidar tu bienestar emocional.',
                withButtons: false,
              ),
              buildSlide(
                context,
                'assets/imagenes/slide 2.png',
                'Descubre la tranquilidad y la paz mental a través de nuestras meditaciones guiadas. Encuentra un momento para ti y sumérgete en la serenidad del presente.',
                withButtons: false,
              ),
              buildSlide(
                context,
                'assets/imagenes/slide 3.png',
                'Aprende técnicas de respiración que te ayudarán a reducir el estrés y a encontrar el equilibrio en tu vida diaria. Descubre el poder de la respiración consciente para calmar tu mente y revitalizar tu cuerpo.',
                withButtons: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
