import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/entity/categoria.dart';

class CategoriesService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> addCategory(String userId, Categoria categoria) async {
    try {
      await _firestore.collection('categorias').add({
        'userId': userId,
        'nombre': categoria.nombre,
        'icono': categoria.icono.codePoint,
        'color': categoria.color.value,
      });
    } catch (error) {
      print('Error al guardar la categoría: $error');
      throw error;
    }
  }

  static Future<List<Categoria>> getCategoriesByUserId(String currentUserId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('categorias')
          .where('userId', isEqualTo: currentUserId)
          .get();

      List<Categoria> userCategories = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Categoria(
          nombre: data['nombre'],
          icono: IconData(data['icono'], fontFamily: 'MaterialIcons'),
          color: Color(data['color']),
        );
      }).toList();

      return userCategories;
    } catch (error) {
      print('Error al obtener las categorías del usuario: $error');
      throw error;
    }
  }
}
