part of 'page_bloc.dart';

abstract class PageEvent extends Equatable {
  const PageEvent();

  @override
  List<Object> get props => [];
}

class IncrementPageEvent extends PageEvent {}

class DecrementPageEvent extends PageEvent {}
