import 'package:flutter/material.dart';
import 'package:flutter_task/src/blocs/app_state_provider.dart';
import 'package:flutter_task/src/models/todo.dart';
import 'package:flutter_task/src/utils/helpers.dart';

class DisplayArchiveTodos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final todoBloc = AppStateProvider.of(context);
    return Flexible(
      child: StreamBuilder(
        stream: todoBloc.completedTodos,
        builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
          if (snapshot.hasData && snapshot.data.length > 0) {
            return ListView.builder(
              itemBuilder: (context, index) =>
                  ArchiveCard(todo: snapshot.data[index]),
              itemCount: snapshot.data.length,
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class ArchiveCard extends StatelessWidget {
  final Todo todo;

  ArchiveCard({
    Key key,
    @required this.todo,
  })  : assert(todo != null),
        super(key: key);

  Widget build(BuildContext context) {
    final todoBloc = AppStateProvider.of(context);
    return Dismissible(
      key: Key(todo.todoId.toString()),
      direction: DismissDirection.horizontal,
      onDismissed: (direction) {
        todoBloc.deleteTodo(todo);
      },
      background: Container(
        color: Colors.red,
        child: Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
      ),
      child: Card(
        margin: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
        child: ExpansionTile(
          key: Key(todo.todoId.toString()),
          initiallyExpanded: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    todo.dueDate != null && todo.dueDate != ''
                        ? Padding(
                          padding: EdgeInsets.only(top: 8.0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.calendar_today),
                                    Padding(
                                      padding: EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        Helpers.displayDateFormat(
                                            dateString: todo.dueDate),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        todo.title ?? '',
                        style: Theme.of(context).textTheme.title,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    todo.message ?? '',
                    style: Theme.of(context).textTheme.subhead,
                    softWrap: true,
                  ),
                  Column(
                    children: <Widget>[
                      // Row(
                      //   children: <Widget>[
                      Checkbox(
                        value: todo.completed == 0 ? false : true,
                        onChanged: (value) {
                          todoBloc.changeCompletion(todo);
                        },
                      ),
                      // Text('Completed'),
                      //   ],
                      // )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
