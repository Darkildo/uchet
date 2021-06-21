import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sklad_uchet/const.dart' as Constants;
import 'package:sklad_uchet/enum/pages_enum.dart';
import 'package:sklad_uchet/service/storage_service.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(MainInitial());
  Map<String, bool> pageParams = {
    'DateSelected': false,
    'TableSelected': false
  };
  Excel? excel;
  List<int> params = [0, 0, 0];
  String? fileName;
  String? currentDate;
  PageList currentPage = PageList.pinpage;
  StorageService? storage;
  int currentPageIndex = 0;
  @override
  Stream<MainState> mapEventToState(MainEvent event) async* {
    if (event is StartBlocEvent) {
      storage = StorageService(await SharedPreferences.getInstance());

      yield LoadedAppState(currentPage, pageParams, currentPageIndex);
    }
    if (event is InputPinEvent) {
      if (event.pin == Constants.PinCode) {
        if (storage!.getDate().isNotEmpty) {
          print(storage!.getDate());
          currentDate = storage!.getDate();
          pageParams['DateSelected'] = true;
        }

        currentPage = PageList.MainAppPage;
        yield LoadedAppState(currentPage, pageParams, currentPageIndex);
      }
    }
    if (event is SubmitDateEvent) {
      if (await storage!.saveDate(currentDate ?? '')) {
        DateTime currentm = (event.newDate.value as DateTime);
        currentDate = currentm.year.toString() +
            '-' +
            currentm.month.toString() +
            '-' +
            currentm.day.toString();
        pageParams['DateSelected'] = true;
        yield LoadedAppState(this.currentPage, pageParams, currentPageIndex);
      }
    }
    if (event is SubmitExcelEvent) {
      Uint8List bytes = File(event.file.path!).readAsBytesSync();
      fileName = event.file.name;
      excel = Excel.decodeBytes(bytes);
      pageParams['TableSelected'] = true;
      yield LoadedAppState(this.currentPage, pageParams, currentPageIndex);
    }
    if (event is ChangePageEvent) {
      currentPageIndex = event.pageIndex;
      yield LoadedAppState(currentPage, pageParams, currentPageIndex);
    }
  }
}
