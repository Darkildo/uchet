import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sklad_uchet/const.dart' as Constants;
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class StorageService {
  final SharedPreferences storage;
  StorageService(this.storage);

  Future<bool> saveDate(String newDate) async {
    return await storage.setString(Constants.DateKey, newDate);
  }

  String getDate() {
    return storage.getString(Constants.DateKey) ?? '';
  }

  Future<bool> updatePin(String newPin) async {
    return await storage.setString(Constants.PinKey, newPin);
  }

  String getPin() {
    return storage.getString(Constants.PinKey) ?? '0000';
  }

  Future<bool> updateTableIndex(List<int> indexes) async {
    await storage.setInt(Constants.firstIndexKey, indexes.elementAt(0));
    await storage.setInt(Constants.SecondIndexKey, indexes.elementAt(1));
    await storage.setInt(Constants.ThirdIndexKey, indexes.elementAt(2));
    return Future.value(true);
  }

  List<int> getTableIndex() {
    return [
      storage.getInt(Constants.firstIndexKey) ?? 0,
      storage.getInt(Constants.SecondIndexKey) ?? 0,
      storage.getInt(Constants.ThirdIndexKey) ?? 0,
    ];
  }

  saveTable(List<int>? bytes, String path) {
    var savedTable = File(path);
    // savedTable.writeAsBytes();
  }

  Future<bool> saveTableToStorage(List<int>? bytes, String fileName) async {
    Directory directory;
    try {
      directory = (await getApplicationDocumentsDirectory());
      String newPath = "";
      print(directory);
      List<String> paths = directory.path.split("/");
      for (int x = 1; x < paths.length; x++) {
        String folder = paths[x];
        if (folder != "Android") {
          newPath += "/" + folder;
        } else {
          break;
        }
      }
      newPath = newPath + "/RPSApp";
      directory = Directory(newPath);

      File saveFile = File(directory.path + "/$fileName");
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        saveFile.writeAsBytesSync(bytes!);

        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
