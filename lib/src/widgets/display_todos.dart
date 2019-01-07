import 'package:flutter/material.dart';
import 'package:flutter_task/src/blocs/app_state_provider.dart';
import 'package:flutter_task/src/models/todo.dart';
import 'package:flutter_task/src/utils/helpers.dart';

class DisplayTodos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final todoBloc = AppStateProvider.of(context);
    return Flexible(
      child: StreamBuilder(
        stream: todoBloc.todoStream,
        builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
          if (snapshot.hasData && snapshot.data.length > 0) {
            return ListView.builder(
              itemBuilder: (context, index) =>
                  TodoCard(todo: snapshot.data[index]),
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

class TodoCard extends StatelessWidget {
  final Todo todo;

  TodoCard({
    Key key,
    @required this.todo,
  })  : assert(todo != null),
        super(key: key);

  Color computeDateColor(dateString) {
    if (dateString == null || dateString == '') {
      return Colors.transparent;
    }
    
    DateTime now = DateTime.now();
    DateTime todoDate = DateTime.parse(dateString);

    int dayDiff = todoDate.difference(DateTime(now.year, now.month, now.day)).inDays;

    if (dayDiff < 0) {
      return Colors.red;
    }

    if (dayDiff == 0) {
      return Colors.blue;
    }

    return Colors.black54;
  }

  Widget build(BuildContext context) {
    final todoBloc = AppStateProvider.of(context);
    return Dismissible(
      key: Key(todo.todoId.toString()),
      direction: DismissDirection.horizontal,
      onDismissed: (direction) {
        todoBloc.changeCompletion(todo);
      },
      background: Container(
        color: Colors.greenAccent,
        child: Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.archive,
              color: Colors.white,
            ),
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Theme.of(context).dividerColor),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(8.0),
          highlightColor: Theme.of(context).accentColor,
          splashColor: Theme.of(context).primaryColor,
          onTap: () {
            todoBloc.addSingleTodo(todo);
            Navigator.pushNamed(context, '/edit');
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                todo.dueDate != null && todo.dueDate != ''
                    ? Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                          Icon(Icons.calendar_today,
                              color: computeDateColor(todo.dueDate)),
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              Helpers.displayDateFormat(
                                  dateString: todo.dueDate),
                              style: TextStyle(fontWeight: FontWeight.normal),
                            ),
                          )
                        ],
                      )
                    : Container(),
                Hero(
                  tag: todo.todoId,
                  child: Text(
                    todo.title ?? '',
                    style: Theme.of(context).textTheme.title,
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
