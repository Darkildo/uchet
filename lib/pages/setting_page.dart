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
          ElevatedButton(onPressed: () {}, child: Text('Изменить столбцы')),
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
}
