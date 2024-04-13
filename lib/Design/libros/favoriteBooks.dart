
import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Design/libros/booksPage.dart';
import 'package:flutter_proyecto_final/Design/libros/booksview.dart';
import 'package:flutter_proyecto_final/components/imageprovider.dart';
import 'package:flutter_proyecto_final/entity/AuthService.dart';
import 'package:provider/provider.dart';
import '../../components/favorite_provider.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late Future<List<Book>> favoriteBooksFuture;
  String? userId;

  @override
  void initState() {
    super.initState();
    favoriteBooksFuture = obtenerFavoriteBooks();
    userId = AuthService.getUserId();
    if (userId != null) {
      favoriteBooksFuture = obtenerFavoriteBooks();
      Provider.of<FavoriteProvider>(context, listen: false)
          .loadFavoriteBookIds(userId!);
    } else {
      print('es null');
    }
    Provider.of<FavoriteProvider>(context, listen: false)
        .loadFavoriteBookIds(userId!);
  }

  Future<List<Book>> obtenerFavoriteBooks() async {
    if (userId!.isEmpty) {
      return [];
    }
    final favoriteProvider =
        Provider.of<FavoriteProvider>(context, listen: false);
    return await favoriteProvider.getFavorites(userId);
  }

  @override
  @override
  Widget build(BuildContext context) {
    final userId = AuthService.getUserId();
    if (userId == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Libros favoritos')),
        body: Center(child: Text('Usuario no identificado')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Libros favoritos'),
      ),
      body: Consumer<FavoriteProvider>(
        builder: (context, favoriteProvider, child) {
          return StreamBuilder<List<Book>>(
            stream: favoriteProvider.streamFavorites(userId),
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
                          bool isFavorite =
                              favoriteProvider.isFavorite(book.id);
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookViewPage(
                                    imageProvider: ImageUtils.getImageProvider(
                                        book.thumbnailUrl),
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
                            child: SizedBox(
                              width: double.infinity,
                              height: 140.0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Container(
                                        width: 100.0,
                                        height: 120.0,
                                        color: Colors.grey[300],
                                        child: Image(
                                          image: ImageUtils.getImageProvider(
                                              book.thumbnailUrl),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            book.title,
                                            style: const TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            book.subtitle,
                                            style:
                                                const TextStyle(fontSize: 14.0),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 8.0),
                                          Text(
                                            '- ${book.authors.join(',')}',
                                            style:
                                                const TextStyle(fontSize: 12.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        favoriteProvider.toggleFavorite(
                                            book, userId);
                                      },
                                      child: Icon(
                                        isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: isFavorite ? Colors.red : null,
                                        size: 32,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
              }
            },
          );
        },
      ),
    );
  }
}
