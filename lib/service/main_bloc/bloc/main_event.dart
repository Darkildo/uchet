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

class SignOutEvent extends MainEvent {}

class ChangePinEvent extends MainEvent {
  final String newPin;
  ChangePinEvent(this.newPin);
}

class UpdateTableIndexEvent extends MainEvent {
  final List<int> newIndexes;
  UpdateTableIndexEvent(this.newIndexes);
}

class ClearDrawCanvasEvent extends MainEvent {}

class SaveDrawCanvasEvent extends MainEvent {}
