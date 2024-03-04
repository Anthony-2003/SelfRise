import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Design/booksview.dart';
import 'package:flutter_proyecto_final/Design/menu_principal.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import '../components/favorite_provider.dart';
import 'booksController.dart';
import 'favoriteBooks.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({Key? key}) : super(key: key);

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

ImageProvider<Object> _getImageProvider(String? thumbnailUrl) {
  if (thumbnailUrl != null &&
      thumbnailUrl.isNotEmpty &&
      !thumbnailUrl.startsWith('file:///')) {
    return NetworkImage(thumbnailUrl);
  } else {
    return AssetImage('assets/iconos/image-default.png');
  }
}

class Book {
  final String title;
  final String subtitle;
  final List<String> authors;
  final String thumbnailUrl;
  final String publisher;
  final String publishedDate;
  final String description;

  Book({
    required this.title,
    required this.authors,
    required this.thumbnailUrl,
    required this.subtitle,
    required this.description,
    required this.publisher,
    required this.publishedDate,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'];
    final title = volumeInfo['title'];
    final subtitle = volumeInfo['subtitle'] ?? '';
    final authors = volumeInfo['authors'] != null
        ? List<String>.from(volumeInfo['authors'])
        : ['Unknown Author'];
    final imageLinks = volumeInfo['imageLinks'] ?? {};
    final thumbnailUrl = imageLinks['smallThumbnail'] ?? '';
    final publisher = volumeInfo['publisher'] ?? '';
    final publishedDate = volumeInfo['publishedDate'] ?? '';
    final description = volumeInfo['description'] ?? '';

    return Book(
      title: title,
      authors: authors,
      thumbnailUrl: thumbnailUrl,
      subtitle: subtitle,
      publisher: publisher,
      publishedDate: publishedDate,
      description: description,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Book &&
        other.title == title &&
        listEquals(other.authors, authors) &&
        other.thumbnailUrl == thumbnailUrl;
  }

  @override
  int get hashCode => title.hashCode ^ authors.hashCode ^ thumbnailUrl.hashCode;
}

class _BookListScreenState extends State<BookListScreen> {
  late Future<List<Book>> _futureBooks;
  final ScrollController _scrollController = ScrollController();
  final bookListController = BookListController.instance;
  TextEditingController searchbookcontroller = TextEditingController();

  List<Book> _books = [];
  List<bool> _isFavoriteList = [];
  List<Book> _favoriteBooks = [];
  int _startIndex = 0;
  int _maxResults = 10;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _futureBooks = fetchBooks();
    _scrollController.addListener(_scrollListener);
    _favoriteBooks = List.from(_favoriteBooks);
    _updateFavoriteList();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _searchBooks(String query) async {
    if (query.isNotEmpty) {
      final searchUrl =
          'https://www.googleapis.com/books/v1/volumes?q=intitle:$query+subject:health+body+mind';
      final response = await http.get(Uri.parse(searchUrl));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body)['items'];
        final List<Book> searchResults =
            responseData.map((json) => Book.fromJson(json)).toList();

        setState(() {
          _books = searchResults;
          _futureBooks = Future.value(searchResults);
        });

        print('Resultados de la búsqueda:');
        print(_books);
        print(query);
      } else {
        throw Exception('Failed to search books');
      }
    } else {
      setState(() {
        _futureBooks = fetchBooks();
      });
    }
  }

  Future<List<Book>> fetchBooks() async {
    final response = await http.get(Uri.parse(
        'https://www.googleapis.com/books/v1/volumes?q=subject:health+body+mind&startIndex=$_startIndex&maxResults=$_maxResults'));
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['items'];
      return responseData.map((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<void> _fetchMoreBooks() async {
    try {
      final List<Book> moreBooks = await fetchBooks();
      setState(() {
        _books.addAll(moreBooks);
        _isFavoriteList.addAll(List.filled(moreBooks.length, false));
      });
    } catch (error) {
      print('Error fetching more books: $error');
    } finally {
      setState(() {
        _loading =
            false; // Establecer _loading en falso después de cargar los libros
      });
    }
  }

  void _scrollListener() {
    if (!_loading &&
        _scrollController.position.extentAfter < 200 &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _loading = true;
      });

      _startIndex += _maxResults;
      _fetchMoreBooks();
    }
  }

  void _updateFavoriteList() {
    setState(() {
      for (final book in _books) {
        _isFavoriteList[_books.indexOf(book)] = _favoriteBooks.contains(book);
      }
    });
  }

  PreferredSizeWidget? appBarCustom(
    String titulo,
    List<Book> fbooks,
  ) {
    return AppBar(
      centerTitle: true,
      title: Text(
        titulo,
      ),
      actions: <Widget>[
        Consumer<FavoriteProvider>(
          builder: (context, provider, _) {
            return IconButton(
              icon: Badge(
                label: favoritelength(provider.favoriteBooks.length) !=
                        provider.favoriteBooks.isEmpty
                    ? Text('${favoritelength(provider.favoriteBooks.length)}')
                    : Text('.'),
                child: Icon(Icons.bookmark_border),
              ),
              tooltip: 'Libros favoritos',
              onPressed: () {
                final route =
                    MaterialPageRoute(builder: ((context) => FavoritePage()));
                Navigator.push(context, route);
              },
            );
          },
        ),
      ],
      automaticallyImplyLeading: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavoriteProvider>(context);
    return Scaffold(
      appBar: appBarCustom(
        'Libros recomendados',
        provider.favoriteBooks,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchbookcontroller,
              decoration: InputDecoration(
                hintText: 'Buscar libros...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _searchBooks(value);
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Book>>(
              future: _futureBooks,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitFadingCircle(
                      color: Colors.blueGrey,
                      size: 50.0,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  _books = snapshot.data!;
                  if (_isFavoriteList.length != _books.length) {
                    _isFavoriteList = List.filled(_books.length, false);
                  }
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: _books.length + (_loading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _books.length) {
                        return Center(
                          child: SpinKitFadingCircle(
                            color: Colors.blueGrey,
                            size: 50.0,
                          ),
                        );
                      } else {
                        final Book book = _books[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookViewPage(
                                    appBarCustom: appBarCustom(
                                        'Descripción de libros',
                                        provider.favoriteBooks),
                                    favoriteBooks: _favoriteBooks,
                                    imageProvider:
                                        _getImageProvider(book.thumbnailUrl),
                                    title: book.title,
                                    subtitle: book.subtitle,
                                    authors: book.authors,
                                    publisher: book.publisher,
                                    publishedDate: book.publishedDate,
                                    description: book.description,
                                    book: book,
                                    onFavoriteChanged: () {
                                      setState(() {
                                        _updateFavoriteList();
                                      });
                                    }),
                              ),
                            );
                          },
                          child: Container(
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
                                      color: Colors
                                          .grey[300], // Color de fondo temporal
                                      child: Image(
                                        image: _getImageProvider(
                                            book.thumbnailUrl)!,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          book.title,
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          book.subtitle,
                                          style: TextStyle(fontSize: 14.0),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 8.0),
                                        Text(
                                          '- ${book.authors.join(',')}',
                                          style: TextStyle(fontSize: 12.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      provider.ToggleFavorite(book);
                                    },
                                    child: Icon(
                                      provider.isExist(book)
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      size: 32,
                                      color: provider.isExist(book)
                                          ? Colors.red
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

int favoritelength(int length) {
  return length;
}
