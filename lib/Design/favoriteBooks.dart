import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Design/booksPage.dart';
import 'package:flutter_proyecto_final/Design/booksview.dart';
import 'package:provider/provider.dart';
import '../components/favorite_provider.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late Future<List<Book>> favoriteBooksFuture;

  @override
  void initState() {
    super.initState();
    favoriteBooksFuture = obtenerFavoriteBooks();
    print('aaaaa');
  }

  Future<List<Book>> obtenerFavoriteBooks() async {
    final userId = obtenerUserId();
    final favoriteProvider =
        Provider.of<FavoriteProvider>(context, listen: false);
    return favoriteProvider.getFavorites(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Libros favoritos'),
      ),
      body: FutureBuilder<List<Book>>(
        future: favoriteBooksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final List<Book> favoriteBooks = snapshot.data ?? [];
            return favoriteBooks.isEmpty
                ? Center(
                    child: Text('No tienes libros en favoritos'),
                  )
                : ListView.builder(
                    itemCount: favoriteBooks.length,
                    itemBuilder: (context, index) {
                      final Book book = favoriteBooks[index];
                      return ListTile(
                        title: Text(book.title),
                        subtitle: Text(book.subtitle),
                        onTap: () {
                          // Navegar a la vista de detalles del libro
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookViewPage(
                                imageProvider:
                                    _getImageProvider(book.thumbnailUrl),
                                title: book.title,
                                subtitle: book.subtitle,
                                authors: book.authors,
                                publisher: book.publisher,
                                publishedDate: book.publishedDate,
                                description: book.description,
                                book: book,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
          }
        },
      ),
    );
  }

  ImageProvider<Object>? _getImageProvider(String? thumbnailUrl) {
    if (thumbnailUrl != null &&
        thumbnailUrl.isNotEmpty &&
        !thumbnailUrl.startsWith('file:///')) {
      return NetworkImage(thumbnailUrl);
    } else {
      return AssetImage('assets/iconos/image-default.png');
    }
  }

  String obtenerUserId() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid ?? '';
  }
}
