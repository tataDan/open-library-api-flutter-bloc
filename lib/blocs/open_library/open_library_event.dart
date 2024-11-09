part of 'open_library_bloc.dart';

sealed class OpenLibraryEvent extends Equatable {
  const OpenLibraryEvent();

  @override
  List<Object> get props => [];
}

class FetchOpenLibraryEvent extends OpenLibraryEvent {
  final Map<String, String> searchValues;
  final int page;
  const FetchOpenLibraryEvent({
    required this.searchValues,
    required this.page,
  });

  @override
  List<Object> get props => [searchValues, page];
}
