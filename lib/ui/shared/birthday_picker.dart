import 'package:flutter/material.dart';
import 'package:virgo/models/my_date.dart';

// ignore: must_be_immutable
class BirthdayPicker extends StatefulWidget {
  int month;
  int day;
  BirthdayPicker({this.month, this.day});

  @override
  _BirthdayPickerState createState() => _BirthdayPickerState();
}

class _BirthdayPickerState extends State<BirthdayPicker> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(
        'Change birthday',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      content: SizedBox(
        height: 180,
        width: 120,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 50,
              child: ListWheelScrollView.useDelegate(
                itemExtent: 40,
                controller:
                    FixedExtentScrollController(initialItem: widget.month),
                physics: FixedExtentScrollPhysics(),
                squeeze: 1.4,
                useMagnifier: true,
                magnification: 1.2,
                perspective: 0.01,
                diameterRatio: 1.4,
                childDelegate: ListWheelChildBuilderDelegate(
                  builder: (context, index) {
                    if (index < 1 || index > 12) {
                      return null;
                    }
                    return Center(
                      child: Text(
                        monthToString[index],
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
                onSelectedItemChanged: (month) {
                  if (widget.month != month) {
                    setState(() {
                      widget.month = month;
                      widget.day = widget.day <= lengthOfMonth[widget.month]
                          ? widget.day
                          : lengthOfMonth[widget.month];
                    });
                  }
                },
              ),
            ),
            SizedBox(
              width: 50,
              child: ListWheelScrollView.useDelegate(
                itemExtent: 40,
                controller: FixedExtentScrollController(
                  initialItem: widget.day,
                ),
                physics: FixedExtentScrollPhysics(),
                squeeze: 1.4,
                useMagnifier: true,
                magnification: 1.2,
                perspective: 0.01,
                diameterRatio: 1.4,
                childDelegate: ListWheelChildBuilderDelegate(
                  builder: (context, index) {
                    if (index < 1 || index > lengthOfMonth[widget.month]) {
                      return null;
                    }
                    return Center(
                      child: Text(
                        index.toString(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
                onSelectedItemChanged: (day) {
                  if (widget.day != day) {
                    setState(() {
                      widget.day = day;
                    });
                  }
                },
              ),
            ),
          ],
        ),
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
          onPressed: () => Navigator.of(context).pop(MyDate(
            month: widget.month,
            day: widget.day,
          )),
        ),
      ],
    );
  }
}
