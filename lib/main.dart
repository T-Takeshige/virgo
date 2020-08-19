import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:virgo/bloc/blocs.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:virgo/bloc/simple_bloc_observer.dart';
import 'package:virgo/ui/home.dart';
import 'package:virgo/accessories/styles.dart';
import 'package:virgo/miscellaneous/schedule_notifications.dart';

void main() {
  // Initialise bloc observer for debugging purposes
  Bloc.observer = SimpleBlocObserver();

  // forgot what this was for
  WidgetsFlutterBinding.ensureInitialized();

  // for animation debugging purposes
  timeDilation = 1.0;

  ScheduleNotifications notifications = ScheduleNotifications(
    // Channel id
    'Virgo',

    // Channel name
    'Virgo birthday channel',

    // Channel description
    'This channel is responsible for notifying users of birthdays at certain times according to their preference.',
  );
  notifications.init(
    // TODO: direct user to profile page of this person
    onSelectNotification: (String payload) async {},
  );

  runApp(
    BlocProvider(
      // Allow access to BdayBloc throughout the app
      create: (context) => BdayBloc()..add(BdayLoadSuccessEv()),
      // Allow access to ScheduleNotifications throughout the app
      child: Provider<ScheduleNotifications>(
        create: (context) => notifications,
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}
