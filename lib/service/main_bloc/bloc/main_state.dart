part of 'main_bloc.dart';

@immutable
abstract class MainState {}

class MainInitial extends MainState {}

class LoadedAppState extends MainState {
  final int currentPageIndex;
  final PageList currentPage;
  Map<String, bool> pageParams;
  LoadedAppState(this.currentPage, this.pageParams, this.currentPageIndex);
}
