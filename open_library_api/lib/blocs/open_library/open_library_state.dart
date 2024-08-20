part of 'open_library_bloc.dart';

enum OpenLibraryStatus {
  initial,
  loading,
  loaded,
  error,
}

class OpenLibraryState extends Equatable {
  const OpenLibraryState({
    required this.status,
    required this.openLibrary,
    required this.error,
  });

  factory OpenLibraryState.initial() {
    return OpenLibraryState(
      status: OpenLibraryStatus.initial,
      openLibrary: OpenLibrary.initial(),
      error: const CustomError(),
    );
  }

  final OpenLibraryStatus status;
  final OpenLibrary openLibrary;
  final CustomError error;

  @override
  List<Object> get props => [status, openLibrary, error];

  @override
  String toString() =>
      'OpenLibraryState(status: $status, openLibrary: $openLibrary, error: $error)';

  OpenLibraryState copyWith({
    OpenLibraryStatus? status,
    OpenLibrary? openLibrary,
    CustomError? error,
  }) {
    return OpenLibraryState(
      status: status ?? this.status,
      openLibrary: openLibrary ?? this.openLibrary,
      error: error ?? this.error,
    );
  }
}
