import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:virgo/bloc/blocs.dart';
import 'package:virgo/miscellaneous/schedule_notifications.dart';
import 'package:virgo/models/friend.dart';
import 'package:virgo/ui/widgets/birthday_picker.dart';

// The inkwell in the profile page showing the birthday that when pressed,
// allows users to change the birthday of that friend
// ignore: must_be_immutable
class BirthdayInkWell extends StatefulWidget {
  Friend friend;
  BirthdayInkWell(this.friend);
  @override
  _BirthdayInkWellState createState() => _BirthdayInkWellState();
}

class _BirthdayInkWellState extends State<BirthdayInkWell> {
  @override
  Widget build(BuildContext context) {
    Friend friend = this.widget.friend;
    return InkWell(
      onTap: () async {
        showDialog(
          context: context,
          builder: (context) => BirthdayPicker(
            month: friend.birthday.month,
            day: friend.birthday.day,
          ),
        ).then((date) {
          if (date != null) {
            friend = friend.copyWith(birthday: date);

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

            this.widget.friend = this.widget.friend = friend.copyWith(
                notifyMeId: List.from(notifyMeIds),
                alertBirthdayId: alertBirthdayId);

            BlocProvider.of<BdayBloc>(context).add(BdayUpdatedEv(friend));
            setState(() {});
          }
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            friend.birthday.toString(),
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(width: 7.0),
          friend.birthday.toAstrologyIcon(),
          SizedBox(width: 5.0),
          Icon(
            Icons.edit,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
