import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmocionesService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<List<Map<String, dynamic>>> obtenerTodasEmociones(String idUsuario) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('emociones')
          .where('id_usuario', isEqualTo: idUsuario)
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error al obtener todas las emociones: $e');
      throw e;
    }
  }
}
