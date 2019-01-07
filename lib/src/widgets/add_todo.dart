import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_task/src/blocs/app_state_provider.dart';
import 'package:flutter_task/src/utils/helpers.dart';
import 'package:flutter_task/src/widgets/shared/controlled_text_field.dart';

class AddTodo extends StatefulWidget {
  AddTodo({Key key}) : super(key: key);

  @override
  AddTodoState createState() => AddTodoState();
}

class AddTodoState extends State<AddTodo> with TickerProviderStateMixin {
  bool showMessage = false;
  bool showOptions = false;

  FocusNode titleFocusNode;
  FocusNode messageFocusNode;

  AnimationController _rotationController;
  AnimationController _animationOptionsController;
  Animation<Offset> _offset;
  Animation<double> _turns;

  @override
  void initState() {
    super.initState();
    _animationOptionsController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _offset = Tween<Offset>(begin: Offset(-1.5, 0.0), end: Offset.zero)
        .animate(_animationOptionsController);

    _rotationController = AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
        upperBound: pi / 4);
    _turns = Tween(begin: 0.0, end: pi / 4).animate(_rotationController);

    titleFocusNode = FocusNode();
    messageFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _animationOptionsController.dispose();
    _rotationController.dispose();
    titleFocusNode.dispose();
    messageFocusNode.dispose();
    super.dispose();
  }

  void toggleOptions() {
    setState(() {
      showOptions = !showOptions;
    });

    switch (_animationOptionsController.status) {
      case AnimationStatus.completed:
        _animationOptionsController.reverse();
        _rotationController.reverse();
        break;
      case AnimationStatus.dismissed:
        _animationOptionsController.forward();
        _rotationController.forward();
        break;
      default:
    }
  }

  void toggleShowMessage() {
    setState(() {
      showMessage = !showMessage;
    });
  }

  Future<String> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null) {
      return picked.toIso8601String();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final todoBloc = AppStateProvider.of(context);
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ControlledTextField(
            readValues: todoBloc.title,
            addValues: todoBloc.changeTitle,
            name: 'Task',
            shouldFocus: true,
            focusNode: titleFocusNode,
          ),
          AnimatedSize(
            curve: Curves.fastOutSlowIn,
            child: new Container(
              height: showMessage ? null : 0.0,
              child: showMessage
                  ? ControlledTextField(
                      readValues: todoBloc.message,
                      addValues: todoBloc.changeMessage,
                      name: 'Details',
                      focusNode: messageFocusNode,
                    )
                  : Container(),
            ),
            vsync: this,
            duration: new Duration(milliseconds: 800),
          ),
          AnimatedSize(
            curve: Curves.fastOutSlowIn,
            child: StreamBuilder(
              stream: todoBloc.dueDate,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    child: Chip(
                      onDeleted: () => todoBloc.changeDueDate(null),
                      label: Text(
                        'Due: ' +
                            Helpers.displayDateFormat(
                                dateString: snapshot.data),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  );
                } else {
                  return Container(
                    height: 0.0,
                  );
                }
              },
            ),
            vsync: this,
            duration: new Duration(milliseconds: 800),
          ),
          ButtonTheme.bar(
            child: ButtonBar(
              alignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    RotationTransition(
                      turns: _turns,
                      child: IconButton(
                        icon: Icon(Icons.add_circle_outline),
                        color: showOptions
                            ? Theme.of(context).disabledColor
                            : Theme.of(context).primaryColor,
                        onPressed: toggleOptions,
                      ),
                    ),
                    SlideTransition(
                      position: _offset,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          children: <Widget>[
                            AnimatedOpacity(
                              opacity: showOptions ? 1 : 0,
                              duration: showOptions
                                  ? Duration(milliseconds: 1500)
                                  : Duration(milliseconds: 150),
                              child: IconButton(
                                  icon: Icon(Icons.short_text),
                                  color: Theme.of(context).primaryColor,
                                  onPressed: () {
                                    toggleShowMessage();
                                    Timer(Duration(milliseconds: 800), () {
                                      showMessage
                                          ? FocusScope.of(context)
                                              .requestFocus(messageFocusNode)
                                          : FocusScope.of(context)
                                              .requestFocus(titleFocusNode);
                                    });
                                  }),
                            ),
                            AnimatedOpacity(
                              opacity: showOptions ? 1 : 0,
                              duration: showOptions
                                  ? Duration(milliseconds: 1200)
                                  : Duration(milliseconds: 150),
                              child: IconButton(
                                  icon: Icon(Icons.calendar_today),
                                  color: Theme.of(context).primaryColor,
                                  onPressed: () async {
                                    var date = await _selectDate(context);
                                    if (date != null) {
                                      todoBloc.changeDueDate(date);
                                    }
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    FlatButton(
                      child: Text('Save'),
                      onPressed: () async {
                        var res = await todoBloc.submitTodo();
                        if (res != null) {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                    FlatButton(
                      onPressed: () => todoBloc.clearAddTodo(),
                      child: Text("Clear"),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
