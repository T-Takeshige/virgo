import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:virgo/bloc/blocs.dart';
import 'package:virgo/miscellaneous/schedule_notifications.dart';
import 'package:virgo/models/friend.dart';
import 'package:virgo/models/my_date.dart';
import 'package:virgo/ui/widgets/birthday_list.dart';
import 'package:virgo/ui/widgets/birthday_picker.dart';
import 'package:virgo/ui/widgets/name_dialog.dart';

// import 'package:virgo/ui/widgets/loading.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        toolbarHeight: 72,
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
      body: BirthdayList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
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
                  var id = notifications.schedule(
                    date.toDateTime(),
                    title: "It's $name's birthday!",
                    body: "Wish them a happy birthday!",
                    payload: tmpfriend.id,
                  );
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
