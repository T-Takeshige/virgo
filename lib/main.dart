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
import 'package:virgo/ui/profile_page.dart';

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

  runApp(
    BlocProvider(
      // Allow access to BdayBloc throughout the app
      create: (context) => BdayBloc()..add(BdayLoadSuccessEv()),
      // Allow access to ScheduleNotifications throughout the app
      child: Provider<ScheduleNotifications>(
        create: (context) => notifications,
        builder: (context, child) {
          notifications.init(
            onSelectNotification: (String payload) async {
              // TODO: fix this bs cuz it still doesn't fully work
              if (payload == null || payload.trim().isEmpty) return null;
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile(payload)),
              );
              return;
            },
          );
          return MyApp();
        },
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
        backgroundColor: themeGrey1,
        scaffoldBackgroundColor: themeGrey1,
        appBarTheme: AppBarTheme(
          brightness: Brightness.dark,
          color: themeGrey3,
        ),
        primaryColorBrightness: Brightness.dark,
        primaryColor: themeCornfield,
        accentColor: themeCornfield,
        textTheme: GoogleFonts.merriweatherSansTextTheme().apply(
          bodyColor: themeWhite,
          displayColor: themeWhite,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}
