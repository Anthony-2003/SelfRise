import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/entity/categoria.dart';
import 'package:flutter_proyecto_final/services/AuthService.dart';
import 'package:flutter_proyecto_final/services/categoria_services.dart';
import 'package:flutter_proyecto_final/utils/iconos_disponibles.dart';

class CrearCategoriaDialog extends StatefulWidget {
  final Map<String, Color> categoriaColores;
  final Function(String, IconData, Color) onCategoriaAdded;
  final bool showDeleteButton;
  final Categoria? categoria;

  CrearCategoriaDialog(
      {required this.categoriaColores,
      required this.onCategoriaAdded,
      this.showDeleteButton = false,
      this.categoria});

  @override
  _CrearCategoriaDialogState createState() => _CrearCategoriaDialogState();
}

class _CrearCategoriaDialogState extends State<CrearCategoriaDialog> {
  late String nuevaCategoriaText;
  late IconData nuevoIcono;
  late Color nuevoColor;

  @override
  Widget build(BuildContext context) {
    nuevaCategoriaText =
        widget.showDeleteButton ? widget.categoria!.nombre : 'Nueva categoría';
    nuevoIcono =
        widget.showDeleteButton ? widget.categoria!.icono : Icons.category;
    nuevoColor = (widget.showDeleteButton
        ? widget.categoria?.color
        : Color(0xFFBBDEFB))!;

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
                if (widget.showDeleteButton)
                  ListTile(
                    leading: Icon(Icons.delete),
                    title: Text('Eliminar categoría'),
                    onTap: () {
                      _mostrarDialogoEliminarCategoria(context);
                    },
                  ),
                if (widget.showDeleteButton) Divider(),
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
                  widget.onCategoriaAdded(nuevaCategoriaText, nuevoIcono,
                      nuevoColor); // Llamar a la función

                  Navigator.pop(context);
                }
              },
              child: widget.showDeleteButton
                  ? Text('Modificar categoría')
                  : Text('Crear categoría'),
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

  void _mostrarDialogoEliminarCategoria(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Eliminar categoría'),
          content: Text('¿Estás seguro de que deseas eliminar esta categoría?'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
            CupertinoDialogAction(
              child: Text('Eliminar'),
              onPressed: () {
                // Aquí puedes agregar la lógica para eliminar la categoría
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
          ],
        );
      },
    );
  }
}
