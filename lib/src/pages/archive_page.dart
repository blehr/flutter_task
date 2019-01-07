import 'package:flutter/material.dart';
import 'package:flutter_task/src/blocs/app_state_provider.dart';
import 'package:flutter_task/src/widgets/display_archive_todos.dart';

class ArchivePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final todoBloc = AppStateProvider.of(context);
    todoBloc.getCompletedTodos();
    return Scaffold(
      appBar: AppBar(
        title: Text("Archive"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          DisplayArchiveTodos(),
        ],
      ),
    );
  }
}
