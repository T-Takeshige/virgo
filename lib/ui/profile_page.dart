import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virgo/bloc/blocs.dart';
import 'package:virgo/ui/widgets/birthday_picker.dart';
import 'package:virgo/models/friend.dart';
import 'package:virgo/accessories/styles.dart';

// ignore: must_be_immutable
class Profile extends StatefulWidget {
  Friend friend;
  Profile(this.friend);
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
  void didUpdateWidget(Profile oldWidget) {
    setState(() {});
    super.didUpdateWidget(oldWidget);
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
                  color: Theme.of(context).primaryColor,
                ),
              ),
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
                    color: birthdayColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 63,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Hero(
                            tag: '${widget.friend.id} avatar',
                            placeholderBuilder: (context, heroSize, child) =>
                                CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.white,
                            ),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.white,
                            ),
                          ),
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
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  title: Text(
                                    'Edit name',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  content: TextField(
                                    autofocus: true,
                                    textCapitalization:
                                        TextCapitalization.words,
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
                                } else {
                                  this.widget.friend =
                                      this.widget.friend.copyWith(name: name);
                                  BlocProvider.of<BdayBloc>(context)
                                      .add(BdayUpdatedEv(this.widget.friend));
                                  setState(() {});
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
                            showDialog(
                              context: context,
                              builder: (context) => BirthdayPicker(
                                month: widget.friend.birthday.month,
                                day: widget.friend.birthday.day,
                              ),
                            ).then((date) {
                              if (date != null) {
                                this.widget.friend =
                                    this.widget.friend.copyWith(birthday: date);
                                BlocProvider.of<BdayBloc>(context)
                                    .add(BdayUpdatedEv(this.widget.friend));
                                setState(() {});
                              }
                            });
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
                                    padding: EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                      border: Border.all(
                                        color: Theme.of(context).primaryColor,
                                        width: 3.0,
                                      ),
                                    ),
                                    child: TextField(
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      decoration: InputDecoration.collapsed(
                                          hintText: 'Write notes here!'),
                                      textInputAction: TextInputAction.done,
                                      maxLines: null,
                                      controller: notesTextFieldController,
                                      onSubmitted: (text) {
                                        this.widget.friend = this
                                            .widget
                                            .friend
                                            .copyWith(notes: text);
                                        BlocProvider.of<BdayBloc>(context).add(
                                            BdayUpdatedEv(this.widget.friend));
                                      },
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
                                      onChanged: () {
                                        List<bool> notifyMe = [
                                          ...this.widget.friend.notifyMe
                                        ];
                                        notifyMe[0] ^= true;
                                        this.widget.friend = this
                                            .widget
                                            .friend
                                            .copyWith(notifyMe: notifyMe);
                                        BlocProvider.of<BdayBloc>(context).add(
                                            BdayUpdatedEv(this.widget.friend));
                                        setState(() {});
                                      },
                                    ),
                                    MyCheckBoxTile(
                                      label: 'in a week',
                                      index: 1,
                                      friend: widget.friend,
                                      onChanged: () {
                                        List<bool> notifyMe = [
                                          ...this.widget.friend.notifyMe
                                        ];
                                        notifyMe[1] ^= true;
                                        this.widget.friend = this
                                            .widget
                                            .friend
                                            .copyWith(notifyMe: notifyMe);
                                        BlocProvider.of<BdayBloc>(context).add(
                                            BdayUpdatedEv(this.widget.friend));
                                        setState(() {});
                                      },
                                    ),
                                    MyCheckBoxTile(
                                      label: 'in a month',
                                      index: 2,
                                      friend: widget.friend,
                                      onChanged: () {
                                        List<bool> notifyMe = [
                                          ...this.widget.friend.notifyMe
                                        ];
                                        notifyMe[2] ^= true;
                                        this.widget.friend = this
                                            .widget
                                            .friend
                                            .copyWith(notifyMe: notifyMe);
                                        BlocProvider.of<BdayBloc>(context).add(
                                            BdayUpdatedEv(this.widget.friend));
                                        setState(() {});
                                      },
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

class MyCheckBoxTile extends StatelessWidget {
  final String label;
  final int index;
  final Friend friend;
  final Function onChanged;
  MyCheckBoxTile({this.label, this.index, this.friend, this.onChanged});

  @override
  Widget build(BuildContext context) {
    bool _isSelected = friend.notifyMe[index];
    return InkWell(
      onTap: () {
        onChanged();
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
                label,
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
              child: Theme(
                data: ThemeData(
                  unselectedWidgetColor: Theme.of(context).primaryColor,
                ),
                child: Checkbox(
                  activeColor: Theme.of(context).primaryColor,
                  checkColor: Colors.white,
                  value: _isSelected,
                  onChanged: (bool value) {
                    onChanged();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
