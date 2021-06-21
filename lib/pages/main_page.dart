import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sklad_uchet/service/main_bloc/bloc/main_bloc.dart';
import 'package:sklad_uchet/widget/date_selecter.dart';
import 'package:sklad_uchet/widget/excel_widget.dart';
import 'package:sklad_uchet/widget/file_picker.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    Widget selectwidget(Map<String, bool> pageParams) {
      // if (!pageParams.containsKey('DateSelected')) {
      //   return Text('error');
      // }
      // if (pageParams['DateSelected'] != null &&
      //     pageParams['DateSelected'] == false) {
      //   return Dateselecter();
      // }
      // if (pageParams['TableSelected'] == false) {
      //   return FilepickerWidget();
      // }
      return ExcelView();
    }

    return selectwidget(BlocProvider.of<MainBloc>(context).pageParams);
  }
}
