class DocFilters {
  DocFilters({
    required this.titleExact,
    required this.authorExact,
    required this.publisherExact,
    required this.personExact,
    required this.placeExact,
    required this.subjectExact,
    required this.titleSubstring,
    required this.authorSubstring,
    required this.publisherSubstring,
    required this.personSubstring,
    required this.placeSubstring,
    required this.subjectSubstring,
  });

  bool titleExact = false;
  bool authorExact = false;
  bool publisherExact = false;
  bool personExact = false;
  bool placeExact = false;
  bool subjectExact = false;
  bool titleSubstring = false;
  bool authorSubstring = false;
  bool publisherSubstring = false;
  bool personSubstring = false;
  bool placeSubstring = false;
  bool subjectSubstring = false;
}
