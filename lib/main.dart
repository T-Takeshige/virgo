import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virgo/bloc/blocs.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:virgo/bloc/simple_bloc_observer.dart';
import 'package:virgo/ui/home.dart';
import 'package:virgo/accessories/styles.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  timeDilation = 1.0; // for animation debugging purposes
  runApp(BlocProvider(
    create: (context) => BdayBloc()..add(BdayLoadSuccessEv()),
    child: MyApp(),
  ));
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
