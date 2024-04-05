import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/entity/Frecuencia.dart';

class Habito {
  static late String evaluateProgress;
  static late String habitName;
  static late String? habitDescription = null;
  static late Frecuencia frequency = Frecuencia.CADA_DIA;
  static late DateTime startDate;
  static late DateTime? endDate = null;
  static late Color color;
  static late String? recordatorio;
  static late String category;
  static late IconData categoryIcon;
  static late bool isTracked;

  static void init({
    required String name,
    required String description,
    required String evaluateProgress,
    required String habitName,
    String? habitDescription,
    Frecuencia? frequency,
    required DateTime startDate,
    required DateTime endDate,
    required Color color,
    String? recordatorio,
  }) {
    Habito.habitName = name;
    Habito.evaluateProgress = evaluateProgress;
    Habito.habitName = habitName;
    Habito.habitDescription = habitDescription;
    Habito.frequency = frequency!;
    Habito.startDate = startDate;
    Habito.endDate = endDate;
    Habito.color;
    Habito.recordatorio = recordatorio;
    Habito.category;
    Habito.categoryIcon;
  }

}
