import 'dart:convert';
import 'dart:io';
import 'package:netw_movie/model/movie.dart';
import 'package:http/http.dart' as http;

class HttpHelper {
  final String urlBase = "https://api.themoviedb.org/3/movie";
  final String urlUpComing = "/upcoming?";
  final String urlKey = "api_key=3cae426b920b29ed2fb1c0749f258325";
  final String urlPage = "&page=";

  Future<List<Movie>?> getUpComing(String page) async {
    final String urlFinal = urlBase + urlUpComing + urlKey + urlPage + page;
    print(urlFinal);
    http.Response result = await http.get(Uri.parse(urlFinal));

    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      final moviesMap = jsonResponse['results'];

      List<Movie> movies = moviesMap.map<Movie>((index) => Movie.fromJson(index)).toList();
      return movies;
    }
    else {
      print(result.body);
      return null;
    }
  }
}