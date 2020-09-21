import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:virgo/bloc/blocs.dart';
import 'package:virgo/miscellaneous/schedule_notifications.dart';
import 'package:virgo/models/friend.dart';
import 'package:virgo/ui/widgets/name_dialog.dart';

// The inkwell in the profile page showing the name that when pressed,
// allows users to change the name of that friend
// ignore: must_be_immutable
class NameInkWell extends StatefulWidget {
  Friend friend;
  NameInkWell(this.friend);
  @override
  _NameInkWellState createState() => _NameInkWellState();
}

class _NameInkWellState extends State<NameInkWell> {
  @override
  Widget build(BuildContext context) {
    Friend friend = this.widget.friend;
    return InkWell(
      onTap: () {
        showNameDialog(friend, context).then((name) {
          if (name != null) {
            if (friend.name == name) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Press the name then enter a new name to change the name.'),
                ),
              );
            } else {
              try {
                ScheduleNotifications notifications =
                    Provider.of<ScheduleNotifications>(context, listen: false);
                List<int> notifyMeIds = [null, null, null];
                int alertBirthdayId;

                // Cancel old notifications and create new ones based on the new birthday
                notifications.cancel(friend.alertBirthdayId);
                alertBirthdayId = makeBirthdayReminder(
                    notifications, friend.name, friend.birthday, friend.id);
                for (var i = 0; i < notifyMeIds.length; i++) {
                  if (friend.notifyMeId[i] != null) {
                    notifications.cancel(friend.notifyMeId[i]);
                    makeBirthdayReminder(
                        notifications, friend.name, friend.birthday, friend.id,
                        recency: i);
                  }
                }

                this.widget.friend = friend.copyWith(
                    name: name,
                    notifyMeId: List.from(notifyMeIds),
                    alertBirthdayId: alertBirthdayId);

                BlocProvider.of<BdayBloc>(context)
                    .add(BdayUpdatedEv(this.widget.friend));
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Name is successfully updated!'),
                ));
                setState(() {});
              } catch (e) {
                print(e);
              }
            }
          }
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            this.widget.friend.name,
            style: TextStyle(
                fontSize: 36, color: Colors.white, fontStyle: FontStyle.italic),
          ),
          SizedBox(width: 8.0),
          Icon(
            Icons.edit,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
