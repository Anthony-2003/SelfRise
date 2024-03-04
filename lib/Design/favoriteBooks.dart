import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Design/booksPage.dart';
import 'package:provider/provider.dart';

import '../components/favorite_provider.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  ImageProvider<Object>? _getImageProvider(String? thumbnailUrl) {
    if (thumbnailUrl != null &&
        thumbnailUrl.isNotEmpty &&
        !thumbnailUrl.startsWith('file:///')) {
      return NetworkImage(thumbnailUrl);
    } else {
      return AssetImage('assets/iconos/image-default.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavoriteProvider>(context);
    final favoriteBooks = provider.favoriteBooks;
    return Scaffold(
      appBar: AppBar(
        title: Text('Libros favoritos'),
      ),
      body: favoriteBooks.isEmpty
          ? Center(
              child: Text('No tienes libros en favoritos'),
            )
          : ListView.builder(
              itemCount: favoriteBooks.length,
              itemBuilder: (context, index) {
                final Book book = favoriteBooks[index];
                return Container(
                  width: double.infinity,
                  height: 140.0,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 8.0),
                          width: 100.0,
                          height: 120.0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image(
                              image: _getImageProvider(book.thumbnailUrl)!,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                book.title,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                book.authors.join(', '),
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 10.0),
                          child: GestureDetector(
                            onTap: () {
                              provider.ToggleFavorite(book);
                            },
                            child: Icon(
                              Icons.delete,
                              size: 32,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
