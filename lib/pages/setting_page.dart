import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ElevatedButton(onPressed: () {}, child: Text('Сменить пароль')),
          ElevatedButton(onPressed: () {}, child: Text('Изменить столбцы')),
          ElevatedButton(onPressed: () {}, child: Text('Выход'))
        ],
      ),
    );
  }
}
