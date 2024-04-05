import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/entity/Frecuencia.dart';

class HabitosService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> guardarHabito(
      String? userId,
      String categoria,
      IconData iconoCategoria,
      String nombreHabito,
      String evaluarProgreso,
      Frecuencia frecuenciaHabito,
      dynamic frecuenciaValor,
      DateTime fechaInicio,
      DateTime? fechaFinal,
      bool estaCompletado,
      Color color,
      [String? descripcionHabito = '']) async {
    try {
      await FirebaseFirestore.instance.collection('habitos').add({
        'userId': userId,
        'categoria': categoria,
        'iconoCategoria': iconoCategoria.codePoint,
        'nombreHabito': nombreHabito,
        'evaluarProgreso': evaluarProgreso,
        'descripcionHabito': descripcionHabito,
        'frecuenciaHabito': frecuenciaHabito.nombre,
        'color': color.value,
        'valorFrecuencia': frecuenciaValor,
        'fechaInicio': fechaInicio,
        'fechaFinal': fechaFinal,
        'completado': estaCompletado
      });
      print('Hábito guardado en Firestore correctamente.');
    } catch (e) {
      print('Error al guardar el hábito en Firestore: $e');
      throw e;
    }
  }

  Future<List<Map<String, dynamic>>> obtenerHabitos(String userId) async {
    try {
      QuerySnapshot habitosSnapshot = await FirebaseFirestore.instance
          .collection('habitos')
          .where('userId', isEqualTo: userId)
          .get();

      List<Map<String, dynamic>> habitos = habitosSnapshot.docs
          .map((doc) => {...doc.data() as Map<String, dynamic>, 'id': doc.id})
          .toList();

      return habitos;
    } catch (e) {
      print('Error al obtener los hábitos: $e');
      throw e;
    }
  }

  Future<void> actualizarEstadoHabito(String habitId, bool completado) async {
    try {
      // Obtener la referencia al documento del hábito
      DocumentReference habitRef =
          _firestore.collection('habitos').doc(habitId);

      // Actualizar el campo 'completado' del documento
      await habitRef.update({
        'completado': completado,
      });
    } catch (e) {
      // Manejar cualquier error que ocurra durante la actualización
      throw Exception('Error al actualizar el estado del hábito: $e');
    }
  }
}
