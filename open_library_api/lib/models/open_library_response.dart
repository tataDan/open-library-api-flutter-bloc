class OpenLibrary {
  final int numFound;
  List<Doc> docs;

  OpenLibrary({
    required this.numFound,
    required this.docs,
  });

  factory OpenLibrary.fromJson(Map<String, dynamic> json) {
    final docsData = json['docs'] as List<dynamic>?;
    return OpenLibrary(
      numFound: json['numFound'],
      docs: docsData != null
          ? docsData
              .map((docsData) => Doc.fromJson(docsData as Map<String, dynamic>))
              .toList()
          : <Doc>[],
    );
  }

  factory OpenLibrary.initial() => OpenLibrary(
        numFound: 0,
        docs: [],
      );
}

class Doc {
  final String title;
  final String? subtitle;
  final List<dynamic>? authorName;
  final List<dynamic>? publisher;
  final List<dynamic>? person;
  final List<dynamic>? place;
  final List<dynamic>? subject;
  final List<dynamic>? isbn;
  final List<dynamic>? language;
  final String key;

  Doc({
    required this.title,
    required this.subtitle,
    required this.authorName,
    required this.publisher,
    required this.person,
    required this.place,
    required this.subject,
    required this.isbn,
    required this.language,
    required this.key,
  });

  factory Doc.fromJson(Map<String, dynamic> json) {
    return Doc(
      title: json['title'],
      subtitle: json['subtitle'],
      authorName: json['author_name'],
      publisher: json['publisher'],
      person: json['person'],
      place: json['place'],
      subject: json['subject'],
      isbn: json['isbn'],
      language: json['language'],
      key: json['key'],
    );
  }
}
