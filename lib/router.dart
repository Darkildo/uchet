import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sklad_uchet/enum/pages_enum.dart';
import 'package:sklad_uchet/pages/main_page.dart';
import 'package:sklad_uchet/pages/pin_page.dart';
import 'package:sklad_uchet/service/main_bloc/bloc/main_bloc.dart';

class PageRouter extends StatelessWidget {
  const PageRouter() : super();

  @override
  Widget build(BuildContext context) {
    Widget pager(MainState state) {
      if (state is MainInitial) {
        return Center(
          child: Text('App is loading!'),
        );
      }
      if (state is LoadedAppState) {
        switch (state.currentPage) {
          case PageList.pinpage:
            return PinCodePage();

          case PageList.MainAppPage:
            return MainPage();
          default:
            return Center(
              child: Text('App is loaded!'),
            );
        }
      }
      return Text('errorState');
    }

    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        return pager(
          BlocProvider.of<MainBloc>(context).state,
        );
      },
    );
  }
}
