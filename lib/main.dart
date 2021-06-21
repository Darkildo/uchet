import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sklad_uchet/enum/pages_enum.dart';
import 'package:sklad_uchet/enum/pages_enum.dart';
import 'package:sklad_uchet/pages/pin_page.dart';
import 'package:sklad_uchet/router.dart';
import 'package:sklad_uchet/service/main_bloc/bloc/main_bloc.dart';
import 'package:sklad_uchet/widget/numpad_widget.dart';

void main() {
  runApp(BlocProvider(
      create: (context) => MainBloc()..add(StartBlocEvent()), child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: Scaffold(
            bottomNavigationBar:
                BlocProvider.of<MainBloc>(context).currentPage.index ==
                        PageList.MainAppPage.index
                    ? BottomNavigationBar(
                        items: <BottomNavigationBarItem>[
                          BottomNavigationBarItem(
                            icon: Icon(Icons.task),
                            label: 'Учёт',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.settings),
                            label: 'Настройки',
                          ),
                        ],
                        onTap: (index) {
                          BlocProvider.of<MainBloc>(context)
                              .add(ChangePageEvent(index));
                        },
                        currentIndex: (BlocProvider.of<MainBloc>(context).state
                                as LoadedAppState)
                            .currentPageIndex,
                      )
                    : null,
            body: PageRouter(),
          ),
        );
      },
    );
  }
}
