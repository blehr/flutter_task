import 'package:flutter/material.dart';
import 'todo_bloc.dart';

class AppStateProvider extends InheritedWidget {
  final todoBloc = TodoBloc();

  AppStateProvider({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static TodoBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(AppStateProvider)
            as AppStateProvider)
        .todoBloc;
  }
}