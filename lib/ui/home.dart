import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virgo/bloc/blocs.dart';
import 'package:virgo/models/my_date.dart';
import 'package:virgo/ui/widgets/add_friend_button.dart';
import 'package:virgo/ui/widgets/birthday_list.dart';
import 'package:virgo/ui/widgets/search_bar.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          toolbarHeight: 60,
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
        body: BlocProvider(
          create: (context) => SearchCubit(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              SearchBar(),
              Expanded(child: BirthdayList()),
            ],
          ),
        ),
        floatingActionButton: AddFriendButton(),
      ),
    );
  }
}
