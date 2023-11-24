class Movie {
  int? id;
  String? overview;
  double? popularity;
  String? posterPath;
  String? title;
  String? releaseDate;
  bool? isFavorite;
  double? voteAverage;

  Movie(
      {this.id,
        this.overview,
        this.popularity,
        this.posterPath,
        this.title,
        this.releaseDate,
        this.isFavorite,
        this.voteAverage});

  Movie.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    overview = json['overview'];
    popularity = json['popularity'];
    posterPath = json['poster_path'];
    title = json['title'];
    releaseDate = json['release_date'];
    isFavorite = json["is_favorite"];
    voteAverage = json["vote_average"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['overview'] = this.overview;
    data['popularity'] = this.popularity;
    data['poster_path'] = this.posterPath;
    data['title'] = this.title;
    data['release_date'] = this.releaseDate;
    data["is_favorite"] = this.isFavorite;
    data["vote_average"] = this.voteAverage;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title
    };
  }
}