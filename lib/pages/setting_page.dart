import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sklad_uchet/service/main_bloc/bloc/main_bloc.dart';
import 'package:sklad_uchet/widget/numpad_widget.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () =>
                  _changePassword(BlocProvider.of<MainBloc>(context)),
              child: Text('Сменить пароль')),
          ElevatedButton(
              onPressed: () =>
                  _changeTableParam(BlocProvider.of<MainBloc>(context)),
              child: Text('Изменить столбцы')),
          ElevatedButton(
              onPressed: () =>
                  BlocProvider.of<MainBloc>(context).add(SignOutEvent()),
              child: Text('Выход'))
        ],
      ),
    );
  }

  void _changePassword(MainBloc bloc) {
    showDialog(
        context: context,
        builder: (_) {
          return Dialog(
              elevation: 5,
              backgroundColor: Colors.white.withOpacity(0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      elevation: 30,
                      child: PinCodeNumpad((s) {
                        if (s.length >= 4) {
                          BlocProvider.of<MainBloc>(context)
                              .add(ChangePinEvent(s));
                          Navigator.pop(context);
                        }
                      }),
                    ),
                  )
                ],
              ));
        });
  }

  void _changeTableParam(MainBloc bloc) {
    showDialog(
        context: context,
        builder: (_) {
          List<int> indexes = [0, 0, 0];
          return Dialog(
              elevation: 5,
              backgroundColor: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Индекс ФИО',
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
                        ),
                        onChanged: (val) {
                          indexes[0] = int.tryParse(val) ?? 0;
                        },
                      )),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Индекс накладной',
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
                        ),
                        onChanged: (val) {
                          indexes[1] = int.tryParse(val) ?? 0;
                        },
                      )),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Индекс подписи',
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
                        ),
                        onChanged: (val) {
                          indexes[2] = int.tryParse(val) ?? 0;
                        },
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Отмена')),
                      ElevatedButton(
                          onPressed: () {
                            bloc.add(UpdateTableIndexEvent(indexes));
                            Navigator.pop(context);
                          },
                          child: Text('Сохранить'))
                    ],
                  )
                ],
              ));
        });
  }
}
