import 'package:flutter/material.dart';
import 'package:flutter_task/src/blocs/app_state_provider.dart';
import 'package:flutter_task/src/widgets/add_todo.dart';
import 'package:flutter_task/src/widgets/display_todos.dart';

class MyHomePage extends StatelessWidget {
  void _showModalSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return AddTodo();
        });
  }

  @override
  Widget build(BuildContext context) {
    final todoBloc = AppStateProvider.of(context);
    todoBloc.getIncompleteTodos();
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Task"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          DisplayTodos(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.archive),
              onPressed: () {
                Navigator.pushNamed(context, '/archive');
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showModalSheet(context),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
