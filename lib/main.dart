import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virgo/models/my_date.dart';
import 'package:virgo/models/friend.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import 'package:virgo/profile_page.dart';

void main() {
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
          scaffoldBackgroundColor: Color(0xff0F0032),
          appBarTheme: AppBarTheme(
            brightness: Brightness.dark,
            color: Colors.grey[800],
          ),
          primaryColorBrightness: Brightness.dark,
          primaryColor: Colors.grey[900],
          accentColorBrightness: Brightness.dark,
          accentColor: Color(0xff7c5abf),
          textTheme: GoogleFonts.merriweatherTextTheme(),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65.0),
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
            )),
          ),
        ),
      ),
      body: Consumer<FriendsList>(
        builder: (context, friendsList, child) => friendsList.friends.isEmpty
            ? Center(
                child: Text(
                  'You have no friends :(',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : _buildBirthdayList(friendsList),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Provider.of<FriendsList>(context, listen: false)
              .add(Friend('Susan', MyDate(month: 9, day: 15)));
        },
      ),
    );
  }

  SliverPersistentHeader makeHeader(String headerText) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 40.0,
        maxHeight: 40.0,
        child: Container(
          color: Theme.of(context).accentColor,
          child: Center(
              child: Text(
            headerText,
            style: TextStyle(color: Colors.white, fontSize: 24),
          )),
        ),
      ),
    );
  }

  Widget _buildBirthdayList(FriendsList friendsList) {
    DateTime now = DateTime.now();

    friendsList.sortFrom(now);
    List<Widget> widgets = [makeHeader('Today is ${dateTimeToString(now)}')];

    int closeness = 0;
    int index = 0;
    List<int> headerPos = [0, 0, 0, 0];

    // if there are birthdays today, create a new SliverStickyHeader for people
    // with birthdays today
    if (friendsList.friends[index].birthday.month == now.month &&
        friendsList.friends[index].birthday.day == now.day) {
      while (friendsList.friends[index].birthday.month == now.month &&
          friendsList.friends[index].birthday.day == now.day) {
        if (++index == friendsList.friends.length) break;
      }
      headerPos[0] = index;
      widgets.add(SliverStickyHeader(
        header: _buildImportanceHeader('Today!'),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i) => _buildBirthdayListTile(friendsList.friends[i]),
            childCount: headerPos[0],
          ),
        ),
      ));
    }

    // if there are birthdays tomorrow, create a new SliverStickyHead for people
    // with birthdays tomorrow
    DateTime dateTime = friendsList.friends[index].birthday.toDateTime();
    if (dateTime.difference(now).inDays <= 1) {
      while (dateTime.difference(now).inDays <= 1) {
        if (++index == friendsList.friends.length) break;
        dateTime = friendsList.friends[index].birthday.toDateTime();
      }
      headerPos[1] = index;
      widgets.add(SliverStickyHeader(
        header: _buildImportanceHeader('Tomorrow!'),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i) =>
                _buildBirthdayListTile(friendsList.friends[headerPos[0] + i]),
            childCount: headerPos[1] - headerPos[0],
          ),
        ),
      ));
    } else {
      headerPos[1] = headerPos[0];
    }

    // if there are birthdays within a week, create a new SliverStickyHead for
    // people with birthdays within a week
    dateTime = friendsList.friends[index].birthday.toDateTime();
    if (dateTime.difference(now).inDays <= 7) {
      while (dateTime.difference(now).inDays <= 7) {
        if (++index == friendsList.friends.length) break;
        dateTime = friendsList.friends[index].birthday.toDateTime();
      }
      headerPos[2] = index;
      widgets.add(SliverStickyHeader(
        header: _buildImportanceHeader('In a week'),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i) =>
                _buildBirthdayListTile(friendsList.friends[headerPos[1] + i]),
            childCount: headerPos[2] - headerPos[1],
          ),
        ),
      ));
    } else {
      headerPos[2] = headerPos[1];
    }

    // if there are birthdays next month, create a new SliverStickyHead for
    // people with birthdays wnext month
    dateTime = friendsList.friends[index].birthday.toDateTime();
    if (dateTime.month == now.month + 1 || dateTime.month == now.month) {
      while (dateTime.month == now.month + 1 || dateTime.month == now.month) {
        if (++index == friendsList.friends.length) break;
        dateTime = friendsList.friends[index].birthday.toDateTime();
      }
      headerPos[3] = index;
      widgets.add(SliverStickyHeader(
        header: _buildImportanceHeader('In a month'),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i) =>
                _buildBirthdayListTile(friendsList.friends[headerPos[2] + i]),
            childCount: headerPos[3] - headerPos[2],
          ),
        ),
      ));
    } else {
      headerPos[3] = headerPos[2];
    }

    // if there are any other people remaining, create a new SliverStickyHead
    // for them
    if (headerPos[3] < friendsList.friends.length) {
      widgets.add(SliverStickyHeader(
        header: _buildImportanceHeader('In a while'),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i) =>
                _buildBirthdayListTile(friendsList.friends[headerPos[3] + i]),
            childCount: friendsList.friends.length - headerPos[3],
          ),
        ),
      ));
    }

    return CustomScrollView(
      slivers: widgets,
    );
  } // _buildBirthdayList

  Widget _buildBirthdayListTile(Friend friend) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Profile(friend: friend),
          ),
        );
      },
      child: Container(
        height: 80,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: 12),
            CircleAvatar(
              radius: 27,
              backgroundColor: Colors.white,
            ),
            SizedBox(width: 15),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${friend.name}',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                Text(
                  '${friend.birthday.toString()}',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImportanceHeader(String importance) {
    return Container(
      height: 40.0,
      color: Theme.of(context).accentColor,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      alignment: Alignment.center,
      child: Text(
        importance,
        style: const TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
