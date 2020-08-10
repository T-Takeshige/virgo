import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virgo/models/friend.dart';

class Profile extends StatefulWidget {
  Friend friend;
  Profile({this.friend});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              flex: 4,
              child: Container(
                color: Theme.of(context).accentColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    Text(
                      widget.friend.birthday.toString(),
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 6,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                  border: Border.all(
                                    color: Color(0xff9DD092),
                                    width: 5.0,
                                  ),
                                ),
                                child: Text(widget.friend.notes),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          'Notify me: ',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontStyle: FontStyle.italic,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              MyCheckBoxTile(
                                label: 'in a day',
                              ),
                              SizedBox(height: 16.0),
                              MyCheckBoxTile(
                                label: 'in a week',
                              ),
                              SizedBox(height: 16.0),
                              MyCheckBoxTile(
                                label: 'in a month',
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 40.0)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MyCheckBoxTile extends StatefulWidget {
  final String label;
  MyCheckBoxTile({this.label});

  @override
  _MyCheckBoxTileState createState() => _MyCheckBoxTileState();
}

class _MyCheckBoxTileState extends State<MyCheckBoxTile> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
        });
      },
      child: Padding(
        padding: EdgeInsets.only(left: 5.0),
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
                    _isSelected = !_isSelected;
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
