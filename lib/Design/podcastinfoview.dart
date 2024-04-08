import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Design/podcastcontroller.dart';
import 'package:flutter_proyecto_final/Design/podcastpage.dart';
import 'package:flutter_proyecto_final/Colors/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class infopodcast extends StatelessWidget {
  final cards carousel;

  const infopodcast({
    Key? key,
    required this.carousel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void>? _launched;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.textColor,
        centerTitle: true,
        title: Text(
          carousel.autor,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.appcolor,
              fontSize: 25),
        ),
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
                    PodcastPage(), // Aquí se crea la instancia de BookListScreen
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 50, bottom: 20, left: 15, right: 15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder:
                      AssetImage("assets/podcast-carousel/loading.gif"),
                  image: AssetImage(carousel.image),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 10, left: 15, right: 15),
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  carousel.name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: AppColors.textColor),
                ),
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                width: MediaQuery.of(context).size.width *
                    0.7, // Por ejemplo, el 80% del ancho de la pantalla
                child: Divider(
                  color: AppColors.textColor,
                  thickness: 1.0,
                  height: 20.0,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 2, left: 20, right: 20),
              child: Text(
                "Descripcion:",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 2, bottom: 15, left: 20, right: 20),
              child: Text(
                carousel.description,
                style: TextStyle(fontSize: 15),
              ),
            ),
            // ***** BOTON VER AQUI *****
            Container(
              margin: EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 20),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    _launched = _launchInBrowser(carousel.link);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.textColor,
                      shadowColor: AppColors.darkGray),
                  child: Text(
                    'Ver aquí',
                    style: TextStyle(
                        color: AppColors.appcolor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
            // ***** FIN *****
          ],
        ),
      ),
    );
  }

  Future<void> _launchInBrowser(String url) async {
    if (!await launch(
      url,
      forceSafariVC: true,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    )) {
      throw 'Could not launch $url';
    }
  }
}
