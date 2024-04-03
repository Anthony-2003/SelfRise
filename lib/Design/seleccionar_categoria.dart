import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/entity/Habito.dart';
import 'package:flutter_proyecto_final/services/AuthService.dart';
import 'package:flutter_proyecto_final/utils/iconos_disponibles.dart';
import 'package:flutter_proyecto_final/entity/categoria.dart';
import 'package:flutter_proyecto_final/services/categoria_services.dart';

class SeleccionarCategoriaPantalla extends StatefulWidget {
  final PageController pageController;

  SeleccionarCategoriaPantalla(this.pageController);

  @override
  _SeleccionarCategoriaPantallaState createState() =>
      _SeleccionarCategoriaPantallaState();
}

class _SeleccionarCategoriaPantallaState
    extends State<SeleccionarCategoriaPantalla> {
  List<String> categorias = ['Meditación', 'Finanzas', 'Artes', 'Deportes'];

  Map<String, IconData?> categoriaIconos = {
    'Meditación': Icons.access_alarm,
    'Finanzas': Icons.attach_money,
    'Artes': Icons.palette,
    'Deportes': Icons.sports_soccer
  };

  Map<String, Color> categoriaColores = {
    'Meditación': Color(0xFFBBDEFB), // Azul claro
    'Finanzas': Color(0xFFC8E6C9), // Verde claro
    'Artes': Color(0xFFFFE0B2), // Naranja claro
    'Deportes': Color(0xFFFFCCBC), // Rosa claro
    'Tecnología': Color(0xFFD1C4E9), // Púrpura claro
    'Cocina': Color(0xFFFFD180), // Naranja claro
    'Moda': Color(0xFFFFAB91), // Rojo anaranjado claro
    'Viajes': Color(0xFFB2DFDB), // Turquesa claro
    'Educación': Color(0xFFB39DDB), // Púrpura claro
    'Salud': Color(0xFF81C784), // Verde claro
    'Música': Color(0xFF90CAF9), // Azul claro
    'Entretenimiento': Color(0xFFCE93D8), // Violeta claro
  };

  List<Widget> categoriaChips = [];
  List<String> categoriasUsuario =
      []; 

  @override
  void initState() {
    super.initState();
      _subscribeToCategoryChanges();
    _initializeCategoriaChips();
  }

  void _updateCategoriaChipsList() {
    List<String> todasCategorias = [
      ...categorias,
      ...categoriasUsuario
    ]; // Fusionar las categorías
    setState(() {
      categoriaChips.clear(); // Limpiar los chips de categoría
      for (String categoria in todasCategorias) {
        categoriaChips.add(_buildChip(categoria, categoriaIconos[categoria],
            categoriaColores[categoria]!));
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
          categoriasUsuario
              .clear(); 
          for (Categoria categoria in userCategories) {
            categoriasUsuario.add(
                categoria.nombre); 
          }
          _updateCategoriaChipsList();
        });
      } catch (error) {
        print('Error al obtener las categorías del usuario: $error');
      }
    }
  }

  void _initializeCategoriaChips() {
    categoriaChips.clear();
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

  void _showCrearCategoriaDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => CrearCategoriaDialog(
        categoriaColores: categoriaColores,
        agregarCategoria: _agregarCategoria,
      ),
    );
  }

  void _agregarCategoria(
      String nuevaCategoriaText, IconData nuevoIcono, Color nuevoColor) {
    setState(() {
      categorias.add(nuevaCategoriaText);
      categoriaIconos[nuevaCategoriaText] = nuevoIcono;
      categoriaColores[nuevaCategoriaText] = nuevoColor;
      _updateCategoriaChips(nuevaCategoriaText, nuevoIcono);
    });
    _subscribeToCategoryChanges();
  }

  void _updateCategoriaChips(String categoria, IconData icono) {
    setState(() {
      categoriaChips.add(_buildChip(categoria, icono, Colors.red));
    });
  }
}

class CrearCategoriaDialog extends StatefulWidget {
  final Map<String, Color> categoriaColores;
  final Function(String, IconData, Color) agregarCategoria;

  CrearCategoriaDialog({
    required this.categoriaColores,
    required this.agregarCategoria,
  });

  @override
  _CrearCategoriaDialogState createState() => _CrearCategoriaDialogState();
}

class _CrearCategoriaDialogState extends State<CrearCategoriaDialog> {
  String nuevaCategoriaText = 'Nueva categoría';
  IconData nuevoIcono = Icons.category;
  Color nuevoColor = Color(0xFFBBDEFB);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2),
                    child: Icon(
                      Icons.circle,
                      size: 20,
                      color: nuevoColor,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    nuevaCategoriaText,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: nuevoColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  nuevoIcono,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(),
                ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Nombre de la categoría'),
                  onTap: () {
                    _mostrarDialogoNombreCategoria(
                      context,
                      (nuevoNombreCategoria) {
                        setState(() {
                          nuevaCategoriaText = nuevoNombreCategoria!;
                        });
                      },
                    );
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.image),
                  title: Text('Icono de la categoría'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Selecciona un icono'),
                          content: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: GridView.count(
                              crossAxisCount: 4,
                              children: iconosDisponibles.map((icono) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      nuevoIcono = icono;
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: nuevoIcono == icono
                                          ? Colors.grey.withOpacity(0.5)
                                          : null,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(icono, size: 40),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.color_lens),
                  title: Text('Color de la categoría'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Selecciona un color'),
                          content: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: widget.categoriaColores.entries
                                  .take(12)
                                  .map((entry) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      nuevoColor = entry.value;
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: entry.value,
                                      shape: BoxShape.circle,
                                    ),
                                    child: nuevoColor == entry.value
                                        ? Icon(Icons.check, color: Colors.white)
                                        : null,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                Divider(),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (nuevaCategoriaText.isNotEmpty &&
                    !widget.categoriaColores.containsKey(nuevaCategoriaText)) {
                  Categoria nuevaCategoria = Categoria(
                    nombre: nuevaCategoriaText,
                    icono: nuevoIcono,
                    color: nuevoColor,
                  );

                  final String? currentUserId = AuthService.getUserId();

                  CategoriesService.addCategory(currentUserId!, nuevaCategoria);
                  Navigator.pop(context);
                }
              },
              child: Text('Crear categoría'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarDialogoNombreCategoria(
      BuildContext context, Function(String?) onChanged) {
    String? nuevoNombreCategoria;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Nombre de la categoría'),
          content: TextField(
            onChanged: (value) {
              nuevoNombreCategoria = value;
            },
            decoration: InputDecoration(
              hintText: 'Ingresa el nombre',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (nuevoNombreCategoria != null &&
                    nuevoNombreCategoria!.isNotEmpty) {
                  onChanged(nuevoNombreCategoria);
                  Navigator.pop(context, nuevoNombreCategoria);
                }
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}
