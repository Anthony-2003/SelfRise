import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Design/menu_principal.dart';
import 'package:flutter_proyecto_final/components/inputs.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'booksController.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({Key? key}) : super(key: key);

  @override
  State<BookListScreen> createState() => _BookListScreenState();

  static void updateFavoriteList(BuildContext context) {
    final _BookListScreenState? state =
        context.findAncestorStateOfType<_BookListScreenState>();
    state?._updateFavoriteList();
  }
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
  final List<String> authors;
  final String thumbnailUrl;

  Book({
    required this.title,
    required this.authors,
    required this.thumbnailUrl,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'];
    final title = volumeInfo['title'];
    final authors = volumeInfo['authors'] != null
        ? List<String>.from(volumeInfo['authors'])
        : ['Unknown Author'];
    final imageLinks = volumeInfo['imageLinks'] ?? {};
    final thumbnailUrl = imageLinks['smallThumbnail'] ?? '';

    return Book(
      title: title,
      authors: authors,
      thumbnailUrl: thumbnailUrl,
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

class  _BookListScreenState extends State<BookListScreen> {
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

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _startIndex += _maxResults;
      _fetchMoreBooks();
    }
  }

  Future<void> _fetchMoreBooks() async {
    if (!_loading) {
      setState(() {
        _loading = true;
      });
      final List<Book> moreBooks = await fetchBooks();
      setState(() {
        _books.addAll(moreBooks);
        _isFavoriteList.addAll(List.filled(moreBooks.length, false));
        _loading = false;
      });
    }
  }

  void _updateFavoriteList() {
    setState(() {
      for (final book in _books) {
        _isFavoriteList[_books.indexOf(book)] = _favoriteBooks.contains(book);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Libros recomendados',
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PantallaMenuPrincipal(),
              ),
            );
          },
          child: Icon(Icons.arrow_back_ios_new_rounded),
        ),
        actions: <Widget>[
          IconButton(
            icon: Badge(
              label: favoritelength(_favoriteBooks.length) != null
                  ? Text('${favoritelength(_favoriteBooks.length)}')
                  : null,
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
                      setState(() {});
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
                        return Container(
                          width: double.infinity,
                          height: 140.0,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 10.0),
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
                                        width: 8.0,
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
                                      setState(() {
                                        _isFavoriteList[index] =
                                            !_isFavoriteList[index];
                                        if (_isFavoriteList[index]) {
                                          _favoriteBooks.add(
                                              book); // Actualización: Agregar a la lista de favoritos
                                        } else {
                                          _favoriteBooks.remove(
                                              book); // Actualización: Quitar de la lista de favoritos
                                        }
                                      });
                                    },
                                    child: Icon(
                                      _isFavoriteList[index]
                                          ? Icons.star
                                          : Icons.star_border,
                                      size: 32,
                                    ),
                                  ),
                                ),
                              ],
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
                                width: 8.0,
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
                              
                                  onBookRemoved(book);
                                  BookListScreen.updateFavoriteList(context);
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
