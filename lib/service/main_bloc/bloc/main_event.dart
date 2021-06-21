part of 'main_bloc.dart';

@immutable
abstract class MainEvent {}

class InputPinEvent extends MainEvent {
  final String pin;
  InputPinEvent(this.pin);
}

class StartBlocEvent extends MainEvent {}

class SubmitDateEvent extends MainEvent {
  final DateRangePickerSelectionChangedArgs newDate;
  SubmitDateEvent(this.newDate);
}

class SubmitExcelEvent extends MainEvent {
  final PlatformFile file;
  SubmitExcelEvent(this.file);
}

class ChangePageEvent extends MainEvent {
  final int pageIndex;
  ChangePageEvent(this.pageIndex);
}
