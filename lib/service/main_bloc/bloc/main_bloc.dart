import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sklad_uchet/const.dart' as Constants;
import 'package:sklad_uchet/enum/pages_enum.dart';
import 'package:sklad_uchet/service/storage_service.dart';
import 'package:sklad_uchet/widget/lisence_painter.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(MainInitial());
  Map<String, bool> pageParams = {
    'DateSelected': false,
    'TableSelected': false
  };
  List<Offset?> points = [];
  Excel? excel;
  List<int> params = [0, 0, 0];
  String? fileName;
  String? currentDate;
  String? currentPin;
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
      excel = Excel.decodeBytes(bytes);
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
      //List<Offset> clearpoints = [];
      image = Image.memory((await Signature(points).getImage()));

      // String varv = image!.image.toString();
      // print(varv);

      // points.forEach((element)async  {
      //   if (element != null) clearpoints.add(element);

      // });
      this.add(ClearDrawCanvasEvent());
      // Image.memory()

      //Image.file(File.fromRawPath(Uint8List.fromList( clearpoints.toList())));
    }
  }
}
