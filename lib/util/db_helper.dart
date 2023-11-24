import 'package:netw_movie/model/movie.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  final int version = 1;
  Database? db;

  static final DbHelper _dbHelper = DbHelper.internal();
  DbHelper.internal();

  factory DbHelper() {
    return _dbHelper;
  }

  Future<Database> openDb() async {
    db ??= await openDatabase(join(await getDatabasesPath(), "movies.db"), onCreate: (db, version) {
        db.execute("CREATE TABLE movies(id INTEGER PRIMARY KEY, title TEXT)");
      }, version: version);
    return db!;
  }

  Future<int> insertMovie(Movie movie) async {
    int id = await db!.insert("movies", movie.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  Future<bool> isFavorite(Movie movie) async {
    final List<Map<String, dynamic>> maps = await db!.query("movies", where: "id = ?", whereArgs: [movie.id]);
    return maps.isNotEmpty;
  }

  Future<int> deleteMovie(Movie movie) async {
    int result = await db!.delete("movies", where: "id = ?", whereArgs: [movie.id]);
    return result;
  }
}