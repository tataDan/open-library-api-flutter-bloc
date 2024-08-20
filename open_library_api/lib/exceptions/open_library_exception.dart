class OpenLibraryException implements Exception {
  String message;
  OpenLibraryException([this.message = 'Something went wrong']) {
    message = 'Open Library Exception: $message';
  }

  @override
  String toString() {
    return message;
  }
}
