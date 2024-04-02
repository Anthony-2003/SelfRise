import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/entity/Habito.dart';
import 'package:flutter_proyecto_final/utils/iconos_disponibles.dart';

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
  List<IconData?> icons = [
    Icons.access_alarm,
    Icons.attach_money,
    Icons.palette,
    Icons.sports_soccer
  ];

  IconData? nuevoIcono = Icons.access_alarm;

  Map<String, IconData?> categoriaIconos = {
    'Meditación': Icons.access_alarm,
    'Finanzas': Icons.attach_money,
    'Artes': Icons.palette,
    'Deportes': Icons.sports_soccer
  };

  Map<String, Color> categoriaColores = {
    'Meditación': Colors.blue.withOpacity(0.8),
    'Finanzas': Colors.green.withOpacity(0.8),
    'Artes': Colors.orange.withOpacity(0.8),
    'Deportes': Colors.red.withOpacity(0.8),
    'Tecnología': Colors.purple.withOpacity(0.8),
    'Cocina': Colors.amber.withOpacity(0.8),
    'Moda': Colors.pink.withOpacity(0.8),
    'Viajes': Colors.teal.withOpacity(0.8),
    'Educación': Colors.indigo.withOpacity(0.8),
    'Salud': Colors.deepOrange.withOpacity(0.8),
    'Música': Colors.blueAccent.withOpacity(0.8),
    'Entretenimiento': Colors.cyan.withOpacity(0.8),
  };

  List<Widget> categoriaChips = []; // Lista de chips de categoría

  @override
  void initState() {
    super.initState();
    // Inicializa la lista de chips de categoría con las categorías existentes
    _initializeCategoriaChips();
  }

  void _initializeCategoriaChips() {
    categoriaChips.clear();
    for (String categoria in categorias) {
      categoriaChips.add(_buildChip(categoria, categoriaIconos[categoria]));
    }
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
                          _buildChip('Crear nueva categoría', Icons.add,
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

  Widget _buildChip(String label, IconData? icon, [Function? onTap]) {
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
                color: categoriaColores[label],
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon ?? categoriaIconos[label],
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
    String? nuevaCategoriaText;
    IconData? nuevoIcono;
    Color? nuevoColor;
    IconData? iconoSeleccionado;
    String tituloDialogo = 'Nueva categoría';

    showDialog(
      context: context,
      builder: (context) {
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
                          size: 15,
                          color: nuevoColor ?? Colors.grey,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        tituloDialogo,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: nuevoColor ?? Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      iconoSeleccionado ?? Icons.category,
                      color: Colors.black,
                    ),
                  )
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
                        _mostrarDialogoNombreCategoria(context,
                            (nuevoNombreCategoria) {
                          setState(() {
                            nuevaCategoriaText = nuevoNombreCategoria;
                            tituloDialogo = '$nuevaCategoriaText';
                          });
                        });
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
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                child: GridView.count(
                                  crossAxisCount: 4,
                                  children: iconosDisponibles.map((icono) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          nuevoIcono = icono;
                                          iconoSeleccionado =
                                              icono; // Actualiza el icono seleccionado
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
                                  children: [
                                    for (Color color in categoriaColores.values)
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            nuevoColor = color;
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: color,
                                            shape: BoxShape.circle,
                                          ),
                                          child: nuevoColor == color
                                              ? Icon(Icons.check,
                                                  color: Colors.white)
                                              : null,
                                        ),
                                      ),
                                  ],
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
                    if (nuevaCategoriaText != null &&
                        nuevaCategoriaText!.isNotEmpty &&
                        nuevoIcono != null &&
                        nuevoColor != null) {
                      setState(() {
                        categorias.add(nuevaCategoriaText!);
                        categoriaIconos[nuevaCategoriaText!] = nuevoIcono;
                        categoriaColores[nuevaCategoriaText!] = nuevoColor!;

                        // Agregar el nuevo chip de categoría
                        Widget nuevoChip =
                            _buildChip(nuevaCategoriaText!, nuevoIcono);
                        categoriaChips.add(nuevoChip);

                        // Actualizar la lista de chips de categoría
                        _initializeCategoriaChips();
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Crear categoría'),
                ),
              ],
            );
          },
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
