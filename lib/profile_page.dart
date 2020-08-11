import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:virgo/models/friend.dart';
import 'package:virgo/styles.dart';

// ignore: must_be_immutable
class Profile extends StatefulWidget {
  Friend friend;
  Profile({this.friend});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final notesTextFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    notesTextFieldController.text = widget.friend.notes;
  }

  @override
  void dispose() {
    super.dispose();
    notesTextFieldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    Color birthdayColor;
    if (widget.friend.birthday.month == now.month &&
        widget.friend.birthday.day == now.day)
      birthdayColor = themeLilac;
    else {
      DateTime birthday = widget.friend.birthday.toDateTime();
      if (birthday.difference(now).inDays <= 1)
        birthdayColor = themeLilac1;
      else if (birthday.difference(now).inDays <= 7)
        birthdayColor = themeLilac2;
      else if (birthday.month == now.month + 1 || birthday.month == now.month)
        birthdayColor = themeLilac3;
      else
        birthdayColor = themeLilac4;
    }

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(65.0),
          child: AppBar(
            centerTitle: true,
            elevation: 0.0,
            title: Text(
              'Virgo',
              style: GoogleFonts.merriweather(
                  textStyle: TextStyle(
                fontSize: 48,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w900,
              )),
            ),
          ),
        ),
        body: Consumer<FriendsList>(builder: (context, friendsList, child) {
          return SingleChildScrollView(
            child: Container(
              height: (MediaQuery.of(context).size.height - 65) * 0.95,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Flexible(
                    flex: 4,
                    child: Container(
                      color: birthdayColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 62,
                            backgroundColor: Colors.white,
                          ),
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  final nameTextFieldController =
                                      TextEditingController()
                                        ..text = widget.friend.name;
                                  return AlertDialog(
                                    backgroundColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    title: Text(
                                      'Edit name',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    content: TextField(
                                      autofocus: true,
                                      controller: nameTextFieldController,
                                      textInputAction: TextInputAction.done,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    actions: [
                                      RaisedButton(
                                        child: Text('Cancel'),
                                        color: Theme.of(context).primaryColor,
                                        onPressed: () =>
                                            Navigator.of(context).pop(null),
                                      ),
                                      RaisedButton(
                                        child: Text('Confirm'),
                                        color: Theme.of(context).primaryColor,
                                        onPressed: () => Navigator.of(context)
                                            .pop(nameTextFieldController.text),
                                      ),
                                    ],
                                  );
                                },
                              ).then((name) {
                                if (name != null) {
                                  if (widget.friend.name == name) {
                                    Scaffold.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Press the name then enter a new name to change the name.'),
                                      ),
                                    );
                                  } else if (friendsList.isUniqueName(name)) {
                                    setState(() {
                                      friendsList.updateName(
                                          widget.friend, name);
                                    });
                                  } else {
                                    Scaffold.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'This name already exists in your friends list!'),
                                      ),
                                    );
                                  }
                                }
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  widget.friend.name,
                                  style: TextStyle(
                                      fontSize: 36,
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic),
                                ),
                                SizedBox(width: 8.0),
                                Icon(
                                  Icons.edit,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              DateTime selectedDate = await showDatePicker(
                                context: context,
                                initialDate:
                                    widget.friend.birthday.toDateTime(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(DateTime.now().year + 1,
                                    DateTime.now().month, DateTime.now().day),
                              );
                              if (selectedDate != null) {
                                setState(() {
                                  Provider.of<FriendsList>(context,
                                          listen: false)
                                      .updateBirthday(
                                          widget.friend, selectedDate);
                                });
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  widget.friend.birthday.toString(),
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                SizedBox(width: 7.0),
                                widget.friend.birthday.toAstrologyIcon(),
                                SizedBox(width: 5.0),
                                Icon(
                                  Icons.edit,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 6,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Notes: ',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12.0)),
                                        border: Border.all(
                                          color: themeCornfield,
                                          width: 5.0,
                                        ),
                                      ),
                                      child: TextField(
                                        decoration: InputDecoration.collapsed(
                                            hintText: 'Write notes here!'),
                                        textInputAction: TextInputAction.done,
                                        maxLines: null,
                                        controller: notesTextFieldController,
                                        onSubmitted: (text) =>
                                            (Provider.of<FriendsList>(context,
                                                    listen: false)
                                                .updateNotes(
                                                    widget.friend, text)),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    'Notify me: ',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      MyCheckBoxTile(
                                        label: 'in a day',
                                        index: 0,
                                        friend: widget.friend,
                                      ),
                                      MyCheckBoxTile(
                                        label: 'in a week',
                                        index: 1,
                                        friend: widget.friend,
                                      ),
                                      MyCheckBoxTile(
                                        label: 'in a month',
                                        index: 2,
                                        friend: widget.friend,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class MyCheckBoxTile extends StatefulWidget {
  final String label;
  final int index;
  final Friend friend;
  MyCheckBoxTile({this.label, this.index, this.friend});

  @override
  _MyCheckBoxTileState createState() => _MyCheckBoxTileState();
}

class _MyCheckBoxTileState extends State<MyCheckBoxTile> {
  @override
  Widget build(BuildContext context) {
    int f = Provider.of<FriendsList>(context, listen: false)
        .friends
        .indexOf(widget.friend);
    bool _isSelected = Provider.of<FriendsList>(context, listen: false)
        .friends[f]
        .notifyMe[widget.index];
    return InkWell(
      onTap: () {
        setState(() {
          Provider.of<FriendsList>(context, listen: false)
              .updateNotifyMe(widget.friend, widget.index);
        });
      },
      child: Padding(
        padding: EdgeInsets.only(left: 5.0, top: 8.0, bottom: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Text(
                widget.label,
                style: TextStyle(
                  fontSize: 18.0,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 24.0,
              width: 24.0,
              child: Checkbox(
                activeColor: Colors.white,
                checkColor: themeNavy,
                hoverColor: Colors.white,
                focusColor: Colors.white,
                value: _isSelected,
                onChanged: (bool value) {
                  setState(() {
                    Provider.of<FriendsList>(context, listen: false)
                        .updateNotifyMe(widget.friend, widget.index);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
