import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Design/booksPage.dart';

class FavoriteProvider extends ChangeNotifier {
  List<Book> _favoriteBooks = [];
  List<Book> get favoriteBooks => _favoriteBooks;
  void ToggleFavorite(Book book) {
    final isExist = _favoriteBooks.contains(book);
    if (isExist) {
      _favoriteBooks.remove(book);
    } else {
      _favoriteBooks.add(book);
    }
    notifyFavoritesChanged();
  }

  bool isExist(Book book) {
    final isExist = _favoriteBooks.contains(book);
    return isExist;
  }

  void ClearFavorite() {
    _favoriteBooks = [];
    notifyListeners();
  }
    void notifyFavoritesChanged() {
    notifyListeners();
  }
}
