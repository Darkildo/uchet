import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as ExLib;
import 'package:sklad_uchet/const.dart' as Constants;
import 'package:sklad_uchet/enum/pages_enum.dart';
import 'package:sklad_uchet/service/storage_service.dart';
import 'package:sklad_uchet/widget/lisence_painter.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

part 'main_event.dart';
part 'main_state.dart';

class SortedRow {
  SortedRow(this.rowElement, this.sourceIndex);
  List<Data?> rowElement;
  int sourceIndex;
}

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(MainInitial());
  Map<String, bool> pageParams = {
    'DateSelected': false,
    'TableSelected': false
  };
  List<Offset?> points = [];
  Excel? excel;
  List<SortedRow> excelRows = [];
  List<int> params = [0, 0, 0];
  String? fileName;
  String? currentDate;
  String? currentPin;
  String filterValue = '';
  Image? image;
  List<int>? currentIndex;
  PageList currentPage = PageList.pinpage;
  StorageService? storage;
  int currentPageIndex = 0;
  @override
  Stream<MainState> mapEventToState(MainEvent event) async* {
    if (event is StartBlocEvent) {
      storage = StorageService(await SharedPreferences.getInstance());
      currentPin = storage!.getPin();
      yield LoadedAppState(currentPage, pageParams, currentPageIndex);
    }
    if (event is InputPinEvent) {
      if (event.pin == currentPin) {
        if (storage!.getDate().isNotEmpty) {
          currentDate = storage!.getDate();
          pageParams['DateSelected'] = true;
        }
        currentIndex = storage!.getTableIndex();

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
      // ExLib.Workbook excelworkbook = ExLib.Workbook();
      //excelworkbook.

      excel = Excel.decodeBytes(bytes);

      excelRows = sortRows(excel!.sheets.values.first.rows, filterValue);

      // excelRows.forEach((element) {
      //   print(element.sourceIndex);
      // });
      pageParams['TableSelected'] = true;
      yield LoadedAppState(this.currentPage, pageParams, currentPageIndex);
    }
    if (event is ChangePageEvent) {
      currentPageIndex = event.pageIndex;
      yield LoadedAppState(currentPage, pageParams, currentPageIndex);
    }
    if (event is SignOutEvent) {
      currentPage = PageList.pinpage;
      currentPageIndex = 0;
      this.add(StartBlocEvent());
    }
    if (event is ChangePinEvent) {
      await storage!.updatePin(event.newPin);
      yield LoadedAppState(currentPage, pageParams, currentPageIndex);
    }
    if (event is UpdateTableIndexEvent) {
      await storage!.updateTableIndex(event.newIndexes);
      currentIndex = event.newIndexes;
      yield LoadedAppState(currentPage, pageParams, currentPageIndex);
    }
    if (event is ClearDrawCanvasEvent) {
      points.clear();
    }
    if (event is SaveDrawCanvasEvent) {
      image = Image.memory((await Signature(points).getImage()));
      var cell = excel!.sheets.values.first.cell(CellIndex.indexByColumnRow(
          columnIndex: currentIndex![2], rowIndex: event.userIndex));
      cell.value = image!;

      // excel!.sheets.values.first.rows
      //     .elementAt(event.userIndex)
      //     .elementAt(currentIndex![2]) =;
      String path = (await getApplicationDocumentsDirectory()).path;
      var bytes = excel!.save(fileName: path + currentDate!);
      DateTime now = DateTime.now();

      bool result =
          await storage!.saveTableToStorage(bytes, fileName!, now.toString());
      print(result);
      this.add(ClearDrawCanvasEvent());
      // Image.memory()

      //Image.file(File.fromRawPath(Uint8List.fromList( clearpoints.toList())));
    }
    if (event is ChangeFilterEvent) {
      filterValue = event.filteredValue;
      excelRows = sortRows(excel!.sheets.values.first.rows, filterValue);
      yield LoadedAppState(currentPage, pageParams, currentPageIndex);
    }
  }

  List<SortedRow> sortRows(List<List<Data?>?> rows, String filterValue) {
    List<SortedRow> newRows = [];
    rows.forEach((element) {
      if (element != null &&
          element.elementAt(this.currentIndex![0]) != null &&
          (filterValue.isNotEmpty
              ? element
                  .elementAt(this.currentIndex![0])!
                  .props
                  .first
                  .toString()
                  .contains(filterValue)
              : true)) newRows.add(SortedRow(element, rows.indexOf(element)));
    });

    return newRows;
  }
}
