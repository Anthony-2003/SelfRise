import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class BookListScreen extends StatefulWidget {
  const BookListScreen({Key? key}) : super(key: key);

  @override
  State<BookListScreen> createState() => _BookListScreenState();
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
}

class _BookListScreenState extends State<BookListScreen> {
  late Future<List<Book>> _futureBooks;
  final ScrollController _scrollController = ScrollController();
  List<Book> _books = [];
  int _startIndex = 0;
  int _maxResults = 10;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _futureBooks = fetchBooks();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
        _loading = false;
      });
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

  void AcortarTexto(String? title) {
    if (title.toString().length > 60) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Libros recomendados',
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<Book>>(
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
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
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
                              child: Icon(Icons.bookmark_border)),
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
    );
  }
}
