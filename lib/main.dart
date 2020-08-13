import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virgo/models/my_date.dart';
import 'package:virgo/models/friend.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:virgo/ui/home.dart';

import 'package:virgo/accessories/styles.dart';

void main() {
  timeDilation = 1.0;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FriendsList()
        ..add(Friend('Tak', MyDate(month: 9, day: 5)))
        ..add(Friend('Ven', MyDate(month: 11, day: 7)))
        ..add(Friend('Nat', MyDate(month: 8, day: 30)))
        ..add(Friend('daniel',
            MyDate(month: DateTime.now().month, day: DateTime.now().day)))
        ..add(Friend('sam',
            MyDate(month: DateTime.now().month, day: DateTime.now().day + 6)))
        ..add(Friend('tiffany',
            MyDate(month: DateTime.now().month, day: DateTime.now().day + 1))),
      child: MaterialApp(
        title: 'Virgo',
        theme: ThemeData(
          backgroundColor: Colors.grey[900],
          scaffoldBackgroundColor: themeNavy,
          appBarTheme: AppBarTheme(
            brightness: Brightness.dark,
            color: Colors.grey[800],
          ),
          primaryColorBrightness: Brightness.dark,
          primaryColor: themeCornfield,
          textTheme: GoogleFonts.merriweatherTextTheme(),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Home(),
      ),
    );
  }
}
