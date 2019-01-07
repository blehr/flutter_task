import 'dart:async';

import 'package:flutter/material.dart';

class ControlledTextField extends StatefulWidget {
  ControlledTextField(
      {Key key,
      this.readValues,
      this.addValues,
      this.name,
      this.initialValue,
      this.shouldFocus,
      this.focusNode,
      this.textStyle})
      : super(key: key);

  final Stream<String> readValues;

  final Function(String) addValues;

  final String name;

  final String initialValue;

  final TextStyle textStyle;

  final bool shouldFocus;

  final FocusNode focusNode;

  @override
  _ControlledTextFieldState createState() => _ControlledTextFieldState();
}

class _ControlledTextFieldState extends State<ControlledTextField> {
  TextEditingController textController = TextEditingController();

  StreamSubscription listener;

  @override
  void initState() {
    super.initState();
    listener = widget.readValues.listen((text) async {
      if (text == null) {
        textController.clear();
      }
    });

    if (widget.initialValue != null) {
      textController.text = widget.initialValue;
      widget.addValues(widget.initialValue);
    }
  }

  void dispose() {
    super.dispose();
    listener.cancel();
    widget.addValues(null);
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.readValues,
      builder: (context, snapshot) {
        return TextField(
          onChanged: widget.addValues,
          textCapitalization: TextCapitalization.sentences,
          keyboardType: TextInputType.multiline,
          controller: textController,
          autofocus: widget.shouldFocus != null ? true : false,
          autocorrect: true,
          maxLines: null,
          textInputAction: TextInputAction.newline,
          style: widget.textStyle != null ? widget.textStyle : null,
          focusNode: widget.focusNode != null ? widget.focusNode : null,
          decoration: InputDecoration(
            hintText: widget.name,
            border: InputBorder.none,
            errorText: snapshot.error,
            isDense: true,
          ),
        );
      },
    );
  }
}
