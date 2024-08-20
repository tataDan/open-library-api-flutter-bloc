class ShowOptions {
  ShowOptions({
    required this.showAuthor,
    required showPublisher,
    required this.showPerson,
    required this.showPlace,
    required this.showSubject,
    required this.showIsbn,
    required this.showLanguage,
  });

  bool showAuthor = true;
  bool showPublisher = true;
  bool showPerson = true;
  bool showPlace = true;
  bool showSubject = true;
  bool showIsbn = true;
  bool showLanguage = true;

  void showAll() {
    showAuthor = true;
    showPublisher = true;
    showPerson = true;
    showPlace = true;
    showSubject = true;
    showIsbn = true;
    showLanguage = true;
  }

  void hideAll() {
    showAuthor = false;
    showPublisher = false;
    showPerson = false;
    showPlace = false;
    showSubject = false;
    showIsbn = false;
    showLanguage = false;
  }
}
