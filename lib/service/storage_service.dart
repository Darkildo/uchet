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
}
