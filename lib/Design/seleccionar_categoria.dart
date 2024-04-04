import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/entity/Habito.dart';
import 'package:flutter_proyecto_final/services/AuthService.dart';
import 'package:flutter_proyecto_final/dialogs/crear_categoria_dialog.dart';
import 'package:flutter_proyecto_final/entity/categoria.dart';
import 'package:flutter_proyecto_final/services/categoria_services.dart';
import 'package:flutter_proyecto_final/const/colores_categorias.dart';
import 'package:flutter_proyecto_final/const/iconos_por_defecto.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SeleccionarCategoriaPantalla extends StatefulWidget {
  final PageController pageController;

  SeleccionarCategoriaPantalla(this.pageController);

  @override
  _SeleccionarCategoriaPantallaState createState() =>
      _SeleccionarCategoriaPantallaState();
}

class _SeleccionarCategoriaPantallaState
    extends State<SeleccionarCategoriaPantalla> {
  List<Widget> categoriaChips = [];
  List<String> categoriasUsuario = [];
  List<String> categorias = ['Meditación', 'Finanzas', 'Artes', 'Deportes'];
  List<String> categoriasNoPermitidas = [
    'Meditación',
    'Finanzas',
    'Artes',
    'Deportes',
    'Crear nueva categoría'
  ];

  @override
  void initState() {
    super.initState();
    _initializeCategoriaChips();
    _subscribeToCategoryChanges();
  }

  void _updateCategoriaChipsList() {
    setState(() {
      for (String categoria in categoriasUsuario) {
        if (!categoriaChips.any((chip) => chip.key.toString() == categoria)) {
          categoriaChips.add(_buildChip(
            categoria,
            categoriaIconos[categoria],
            categoriaColores[categoria]!,
          ));
        }
      }
    });
  }

  void _subscribeToCategoryChanges() async {
    final String? currentUserId = AuthService.getUserId();
    if (currentUserId != null) {
      try {
        List<Categoria> userCategories =
            await CategoriesService.getCategoriesByUserId(currentUserId);
        setState(() {
          for (Categoria categoria in userCategories) {
            categoriaChips.add(_buildChip(
              categoria.nombre,
              categoria.icono,
              categoria.color,
            ));
          }
        });
        _updateCategoriaChipsList();
      } catch (error) {
        print('Error al obtener las categorías del usuario: $error');
      }
    }
  }

  void _initializeCategoriaChips() {
    for (String categoria in categorias) {
      categoriaChips.add(_buildChip(
          categoria, categoriaIconos[categoria], categoriaColores[categoria]!));
    }
    print(categoriaChips);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          margin: EdgeInsets.only(top: 70.0),
          child: Stack(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Selecciona una categoría para tu hábito',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          for (int i = 0; i < categoriaChips.length; i += 2)
                            _buildChipRow(
                                categoriaChips[i],
                                i + 1 < categoriaChips.length
                                    ? categoriaChips[i + 1]
                                    : null),
                          _buildChip(
                              'Crear nueva categoría',
                              Icons.add,
                              Colors.transparent,
                              () => _showCrearCategoriaDialog(context)),
                        ],
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

  Widget _buildChipRow(Widget chip1, [Widget? chip2]) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: chip1,
          ),
          if (chip2 != null) SizedBox(width: 8.0),
          if (chip2 != null) Expanded(child: chip2),
        ],
      ),
    );
  }

  Widget _buildChip(String label, IconData? icon, Color color,
      [Function? onTap]) {
    return GestureDetector(
      onTap: () {
        if (label != 'Crear nueva categoría') {
          setState(() {
            Habito.category = label;
            Habito.categoryIcon = (icon ?? categoriaIconos[label])!;
            widget.pageController.animateToPage(1,
                duration: Duration(milliseconds: 300), curve: Curves.ease);
          });
        } else {
          _showCrearCategoriaDialog(context);
        }
      },
      onLongPress: () {
        if (categoriasNoPermitidas.contains(label)) {
          // Muestra el toast indicando que la categoría por defecto no puede modificarse
          Fluttertoast.showToast(
            msg: "Las categorías por defecto no pueden modificarse",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black,
            textColor: Colors.white,
          );
        } else {
          // Si no está en la lista de categorías no permitidas, puedes ejecutar la función para editar la categoría
          IconData iconoAUsar = icon ?? Icons.category;

          Categoria categoriaAEditar = Categoria(
            nombre: label,
            icono: iconoAUsar,
            color: color,
          );

          _showCrearCategoriaDialog(context,
              showDeleteButton: true, categoria: categoriaAEditar);
        }
      },
      child: Container(
        height: 50,
        margin: EdgeInsets.symmetric(vertical: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: color, // Utiliza el color de fondo del icono
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon ??
                    Icons.category, // Usa el icono predeterminado si es nulo
                color: Colors.black,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  label,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCrearCategoriaDialog(BuildContext context,
      {Categoria? categoria, bool showDeleteButton = false}) async {
    showDialog(
      context: context,
      builder: (context) => CrearCategoriaDialog(
        categoriaColores: categoriaColores,
        onCategoriaAdded: _agregarCategoria,
        showDeleteButton: showDeleteButton,
        categoria: categoria,
      ),
    );
  }

  void _agregarCategoria(
      String nuevaCategoriaText, IconData nuevoIcono, Color nuevoColor) {
    setState(() {
      categorias.add(nuevaCategoriaText);
      categoriaIconos[nuevaCategoriaText] = nuevoIcono;
      categoriaColores[nuevaCategoriaText] = nuevoColor;
      _updateCategoriaChipsList();
      categoriaChips.add(_buildChip(
        nuevaCategoriaText,
        nuevoIcono,
        nuevoColor,
      ));
    });
  }
}
