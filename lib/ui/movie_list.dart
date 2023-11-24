import 'package:flutter/material.dart';
import 'package:netw_movie/model/movie.dart';
import 'package:netw_movie/ui/movie_detail.dart';
import 'package:netw_movie/util/db_helper.dart';
import 'package:netw_movie/util/http_helper.dart';

class MovieList extends StatefulWidget {
  const MovieList({super.key});

  @override
  State<MovieList> createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  late List<Movie> movies;
  late int moviesCount;
  late int page = 1;
  late bool loading = true;
  late HttpHelper httpHelper;
  late ScrollController _scrollController;

  Future<void> initialize() async {
    movies = [];
    loadMore();
    initScrollController();
  }

  @override
  void initState() {
    super.initState();
    httpHelper = HttpHelper();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Movies"),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: movies.length,
        itemBuilder: (BuildContext context, int index) {
          return MovieRow(movies[index]);
        },
      ),
    );
  }

  void loadMore() {
    httpHelper.getUpComing(page.toString()).then((value) {
      movies += value!;

      setState(() {
        moviesCount = movies.length;
        movies = movies;
        page++;
      });

      if (movies.length % 20 > 0) {
        loading = false;
      }
    });
  }

  void initScrollController() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if ((_scrollController.position.pixels == _scrollController.position.maxScrollExtent) && loading) {
        loadMore();
      }
    });
  }
}

class MovieRow extends StatefulWidget {
  const MovieRow(this.movie, {super.key});

  final Movie movie;

  @override
  State<MovieRow> createState() => _MovieRowState();
}

class _MovieRowState extends State<MovieRow> {

  late bool favorite;
  late DbHelper dbHelper;
  late String path;

  @override
  void initState() {
    favorite = false;
    dbHelper = DbHelper();
    isFavorite(widget.movie);
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.movie.posterPath != null) {
      path = "https://image.tmdb.org/t/p/w500${widget.movie.posterPath}";
    }
    else {
      path = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png";
    }

    return Card(
      color: Colors.white,
      elevation: 2.0,
      child: ListTile(
        leading: Hero(
          tag: "poster_${widget.movie.id}",
          child: Image.network(path),
        ),
        title: Text(widget.movie.title!),
        subtitle: Text("${widget.movie.releaseDate!} - ${widget.movie.voteAverage}"),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MovieDetail(widget.movie))).then((value) {
            isFavorite(widget.movie);
          });
        },
        trailing: IconButton(
          icon: const Icon(Icons.favorite),
          color: favorite ? Colors.red : Colors.grey,
          onPressed: () {
            favorite ? dbHelper.deleteMovie(widget.movie) : dbHelper.insertMovie(widget.movie);

            setState(() {
              favorite = !favorite;
              widget.movie.isFavorite = favorite;
            });
          },
        ),
      ),
    );
  }

  Future isFavorite(Movie movie) async {
    await dbHelper.openDb();
    favorite = await dbHelper.isFavorite(movie);

    setState(() {
      movie.isFavorite = favorite;
    });
  }
}
