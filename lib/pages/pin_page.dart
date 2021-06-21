import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import 'package:sklad_uchet/service/main_bloc/bloc/main_bloc.dart';
import 'package:sklad_uchet/widget/numpad_widget.dart';

class PinCodePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Spacer(/*flex: 174*/),
              Padding(
                padding: EdgeInsets.only(bottom: 29.0),
                child: Text('Введите pin код'),
              ),
              // Spacer(/*flex: 440*/),
              (PinCodeNumpad((s) {
                BlocProvider.of<MainBloc>(context).add(InputPinEvent(s));
              }))
            ],
          );
        },
      ),
    );
  }
}
