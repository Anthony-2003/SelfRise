import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Design/libros/booksPage.dart';
import 'package:flutter_proyecto_final/entity/AuthService.dart';
import 'package:provider/provider.dart';
import '../../components/favorite_provider.dart';

class BookViewPage extends StatefulWidget {
  final ImageProvider<Object>? imageProvider;
  final PreferredSizeWidget? appBarCustom;
  final Book book;

  final String title;
  final String subtitle;
  final List<String> authors;
  final String publisher;
  final String publishedDate;
  final String description;

  BookViewPage({
    Key? key,
    required this.imageProvider,
    required this.title,
    required this.authors,
    required this.subtitle,
    required this.description,
    required this.publisher,
    required this.publishedDate,
    this.appBarCustom,
    required this.book,
  }) : super(key: key);

  @override
  State<BookViewPage> createState() => _BookViewPageState();
}

class _BookViewPageState extends State<BookViewPage> {
  late bool isFavorite = false;

  void initState() {
    super.initState();
    checkFavoriteStatus();
  }

  void checkFavoriteStatus() async {
    final provider = Provider.of<FavoriteProvider>(context, listen: false);
    final userId = AuthService.getUserId();
    if (userId != null) {
      final favorites = await provider.getFavorites(userId);
      print(favorites.length);
      setState(() {
        isFavorite = favorites.any((book) => book.id == widget.book.id);
      });
    } else {
      setState(() {
        isFavorite = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavoriteProvider>(context);
    final String? userId = AuthService.getUserId();
    return Scaffold(
      appBar: widget.appBarCustom ?? AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 144.0,
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
                          image: widget.imageProvider ??
                              AssetImage('assets/default_image.png'),
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
                            widget.title,
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            widget.subtitle,
                            style: TextStyle(fontSize: 14.0),
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Text(
                            '- ${widget.authors.join(',')}',
                            style: TextStyle(fontSize: 12.0),
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Text(
                            '${widget.publisher} - ${widget.publishedDate}',
                            style: TextStyle(fontSize: 10.0),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (userId != null) {
                          provider.toggleFavorite(widget.book, userId);
                          setState(() {
                            isFavorite = !isFavorite;
                          });
                        } else {
                          print("Error: userId es null");
                        }
                      },
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : null,
                        size: 30,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 0.5,
              color: Colors.grey,
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
              child: Text(
                widget.description,
                style: TextStyle(fontSize: 14.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
