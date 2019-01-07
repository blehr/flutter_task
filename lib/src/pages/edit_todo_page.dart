import 'package:flutter/material.dart';
import 'package:flutter_task/src/blocs/app_state_provider.dart';
import 'package:flutter_task/src/blocs/todo_bloc.dart';
import 'package:flutter_task/src/models/todo.dart';
import 'package:flutter_task/src/utils/helpers.dart';
import 'package:flutter_task/src/widgets/shared/controlled_text_field.dart';

class EditTodoPage extends StatelessWidget {
  Future<Null> _selectDate(BuildContext context, TodoBloc stream) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null) {
      stream.changeDueDate(picked.toIso8601String());
    }
  }

  @override
  Widget build(BuildContext context) {
    final todoBloc = AppStateProvider.of(context);
    return WillPopScope(
      onWillPop: () async {
        todoBloc.updateEditingTodo();
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text("Edit Todo"),
          ),
          body: ListView(
            children: <Widget>[
              StreamBuilder(
                stream: todoBloc.singleTodoStream,
                builder: (BuildContext context, AsyncSnapshot<Todo> snapshot) {
                  if (snapshot.hasData) {
                    todoBloc.changeDueDate(snapshot.data.dueDate);
                    return Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Hero(
                            tag: snapshot.data.todoId,
                            child: ControlledTextField(
                              readValues: todoBloc.title,
                              addValues: todoBloc.changeTitle,
                              name: 'Details',
                              initialValue: snapshot.data.title,
                              textStyle: Theme.of(context).textTheme.title,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 8.0, top: 6.0),
                                child: Icon(Icons.short_text),
                              ),
                              Expanded(
                                child: ControlledTextField(
                                  readValues: todoBloc.message,
                                  addValues: todoBloc.changeMessage,
                                  name: 'Details',
                                  initialValue: snapshot.data.message,
                                ),
                              ),
                            ],
                          ),
                          Wrap(
                            spacing: 8.0,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 8.0, top: 10.0),
                                child: Icon(Icons.calendar_today),
                              ),
                              StreamBuilder(
                                stream: todoBloc.dueDate,
                                builder: (BuildContext context,
                                    AsyncSnapshot<String> snap) {
                                  return GestureDetector(
                                    onTap: () => _selectDate(context, todoBloc),
                                    child: Chip(
                                      onDeleted: () =>
                                          todoBloc.changeDueDate(null),
                                      label: Text(
                                        'Due: ' +
                                            Helpers.displayDateFormat(
                                                dateString:
                                                    snap.data.toString()),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.archive),
                                  onPressed: () async {
                                    await todoBloc
                                        .changeCompletion(snapshot.data);
                                    Navigator.pop(context);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete_outline),
                                  onPressed: () async {
                                    await todoBloc.deleteTodo(snapshot.data);
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Container(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ],
          )),
    );
  }
}
