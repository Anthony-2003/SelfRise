import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Design/defineHabito.dart';

class SeleccionarCategoriaPantalla extends StatefulWidget {
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

  // Mapa para almacenar el icono seleccionado para cada categoría
  Map<String, IconData?> categoriaIconos = {
    'Meditación': Icons.access_alarm,
    'Finanzas': Icons.attach_money,
    'Artes': Icons.palette,
    'Deportes': Icons.sports_soccer
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Seleccionar una categoría para tu hábito',
          style: TextStyle(fontSize: 15),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          // Agrega padding vertical
          children: [
            for (int i = 0; i < categorias.length; i += 2)
              _buildChipRow(
                categorias[i],
                icons[i],
                i + 1 < categorias.length ? categorias[i + 1] : null,
                i + 1 < categorias.length ? icons[i + 1] : null,
              ),
            _buildChip('Crear nueva categoría', Icons.add,
                () => _showCrearCategoriaDialog(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildChipRow(
      String label1, IconData? icon1, String? label2, IconData? icon2) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: _buildChip(label1, icon1),
          ),
          SizedBox(
              width: 8.0), // Ajusta el espacio horizontal entre los elementos
          if (label2 != null && icon2 != null)
            Expanded(
              child: _buildChip(label2, icon2),
            ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, IconData? icon, [Function? onTap]) {
    return GestureDetector(
      onTap: () {
        if (label != 'Crear nueva categoría') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DefineHabitoScreen(),
            ),
          );
        } else {
          _showCrearCategoriaDialog(context); // Ejecutar la función para mostrar el diálogo de nueva categoría
        }
      },
      child: Container(
        height: 50,
        margin: EdgeInsets.symmetric(vertical: 4.0),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon ?? categoriaIconos[label]),
            SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
    );
  }

  void _showCrearCategoriaDialog(BuildContext context) async {
    String? nuevaCategoria = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String nuevaCategoriaText = '';
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Crear nueva categoría'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) => nuevaCategoriaText = value,
                    decoration: InputDecoration(
                      hintText: 'Nombre de la nueva categoría',
                    ),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<IconData>(
                    value: nuevoIcono,
                    onChanged: (value) {
                      setState(() {
                        nuevoIcono = value;
                      });
                    },
                    items: [
                      DropdownMenuItem(
                        value: Icons.access_alarm,
                        child: Icon(Icons.access_alarm),
                      ),
                      DropdownMenuItem(
                        value: Icons.attach_money,
                        child: Icon(Icons.attach_money),
                      ),
                      DropdownMenuItem(
                        value: Icons.palette,
                        child: Icon(Icons.palette),
                      ),
                      DropdownMenuItem(
                        value: Icons.sports_soccer,
                        child: Icon(Icons.sports_soccer),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(nuevaCategoriaText);
                  },
                  child: Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );

    if (nuevaCategoria != null && nuevaCategoria.isNotEmpty) {
      setState(() {
        categorias.add(nuevaCategoria);
        icons.add(nuevoIcono ??
            Icons.add); // Agregar el nuevo ícono a la lista de íconos
        categoriaIconos[nuevaCategoria] =
            nuevoIcono ?? Icons.add; // Establecer el icono por defecto
      });
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: SeleccionarCategoriaPantalla(),
  ));
}
