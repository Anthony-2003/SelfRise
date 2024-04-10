import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Colors/colors.dart';
import 'package:flutter_proyecto_final/Design/menu_principal.dart';
import 'package:flutter_proyecto_final/Design/podcastcontroller.dart';
import 'package:flutter_proyecto_final/data/podcast_data.dart';
import 'package:flutter_proyecto_final/components/cardwidget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class PodcastPage extends StatefulWidget {
  const PodcastPage({Key? key}) : super(key: key);

  @override
  _PodcastPageState createState() => _PodcastPageState();
}

class _PodcastPageState extends State<PodcastPage> {
  String _selectedCategory = "Motivación"; // Categoría predeterminada al inicio

  List<cardsdata> _filteredPodcasts() {
    return podcascards
        .where((podcast) => podcast.categoria == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    Future<void>? _launched;

    List<cardsdata> filteredPodcasts = _filteredPodcasts();

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
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 15),
              child: Text(
                "Podcast recomendados",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              width: 300,
              child: Divider(
                thickness: 2,
                color: AppColors
                    .textColor, // Cambiado a color gris para la división
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 110, vertical: 10),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  isExpanded: true,
                  value: _selectedCategory,
                  items: [
                    "Motivación",
                    "Salud Mental",
                    "Desarrollo Personal",
                    "Bienestar Físico"
                  ].map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Center(
                        child: Text(
                          category,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                  buttonStyleData: ButtonStyleData(
                    height: 50,
                    width: double.infinity,
                    padding: const EdgeInsets.only(left: 14, right: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.drawer,
                      ),
                      color: AppColors.drawer,
                    ),
                    elevation: 2,
                  ),
                  iconStyleData: const IconStyleData(
                    icon: Icon(
                      Icons.arrow_forward_ios_outlined,
                    ),
                    iconSize: 14,
                    iconEnabledColor: Colors.yellow,
                    iconDisabledColor: Colors.grey,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: AppColors.textColor,
                    ),
                    offset: const Offset(-0, 0),
                    scrollbarTheme: ScrollbarThemeData(
                      radius: const Radius.circular(40),
                      thickness: MaterialStateProperty.all(6),
                      thumbVisibility: MaterialStateProperty.all(true),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 40,
                    padding: EdgeInsets.only(left: 14, right: 14),
                  ),
                ),
              ),
            ),
            // Mostrar las tarjetas filtradas según la categoría seleccionada
            Expanded(
              child: ListView.builder(
                itemCount: filteredPodcasts.length,
                itemBuilder: (context, index) {
                  return CardWidget(podcast: filteredPodcasts[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
