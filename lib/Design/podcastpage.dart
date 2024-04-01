import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Colors/colors.dart';
import 'package:flutter_proyecto_final/Design/menu_principal.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_proyecto_final/Design/podcastcontroller.dart';
import 'package:flutter_proyecto_final/Design/podcastinfoview.dart';
import 'package:flutter_proyecto_final/data/podcast_data.dart';

class PodcastPage extends StatefulWidget {
  const PodcastPage({Key? key}) : super(key: key);

  @override
  _PodcastPageState createState() => _PodcastPageState();
}

class _PodcastPageState extends State<PodcastPage> {
  @override
  Widget build(BuildContext context) {
    // Filtrar los elementos de la lista según su ID
    List<cards> motivacionList =
        carousel.where((element) => element.categoria == "motivacion").toList();
    List<cards> saludMentalList = carousel
        .where((element) => element.categoria == "salud-mental")
        .toList();
    List<cards> DesarrolloPersonalList = carousel
        .where((element) => element.categoria == "DesarrolloPersonal")
        .toList();
    List<cards> BienestarFisicolList = carousel
        .where((element) => element.categoria == "BienestarFisico")
        .toList();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.textColor,
          automaticallyImplyLeading: false,
          title: Text(
            'Podcasts',
            style: TextStyle(
                color: AppColors.appcolor,
                fontWeight: FontWeight.bold,
                fontSize: 25,
                fontFamily: AutofillHints.sublocality),
          ),
          centerTitle: true,
          // Agregamos un IconButton en la AppBar para la flecha de regreso
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.appcolor,
            ), // Icono de flecha hacia atrás
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PantallaMenuPrincipal(), // Aquí se crea la instancia de BookListScreen
                ),
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              // Agrega aquí el contenido de la página de podcast
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: 30,
                  ),
                  child: Text(
                    'Podcast recomendados',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: AutofillHints.sublocality),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width *
                      0.8, // Por ejemplo, el 80% del ancho de la pantalla
                  child: Divider(
                    color: AppColors.textColor,
                    thickness: 1.0,
                    height: 20.0,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 40, bottom: 5),
                  child: Text(
                    'MOTIVACION',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: AutofillHints.sublocality),
                  ),
                ),
                // ****** CARRUSEL MOTIVACION *****
                Container(
                  color: AppColors.textColor,
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.only(top: 50, bottom: 50),
                  child: CarouselSlider.builder(
                      itemCount: motivacionList.length,
                      itemBuilder: (context, index, realIndex) {
                        final carruselImage = carousel[index];
                        return cardImages(
                          card: motivacionList[index],
                        );
                      },
                      options: CarouselOptions(
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.8,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 6),
                        pauseAutoPlayOnTouch: true,
                        enableInfiniteScroll: true,
                        enlargeCenterPage: true,
                      )),
                ),
                Container(
                  margin: EdgeInsets.only(top: 40, bottom: 5),
                  child: Text(
                    'SALUD MENTAL',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: AutofillHints.sublocality),
                  ),
                ),
                // ****** CARRUSEL SALUD MENTAL *****
                Container(
                  color: AppColors.textColor,
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.only(top: 50, bottom: 50),
                  child: CarouselSlider.builder(
                      itemCount: saludMentalList.length,
                      itemBuilder: (context, index, realIndex) {
                        final carruselImage = carousel[index];
                        return cardImages(
                          card: saludMentalList[index],
                        );
                      },
                      options: CarouselOptions(
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.8,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 6),
                        pauseAutoPlayOnTouch: true,
                        enableInfiniteScroll: true,
                        enlargeCenterPage: true,
                      )),
                ),
                Container(
                  margin: EdgeInsets.only(top: 40, bottom: 5),
                  child: Text(
                    'DESARROLLO PERSONAL',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: AutofillHints.sublocality),
                  ),
                ),
                // ****** CARRUSEL DESARROLLO PERSONAL *****
                Container(
                  color: AppColors.textColor,
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.only(top: 50, bottom: 50),
                  child: CarouselSlider.builder(
                      itemCount: DesarrolloPersonalList.length,
                      itemBuilder: (context, index, realIndex) {
                        final carruselImage = carousel[index];
                        return cardImages(
                          card: DesarrolloPersonalList[index],
                        );
                      },
                      options: CarouselOptions(
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.8,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 6),
                        pauseAutoPlayOnTouch: true,
                        enableInfiniteScroll: true,
                        enlargeCenterPage: true,
                      )),
                ),
                Container(
                  margin: EdgeInsets.only(top: 40, bottom: 5),
                  child: Text(
                    'BIENESTAR FISICO',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: AutofillHints.sublocality),
                  ),
                ),
                // ****** CARRUSEL BIENESTAR FISICO *****
                Container(
                  color: AppColors.textColor,
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.only(top: 50, bottom: 50),
                  child: CarouselSlider.builder(
                      itemCount: BienestarFisicolList.length,
                      itemBuilder: (context, index, realIndex) {
                        final carruselImage = carousel[index];
                        return cardImages(
                          card: BienestarFisicolList[index],
                        );
                      },
                      options: CarouselOptions(
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.8,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 6),
                        pauseAutoPlayOnTouch: true,
                        enableInfiniteScroll: true,
                        enlargeCenterPage: true,
                      )),
                ),
              ],
            ),
          ),
        ));
  }
}

class cardImages extends StatelessWidget {
  final cards card;
  const cardImages({
    Key? key,
    required this.card,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () {
            card.copy();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => infopodcast(
                          carousel: card,
                        )));
          },
          child: FadeInImage(
            placeholder: AssetImage("assets/podcast-carousel/loading.gif"),
            image: AssetImage(
              card.image,
            ),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
