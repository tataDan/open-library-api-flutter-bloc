import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_values_event.dart';
part 'search_values_state.dart';

class SearchValuesBloc extends Bloc<SearchValuesEvent, SearchValuesState> {
  final Map<String, String> newSearchValues;

  SearchValuesBloc({
    required this.newSearchValues,
  }) : super(SearchValuesState.initial()) {
    on<UpdateSearchValuesEvent>(_updateSearchValues);
  }

  Future<void> _updateSearchValues(
    UpdateSearchValuesEvent event,
    Emitter<SearchValuesState> emit,
  ) async {
    emit(state.copyWith(searchValues: event.searchValues));
  }
}
