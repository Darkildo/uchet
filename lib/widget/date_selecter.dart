import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sklad_uchet/service/main_bloc/bloc/main_bloc.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class Dateselecter extends StatefulWidget {
  Dateselecter({Key? key}) : super(key: key);

  @override
  _DateselecterState createState() => _DateselecterState();
}

class _DateselecterState extends State<Dateselecter> {
  bool dateselecter = false;
  DateRangePickerSelectionChangedArgs? currentDate;
  void _updatedate(DateRangePickerSelectionChangedArgs newDate) {
    setState(() {
      currentDate = newDate;
      this.dateselecter = true;
    });
  }

  void _submitDate() {
    BlocProvider.of<MainBloc>(context).add(SubmitDateEvent(this.currentDate!));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(),
        Card(
            margin: EdgeInsets.symmetric(horizontal: 10),
            elevation: 30,
            child: SfDateRangePicker(
              onSelectionChanged: (DateRangePickerSelectionChangedArgs arg) {
                print(arg.value.toString());
                _updatedate(arg);
              },
              selectionMode: DateRangePickerSelectionMode.single,
            )),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.05),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: (dateselecter) ? Colors.blue : Colors.blueGrey.shade500,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0),
              ),
              padding: const EdgeInsets.all(10.0),
            ),
            onPressed: dateselecter ? _submitDate : null,
            child: Text('Подтвердить Выбор'),
          ),
        ),
        Spacer()
      ],
    );
  }
}
