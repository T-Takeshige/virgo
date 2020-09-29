import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virgo/accessories/styles.dart';
import 'package:virgo/bloc/profile/profile.dart';
import 'package:virgo/models/friend.dart';
import 'package:virgo/ui/shared/birthday_picker.dart';

// The inkwell in the profile page showing the birthday that when pressed,
// allows users to change the birthday of that friend
class BirthdayInkWell extends StatelessWidget {
  final Friend friend;
  BirthdayInkWell(this.friend);

  @override
  Widget build(BuildContext context) {
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
            BlocProvider.of<ProfileCubit>(context)
                .updateFriend(friend.copyWith(birthday: date));
          }
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            friend.birthday.toString(),
            style: GoogleFonts.merriweatherSans(
              textStyle: TextStyle(
                fontSize: 24,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w800,
                color: themeWhite,
              ),
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
