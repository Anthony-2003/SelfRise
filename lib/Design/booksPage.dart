import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Design/booksview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'booksController.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({Key? key}) : super(key: key);

  @override
  State<BookListScreen> createState() => _BookListScreenState();
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
    final subtitle =
        volumeInfo['subtitle'] ?? ''; // Verificar si subtitle es nulo
    final authors = volumeInfo['authors'] != null
        ? List<String>.from(volumeInfo['authors'])
        : ['Unknown Author'];
    final imageLinks = volumeInfo['imageLinks'] ?? {};
    final thumbnailUrl = imageLinks['smallThumbnail'] ?? '';
    final publisher =
        volumeInfo['publisher'] ?? ''; // Verificar si publisher es nulo
    final publishedDate =
        volumeInfo['publishedDate'] ?? ''; // Verificar si publishedDate es nulo
    final description =
        volumeInfo['description'] ?? ''; // Verificar si description es nulo

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
    bookListController.removedBookNotifier.addListener(_onBookRemoved);
    _favoriteBooks = List.from(_favoriteBooks);
    _updateFavoriteList();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    bookListController.removedBookNotifier.removeListener(_onBookRemoved);
    super.dispose();
  }

  void _onBookRemoved() {
    final removedBook = bookListController.removedBookNotifier.value;
    if (removedBook != null) {
      setState(() {
        _favoriteBooks.remove(removedBook);
        _isFavoriteList[_books.indexOf(removedBook)] = false;
      });
      _updateFavoriteList();
    }
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
          // Actualizar la lista de libros solo con los resultados de la búsqueda
          _books = searchResults;
          // Actualizar el Future para que el FutureBuilder use los resultados de la búsqueda
          _futureBooks = Future.value(searchResults);
        });

        // Imprimir los resultados de la respuesta HTTP
        print('Resultados de la búsqueda:');
        print(_books);
        print(query);
      } else {
        throw Exception('Failed to search books');
      }
    } else {
      // Si el campo de búsqueda está vacío, restaurar la lista de libros original
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
    if (!_loading) {
      setState(() {
        _loading = true;
      });
      try {
        final List<Book> moreBooks = await fetchBooks();
        setState(() {
          _books.addAll(moreBooks);
          _isFavoriteList.addAll(List.filled(moreBooks.length, false));
          _loading = false;
        });
      } catch (error) {
        print('Error fetching more books: $error');
      }
    }
  }

  void _scrollListener() {
    if (!_loading &&
        _scrollController.position.extentAfter < 200 &&
        !_scrollController.position.outOfRange) {
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

  PreferredSizeWidget? appBarCustom(String titulo) {
    return AppBar(
      centerTitle: true,
      title: Text(
        titulo,
      ),
      leading: GestureDetector(
        onTap: () {
          // Navigator.of(context).pop();
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: builder,
          //   ),
          // );
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back_ios_new_rounded),
      ),
      actions: <Widget>[
        IconButton(
          icon: Badge(
            label:
                favoritelength(_favoriteBooks.length) != _favoriteBooks.isEmpty
                    ? Text('${favoritelength(_favoriteBooks.length)}')
                    : Text('.'),
            child: Icon(Icons.bookmark_border),
          ),
          tooltip: 'Libros favoritos',
          onPressed: () async {
            final removedBook = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FavoriteBookScreen(
                  favoriteBooks: _favoriteBooks,
                  onBookRemoved: (book) {
                    setState(() {
                      _favoriteBooks.remove(book);
                      _isFavoriteList[_books.indexOf(book)] = false;
                    });
                    bookListController.notifyBookRemoved(book);
                  },
                  refreshCallback: () {
                    setState(() {
                      print("Refreshing favorite books list...");
                      _favoriteBooks = List.from(_favoriteBooks);
                      _updateFavoriteList();
                    });
                  },
                ),
              ),
            );

            if (removedBook != null) {
              setState(() {
                _favoriteBooks.remove(removedBook);
                _isFavoriteList[_books.indexOf(removedBook)] = false;
              });
              _updateFavoriteList();
            }
          },
        ),
      ],
      automaticallyImplyLeading: false,
    );
  }

  GestureDetector favoriteButton(Book book, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isFavoriteList[index] = !_isFavoriteList[index];
          if (_isFavoriteList[index]) {
            _favoriteBooks.add(book);
          } else {
            _favoriteBooks.remove(book);
          }
        });
      },
      child: Icon(
        _isFavoriteList[index] ? Icons.star : Icons.star_border,
        size: 32,
        color: _isFavoriteList[index] ? Colors.yellow : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarCustom(
        'Libros recomendados',
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
                                  ),
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
                                  favoriteButton(book, index),
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

class FavoriteBookScreen extends StatelessWidget {
  final List<Book> favoriteBooks;
  final Function(Book) onBookRemoved;
  final Function() refreshCallback; // Función de actualización

  FavoriteBookScreen({
    Key? key,
    required this.favoriteBooks,
    required this.onBookRemoved,
    required this.refreshCallback, // Recibiendo la función de actualización
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                final book = favoriteBooks[index];
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
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.infoReverse,
                                dialogBackgroundColor: Colors.transparent,
                                headerAnimationLoop: true,
                                animType: AnimType.bottomSlide,
                                title: 'Eliminar de favoritos',
                                titleTextStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                reverseBtnOrder: true,
                                btnOkOnPress: () async {
                                  // Eliminar el libro de la lista de favoritos
                                  onBookRemoved(book);
                                  // Actualizar el estado de la lista de favoritos en la pantalla anterior
                                  refreshCallback();
                                  // Ocultar el diálogo
                                },
                                btnCancelOnPress: () {},
                                desc:
                                    "¿Estás seguro que quieres eliminar este libro de tu lista de favoritos?",
                                descTextStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                btnOkText: 'Aceptar',
                                btnCancelText: 'Cancelar',
                              ).show();
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
