part of netflix;

class Episode {
  int _number;
  int _season;
  String _url;
  String _image;
  String _summary;
  String _name;
  int _duration;

  Episode.fromJson(Map<String, dynamic> parsedJson) {
    RegExp exp = new RegExp(r"<[^>]*>");
    _number = int.parse(parsedJson['number']);
    _season = int.parse(parsedJson['season']);
    _url = parsedJson['url'];
    _image = (parsedJson['image'] ?? {});
    _summary = parsedJson['summary'] != null
        ? parsedJson['summary'].replaceAll(exp, '')
        : '';
    _name = parsedJson['name'];
    _duration = parsedJson['airtime'] != null &&
            parsedJson['airtime'].toString().isNotEmpty
        ? int.parse(parsedJson['airtime'].split(':')[0])
        : 0;
  }

  int get number => _number;
  int get season => _season;
  String get image => _image;
  String get url => _url;
  String get summary => _summary;
  String get name => _name;
  int get duration => _duration;
}
