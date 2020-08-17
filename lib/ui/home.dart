import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import 'package:virgo/bloc/blocs.dart';
import 'package:virgo/models/friend.dart';
import 'package:virgo/models/my_date.dart';
import 'package:virgo/ui/widgets/birthday_list.dart';

// import 'package:virgo/ui/widgets/loading.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(110.0),
        child: AppBar(
          centerTitle: true,
          elevation: 0.0,
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
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(30.0),
            child: Container(
              padding: EdgeInsets.all(4.0),
              color: Theme.of(context).primaryColor,
              child: Text(
                'Today is ${dateTimeToString(now)}',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
        ),
      ),
      body: BirthdayList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Friend friend = Friend(
            Uuid().v1(),
            'Tak',
            MyDate(month: 9, day: 5),
          );
          BlocProvider.of<BdayBloc>(context).add(BdayAddedEv(friend));
        },
      ),
    );
  }
}
