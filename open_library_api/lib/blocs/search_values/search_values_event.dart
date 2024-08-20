part of 'search_values_bloc.dart';

abstract class SearchValuesEvent extends Equatable {
  const SearchValuesEvent();

  @override
  List<Object> get props => [];
}

class UpdateSearchValuesEvent extends SearchValuesEvent {
  final Map<String, String> searchValues;
  const UpdateSearchValuesEvent({
    required this.searchValues,
  });

  @override
  List<Object> get props => [searchValues];
}
