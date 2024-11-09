part of 'page_bloc.dart';

class PageState extends Equatable {
  final int page;
  const PageState({required this.page});

  factory PageState.initial() {
    return const PageState(page: 1);
  }

  @override
  List<Object> get props => [page];

  @override
  String toString() => 'PageState(page: $page)';

  PageState copyWith({
    int? page,
  }) {
    return PageState(
      page: page ?? this.page,
    );
  }
}
