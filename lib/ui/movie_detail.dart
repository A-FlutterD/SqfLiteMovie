import 'package:flutter/material.dart';
import 'package:netw_movie/model/movie.dart';
import 'package:netw_movie/util/db_helper.dart';

class MovieDetail extends StatefulWidget {
  const MovieDetail(this.movie, {super.key});

  final Movie movie;

  @override
  State<MovieDetail> createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  late DbHelper dbHelper;
  late String path;

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    if (widget.movie.posterPath != null) {
      path = "https://image.tmdb.org/t/p/w500/${widget.movie.posterPath}";
    }
    else {
      path = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title.toString()),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(8),
                child: Hero(
                  tag: "poster_${widget.movie.id}",
                  child: Image.network(path, height: height / 1.5),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.favorite),
                color: (widget.movie.isFavorite!) ? Colors.red : Colors.grey,
                onPressed: () {
                  (widget.movie.isFavorite!) ? dbHelper.deleteMovie(widget.movie) : dbHelper.insertMovie(widget.movie);

                  setState(() {
                    widget.movie.isFavorite = !(widget.movie.isFavorite!);
                  });
                },
              ),
              Container(
                padding: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                child: Text(widget.movie.overview.toString()),
              )
            ],
          ),
        ),
      ),
    );
  }
}
