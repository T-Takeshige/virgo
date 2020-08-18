import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:virgo/models/friend.dart';

showNameDialog(Friend friend, BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      final nameTextFieldController = TextEditingController()
        ..text = friend.name;
      return AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Edit name',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          controller: nameTextFieldController,
          textInputAction: TextInputAction.done,
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          RaisedButton(
            child: Text('Cancel'),
            color: Theme.of(context).primaryColor,
            onPressed: () => Navigator.of(context).pop(null),
          ),
          RaisedButton(
            child: Text('Confirm'),
            color: Theme.of(context).primaryColor,
            onPressed: () =>
                Navigator.of(context).pop(nameTextFieldController.text),
          ),
        ],
      );
    },
  );
}
