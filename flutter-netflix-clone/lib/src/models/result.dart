part of netflix;

class Result {
  int _id;
  String _name;
  int _movieAmountByGenre;
  String _image;
  List<String> _genres;
  List<String> _cast;
  List<Episode> _episodes;
  List<int> _seasons = [];
  String _date;
  String _description;
  String _rate;
  int _movieLength;
  String _movieLink;

  Result.fromJson(Map<String, dynamic> parsedJson) {
    _id = int.parse(parsedJson['id']);
    _name = parsedJson['name'];
    _rate = parsedJson['rate'];
    _movieLink = parsedJson['movieLink'] ?? parsedJson['episodes'][0]['url'];
    _movieLength = int.parse(parsedJson['length']);
    _movieAmountByGenre = parsedJson['movieAmountByGenre']??1;
    _image = parsedJson['image'];
    _genres = List.from(parsedJson['genres'])
        .map((genre) => genre["name"].toString())
        .toList();
    _cast = List.from(parsedJson['casts'])
        .map((cast) => cast['name'].toString())
        .toList();
    _date = parsedJson['year'] != null
        ? parsedJson['year']
        : DateTime.now().year.toString();
    RegExp exp = new RegExp(r"<[^>]*>");
    _description = parsedJson['description'].replaceAll(exp, '');
    _episodes = List.from(parsedJson['episodes'])
        .map((e) => Episode.fromJson(e))
        .toList();
    List.from(parsedJson['episodes']).forEach((s) {
      int seasonNumber = int.parse(s['season'].toString());
      if (!_seasons.contains(seasonNumber)) _seasons.add(seasonNumber);
    });
  }

  String get name => _name;
  String get movieLink => _movieLink;
  int get movieLength => _movieLength;
  int get movieAmountByGenre => _movieAmountByGenre;
  String get image => _image;
  String get rate => _rate;
  List<String> get genres => _genres;
  List<String> get cast => _cast;
  String get date => _date;
  String get description => _description;
  List<Episode> get episodes => _episodes;
  List<int> get seasons => _seasons;
  int get id => _id;
}
