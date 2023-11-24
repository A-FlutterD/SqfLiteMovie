import 'package:flutter/material.dart';
import 'package:netw_movie/ui/movie_list.dart';

void main() {
  runApp(const AppMovie());
}

class AppMovie extends StatelessWidget {
  const AppMovie({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "My Movies",
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: const MovieList(),
    );
  }
}
