import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_proyecto_final/Design/booksPage.dart';

class FavoriteProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FavoriteProvider();

  void toggleFavorite(Book book, String? userId) async {
    if (userId == null) {
      print("Error: userId es null");
      return;
    }
    try {
      final documentReference = _firestore
          .collection('favorites')
          .doc(userId)
          .collection('books')
          .doc(book.id);

      final documentSnapshot = await documentReference.get();

      if (documentSnapshot.exists) {
        await documentReference.delete();
      } else {
        await documentReference.set(book.toJson());
      }
      notifyListeners();
    } catch (error) {
      print('Error toggling favorite: $error');
    }
  }

  Future<List<Book>> getFavorites(String? userId) async {
  if (userId == null) {
    print("Error: userId es null");
    return [];
  }
  try {
    final querySnapshot = await _firestore
        .collection('favorites')
        .doc(userId)
        .collection('books')
        .get();

    final List<Book> favorites = [];

    if (querySnapshot.docs.isNotEmpty) {
      favorites.addAll(querySnapshot.docs
          .map((doc) => Book.fromJson(doc.data() as Map<String, dynamic>))
          .toList());
    }
    print(favorites.length);
    return favorites;
  } catch (error) {
    print('Error getting favorites: $error');
    return [];
  }
}


  Future<void> clearFavorites(String? userId) async {
    if (userId == null) {
      print("Error: userId es null");
      return;
    }
    try {
      final querySnapshot = _firestore
          .collection('favorites')
          .doc(userId)
          .collection('books')
          .get();

      for (var doc in (await querySnapshot).docs) {
        await doc.reference.delete();
      }
      notifyListeners();
    } catch (error) {
      print('Error clearing favorites: $error');
    }
  }
}
