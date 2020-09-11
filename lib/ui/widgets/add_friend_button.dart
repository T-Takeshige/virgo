import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:virgo/bloc/blocs.dart';
import 'package:virgo/miscellaneous/schedule_notifications.dart';
import 'package:virgo/models/friend.dart';
import 'package:virgo/models/my_date.dart';
import 'package:virgo/ui/widgets/birthday_picker.dart';
import 'package:virgo/ui/widgets/name_dialog.dart';

class AddFriendButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.7,
      child: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          DateTime now = DateTime.now();
          Friend tmpfriend = Friend(
            Uuid().v1(),
            'Friend',
            MyDate(month: now.month, day: now.day),
          );
          showNameDialog(tmpfriend, context).then((name) {
            if (name != null) {
              showDialog(
                context: context,
                builder: (context) => BirthdayPicker(
                  month: tmpfriend.birthday.month,
                  day: tmpfriend.birthday.day,
                ),
              ).then((date) {
                if (date != null) {
                  ScheduleNotifications notifications =
                      Provider.of<ScheduleNotifications>(context,
                          listen: false);
                  var id = makeBirthdayReminder(
                      notifications, name, date, tmpfriend.id);
                  Friend friend = tmpfriend.copyWith(
                      name: name, birthday: date, alertBirthdayId: id);
                  BlocProvider.of<BdayBloc>(context).add(BdayAddedEv(friend));
                }
              });
            }
          });
        },
      ),
    );
  }
}
