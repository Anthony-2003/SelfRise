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
      int meta,
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
        'meta': meta,
        'metaUsuario': 0,
        'completado': estaCompletado
      });
      print('Hábito guardado en Firestore correctamente.');
    } catch (e) {
      print('Error al guardar el hábito en Firestore: $e');
      throw e;
    }
  }

  Future<void> actualizarMetaUsuario(
      String habitId, int nuevaMetaUsuario) async {
    try {
      // Obtener la referencia al documento del hábito
      DocumentReference habitRef =
          _firestore.collection('habitos').doc(habitId);

      // Actualizar el campo 'metaUsuario' del documento
      await habitRef.update({
        'metaUsuario': nuevaMetaUsuario,
      });
    } catch (e) {
      // Manejar cualquier error que ocurra durante la actualización
      throw Exception('Error al actualizar la metaUsuario del hábito: $e');
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

      // Si el hábito se marca como completado, guardar un registro de hábito completado
      if (completado) {
        await guardarRegistroHabitoCompletado(habitId);
      }
    } catch (e) {
      // Manejar cualquier error que ocurra durante la actualización
      throw Exception('Error al actualizar el estado del hábito: $e');
    }
  }

  Future<void> guardarRegistroHabitoCompletado(String habitId) async {
    try {
      // Obtener información del hábito completado
      Map<String, dynamic> habito = await obtenerHabitoPorId(habitId);

      // Crear un registro de hábito completado
      await _firestore.collection('registrosHabitosCompletados').add({
        'userId': habito['userId'],
        'habitId': habitId,
        'fechaCompletado': DateTime.now(),
        
        // Otros campos necesarios, como el nombre del hábito, categoría, etc.
      });
      print(
          'Registro de hábito completado guardado en Firestore correctamente.');
    } catch (e) {
      print(
          'Error al guardar el registro de hábito completado en Firestore: $e');
      throw e;
    }
  }

  Future<List<Map<String, dynamic>>> obtenerHabitosCompletadosEnFecha(
      DateTime selectedDate) async {
    try {
      QuerySnapshot registrosSnapshot = await _firestore
          .collection('registrosHabitosCompletados')
          .where('fechaCompletado', isEqualTo: selectedDate)
          .get();

      List<Map<String, dynamic>> registros = registrosSnapshot.docs
          .map((doc) => {...doc.data() as Map<String, dynamic>, 'id': doc.id})
          .toList();

      return registros;
    } catch (e) {
      print(
          'Error al obtener los hábitos completados en la fecha seleccionada: $e');
      throw e;
    }
  }

  // Método para obtener un hábito por su ID
  Future<Map<String, dynamic>> obtenerHabitoPorId(String habitId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('habitos').doc(habitId).get();
      return {...doc.data() as Map<String, dynamic>, 'id': doc.id};
    } catch (e) {
      print('Error al obtener el hábito por ID: $e');
      throw e;
    }
  }

  Future<int> obtenerHabitoPorDefault(String habitId, DateTime currentDate,
      [int valor = 0]) async {
    try {
      final DocumentSnapshot valorHabito =
          await _firestore.collection('habito_progreso').doc(habitId).get();

      return valorHabito.get('valor') as int;
    } catch (e) {
      print('Error al obtener los hábitos: $e');
    }

    return valor;
  } 
}