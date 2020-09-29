import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virgo/accessories/styles.dart';
import 'package:virgo/bloc/profile/profile_cubit.dart';
import 'package:virgo/models/friend.dart';
import 'package:virgo/ui/shared/name_dialog.dart';

// The inkwell in the profile page showing the name that when pressed,
// allows users to change the name of that friend

class NameInkWell extends StatelessWidget {
  final Friend friend;
  NameInkWell(this.friend);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showNameDialog(friend, context).then((name) {
          if (name != null) {
            if (friend.name == name) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(milliseconds: 1500),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.warning,
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Name has not been changed.',
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: 16,
                            ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              BlocProvider.of<ProfileCubit>(context)
                  .updateFriend(friend.copyWith(name: name));
            }
          }
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            friend.name,
            style: GoogleFonts.merriweatherSans(
              textStyle: TextStyle(
                fontSize: 36,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w800,
                color: themeWhite,
              ),
            ),
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
