class Frecuencia {
  final String nombre;
  static late Set<String>? diasSemana = null;
  static late Set<int>? diasMes;
  static late String? diasDespues;

  const Frecuencia._(this.nombre);

  static const CADA_DIA = Frecuencia._('Cada día');
  static const DIAS_ESPECIFICOS = Frecuencia._('Días específicos de la semana');
  static const DIAS_MES = Frecuencia._('Días específicos del mes');
  static const REPETIR = Frecuencia._('Repetir');

  static void actualizarDiasSemana(Set<String> diasSeleccionados) {
    diasSemana = diasSeleccionados;
  }

  static void actualizarDiasMes(Set<int> mesesSeleccionados) {
    diasMes = mesesSeleccionados;
  }

  static void actualizarDiasDespues(String valor) {
    diasDespues = valor;
  }
}
