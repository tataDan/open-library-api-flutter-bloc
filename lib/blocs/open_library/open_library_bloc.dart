import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/custom_error.dart';
import '../../models/open_library_response.dart';
import '../../repositories/open_library_repository.dart';

part 'open_library_event.dart';
part 'open_library_state.dart';

class OpenLibraryBloc extends Bloc<OpenLibraryEvent, OpenLibraryState> {
  final OpenLibraryRepository openLibraryRepository;

  OpenLibraryBloc({
    required this.openLibraryRepository,
  }) : super(OpenLibraryState.initial()) {
    on<FetchOpenLibraryEvent>(_fetchOpenLibrary);
  }

  Future<void> _fetchOpenLibrary(
    FetchOpenLibraryEvent event,
    Emitter<OpenLibraryState> emit,
  ) async {
    emit(state.copyWith(status: OpenLibraryStatus.loading));

    try {
      final OpenLibrary openLibrary = await openLibraryRepository
          .fetchOpenLibrary(event.searchValues, event.page);

      emit(state.copyWith(
          status: OpenLibraryStatus.loaded, openLibrary: openLibrary));
    } on CustomError catch (e) {
      emit(state.copyWith(status: OpenLibraryStatus.error, error: e));
    }
  }
}
