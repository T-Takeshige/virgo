import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virgo/models/my_date.dart';
import 'package:virgo/ui/widgets/add_friend_button.dart';
import 'package:virgo/ui/widgets/birthday_list.dart';

// import 'package:virgo/ui/widgets/loading.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        toolbarHeight: 72,
        title: Text(
          'Today is: ${dateTimeToString(today)}',
          style: GoogleFonts.merriweatherSans(
            textStyle: TextStyle(
              fontSize: 32,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w900,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
      body: BirthdayList(),
      floatingActionButton: AddFriendButton(),
    );
  }
}
