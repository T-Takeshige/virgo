import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:virgo/bloc/blocs.dart';
import 'package:virgo/miscellaneous/schedule_notifications.dart';
import 'package:virgo/models/friend.dart';

class NotifymeCheckboxes extends StatefulWidget {
  final Friend friend;
  NotifymeCheckboxes(this.friend);

  @override
  _NotifymeCheckboxesState createState() => _NotifymeCheckboxesState();
}

class _NotifymeCheckboxesState extends State<NotifymeCheckboxes> {
  // Friend friend = friend;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        MyCheckBoxTile(
          label: 'a day before',
          index: 0,
          friend: widget.friend,
          onChanged: () {
            ScheduleNotifications notifications =
                Provider.of<ScheduleNotifications>(context, listen: false);
            _updateAndNotify(notifications, this.widget.friend, 0);
            BlocProvider.of<BdayBloc>(context)
                .add(BdayUpdatedEv(this.widget.friend));
            setState(() {});
          },
        ),
        MyCheckBoxTile(
          label: 'a week before',
          index: 1,
          friend: widget.friend,
          onChanged: () {
            ScheduleNotifications notifications =
                Provider.of<ScheduleNotifications>(context, listen: false);
            _updateAndNotify(notifications, this.widget.friend, 1);
            BlocProvider.of<BdayBloc>(context)
                .add(BdayUpdatedEv(this.widget.friend));
            setState(() {});
          },
        ),
        MyCheckBoxTile(
          label: 'a month before',
          index: 2,
          friend: widget.friend,
          onChanged: () {
            ScheduleNotifications notifications =
                Provider.of<ScheduleNotifications>(context, listen: false);
            _updateAndNotify(notifications, this.widget.friend, 2);
            BlocProvider.of<BdayBloc>(context)
                .add(BdayUpdatedEv(this.widget.friend));
            setState(() {});
          },
        ),
      ],
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
    bool _isSelected = friend.notifyMeId[index] != null;
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

// This function is to update the widget's Friend object and to
// update the notifications accordingly, depending on the checkbox checked
void _updateAndNotify(
    ScheduleNotifications notifications, Friend friend, int index) {
  if (friend.notifyMeId[index] == null) {
    // if notifyMeId is null,
    // schedule a notification and store the notification id
    DateTime notificationDate;
    if (index == 0)
      notificationDate = friend.birthday.toDateTimeOfBefore(0, 1);
    else if (index == 1)
      notificationDate = friend.birthday.toDateTimeOfBefore(0, 7);
    else if (index == 2)
      notificationDate = friend.birthday.toDateTimeOfBefore(1, 0);
    var id = notifications.schedule(
      notificationDate,
      title: _makeNotificationTitle(friend, index),
      body: 'Begin preparing something for them!',
      payload: friend.id,
    );
    friend.notifyMeId[index] = id;
  } else {
    // if notifyMeId is not null,
    // cancel the notification using the stored notification id
    notifications.cancel(friend.notifyMeId[index]);
    friend.notifyMeId[index] = null;
  }
}

String _makeNotificationTitle(Friend friend, int index) {
  Map<int, String> recency = {
    0: 'in a day',
    1: 'in a week',
    2: 'in a month',
  };

  return '${friend.name}\'s birthday (${friend.birthday.toString()}) is ${recency[index]}!';
}
