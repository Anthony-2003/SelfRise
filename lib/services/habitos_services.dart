import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/entity/Frecuencia.dart';

class HabitosService {
  /// Guarda un hábito en Firestore.
  ///
  /// [categoria]: La categoría del hábito.
  /// [iconoCategoria]: El icono asociado a la categoría del hábito.
  /// [habito]: El nombre del hábito.
  /// [descripcion]: La descripción del hábito.
  /// [evaluarProgreso]: El método para evaluar el progreso del hábito.
  /// [nombreHabito]: El nombre del hábito.
  /// [descripcionHabito]: La descripción del hábito (opcional).
  /// [frecuenciaHabito]: La frecuencia del hábito.
  Future<void> guardarHabito(
    String categoria,
    IconData iconoCategoria,
    String nombreHabito,
    String evaluarProgreso,
    Frecuencia frecuenciaHabito,
    dynamic frecuenciaValor,
    DateTime fechaInicio,
    DateTime? fechaFinal,
   [String? descripcionHabito = '']
  ) async {
    try {
      await FirebaseFirestore.instance.collection('habitos').add({
        'categoria': categoria,
        'iconoCategoria': iconoCategoria.codePoint,
        'nombreHabito': nombreHabito,
        'evaluarProgreso': evaluarProgreso,
        'descripcionHabito': descripcionHabito,
        'frecuenciaHabito': frecuenciaHabito.nombre,
        'valorFrecuencia': frecuenciaValor,
        'fechaInicio': fechaInicio,
        'fechaFinal': fechaFinal
      });
      print('Hábito guardado en Firestore correctamente.');
    } catch (e) {
      print('Error al guardar el hábito en Firestore: $e');
      throw e; 
    }
  }
}
