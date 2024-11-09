import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'page_event.dart';
part 'page_state.dart';

class PageBloc extends Bloc<PageEvent, PageState> {
  PageBloc() : super(PageState.initial()) {
    on<IncrementPageEvent>((event, emit) {
      emit(state.copyWith(page: state.page + 1));
    });

    on<DecrementPageEvent>((event, emit) {
      emit(state.copyWith(page: state.page - 1));
    });

    on<ResetToOnePageEvent>((event, emit) {
      emit(state.copyWith(page: 1));
    });
  }
}
