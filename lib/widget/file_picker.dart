import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sklad_uchet/service/main_bloc/bloc/main_bloc.dart';

class FilepickerWidget extends StatefulWidget {
  FilepickerWidget({Key? key}) : super(key: key);

  @override
  _FilepickerState createState() => _FilepickerState();
}

class _FilepickerState extends State<FilepickerWidget> {
  Future<void> _pickfile() async {
    if (await Permission.storage.isGranted) {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null && result.isSinglePick) {
        BlocProvider.of<MainBloc>(context)
            .add(SubmitExcelEvent(result.files.first));
      }
    } else {
      await Permission.storage.request();
      _pickfile();
    }
  }

  bool fileSelected = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: !this.fileSelected
          ? Center(
              child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(10.0),
              ),
              child: Text('Выберите файл'),
              onPressed: _pickfile,
            ))
          : Column(
              children: [
                Center(
                    child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    padding: const EdgeInsets.all(10.0),
                  ),
                  child: Text('Выберите файл'),
                  onPressed: _pickfile,
                ))
              ],
            ),
    );
  }
}
