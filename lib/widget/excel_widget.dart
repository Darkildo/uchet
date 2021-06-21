import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sklad_uchet/service/main_bloc/bloc/main_bloc.dart';
import 'package:sklad_uchet/widget/file_picker.dart';
import 'package:sklad_uchet/widget/lisence_painter.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ExcelView extends StatefulWidget {
  ExcelView({Key? key}) : super(key: key);

  @override
  _ExcelViewState createState() => _ExcelViewState();
}

class _ExcelViewState extends State<ExcelView> {
  @override
  Widget build(BuildContext context) {
    MainBloc bloc = BlocProvider.of<MainBloc>(context);
    Excel? table = bloc.excel;
    ;

    return Padding(
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.08),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                child: Text(bloc.currentDate ?? 'Выберите дату'),
                onTap: () => _selectDate(bloc),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                bloc.fileName ?? 'Файл не выбран',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FilepickerWidget(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'ФИО',
                    hintStyle: TextStyle(fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 0,
                        style: BorderStyle.solid,
                      ),
                    ),
                    filled: true,
                    contentPadding: EdgeInsets.all(16),
                  )),
            ),
            Expanded(
                flex: 6,
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  elevation: 30,
                  child: ListView.builder(
                      itemCount: table != null
                          ? table.sheets.values.first.rows.length
                          : 0,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            _selectItem(index, table!);
                          },
                          child: Card(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 7),
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    table != null
                                        ? table.sheets.values.first.rows
                                            .elementAt(index)
                                            .elementAt(2)!
                                            .props
                                            .first
                                            .toString()
                                        : 'none',
                                    style: TextStyle(fontSize: 24)),
                              )),
                        );
                      }),
                )),
          ],
        ));
  }

  void _selectItem(index, Excel table) {
    showDialog(
        context: context,
        builder: (_) {
          return Dialog(
              elevation: 0,
              backgroundColor: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ФИО:',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                            table.sheets.values.first.rows
                                .elementAt(index)
                                .elementAt(2)!
                                .props
                                .first
                                .toString(),
                            style: TextStyle(fontSize: 20))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Накладная:',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                            table.sheets.values.first.rows
                                .elementAt(index)
                                .elementAt(15)!
                                .props
                                .first
                                .toString(),
                            style: TextStyle(fontSize: 20))
                      ],
                    ),
                  ),
                  ElevatedButton(onPressed: () {}, child: Text('Подписать'))
                ],
              ));
        });
  }

  void _selectDate(MainBloc bloc) {
    showDialog(
        context: context,
        builder: (_) {
          return Dialog(
              elevation: 0,
              backgroundColor: Colors.white.withOpacity(0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      elevation: 30,
                      child: SfDateRangePicker(
                        onSelectionChanged:
                            (DateRangePickerSelectionChangedArgs arg) {
                          bloc.add(SubmitDateEvent(arg));
                        },
                        selectionMode: DateRangePickerSelectionMode.single,
                      )),
                ],
              ));
        });
  }
}
