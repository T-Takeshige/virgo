import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:virgo/accessories/astrology_icons.dart';
import 'package:virgo/models/friend.dart';

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
        body: SingleChildScrollView(
          child: Container(
            height: (MediaQuery.of(context).size.height - 65) * 0.95,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  flex: 4,
                  child: Container(
                    color: Theme.of(context).accentColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 62,
                          backgroundColor: Colors.white,
                        ),
                        Text(
                          widget.friend.name,
                          style: TextStyle(
                              fontSize: 36,
                              color: Colors.white,
                              fontStyle: FontStyle.italic),
                        ),
                        InkWell(
                          onTap: () async {
                            DateTime selectedDate = await showDatePicker(
                              context: context,
                              initialDate: widget.friend.birthday.toDateTime(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(DateTime.now().year + 1,
                                  DateTime.now().month, DateTime.now().day),
                            );
                            if (selectedDate != null) {
                              setState(() {
                                Provider.of<FriendsList>(context, listen: false)
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
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
                                        color: Color(0xff9DD092),
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
        ),
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
                checkColor: Theme.of(context).accentColor,
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
