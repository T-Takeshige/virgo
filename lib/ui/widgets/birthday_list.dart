import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virgo/accessories/styles.dart';
import 'package:virgo/bloc/blocs.dart';
import 'package:virgo/models/friend.dart';
import 'package:virgo/models/my_date.dart';
import 'package:virgo/ui/profile_page.dart';
import 'package:virgo/ui/widgets/loading.dart';

Widget _buildBirthdayListTile(BuildContext context, Friend friend) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 500),
          pageBuilder: (context, _, __) => Profile(friend.id),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return Align(
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
        ),
      );
    },
    child: Container(
      margin: EdgeInsets.only(left: 12.0, right: 12.0, bottom: 8.0),
      height: 80,
      decoration: BoxDecoration(
        color: themeGrey2,
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 15),
              Hero(
                tag: '${friend.id} avatar',
                child: Material(
                  color: Colors.transparent,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: friend.avatar == null
                        ? AssetImage(friend.birthday.toAstrologyAvatar())
                        : MemoryImage(friend.avatar),
                    backgroundColor: themeWhite,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Text(
                '${friend.name}',
                textAlign: TextAlign.left,
                style: GoogleFonts.merriweatherSans(
                  textStyle: TextStyle(
                    fontSize: 28,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w800,
                    color: themeWhite,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              VerticalDivider(
                color: Theme.of(context).primaryColor,
                indent: 12,
                endIndent: 12,
                thickness: 1,
                width: 25,
              ),
              SizedBox(
                width: 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      monthToString[friend.birthday.month],
                      style: GoogleFonts.merriweatherSans(
                        textStyle: TextStyle(
                          fontSize: 24,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w700,
                          color: themeWhite,
                        ),
                      ),
                    ),
                    Text(
                      friend.birthday.day.toString(),
                      style: GoogleFonts.merriweatherSans(
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w700,
                          color: themeWhite,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 15)
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildImportanceHeader(String importance) {
  return Container(
    color: themeGrey1,
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Column(
      children: [
        Divider(
          color: themeCornfield,
          height: 1,
          thickness: 1,
          indent: 12,
          endIndent: 12,
        ),
        Container(
          height: 40.0,
          // color: color,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          alignment: Alignment.center,
          child: Text(
            importance,
            style: GoogleFonts.merriweatherSans(
              textStyle: TextStyle(
                fontSize: 24,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                color: themeWhite,
              ),
            ),
          ),
        ),
        Divider(
          color: themeCornfield,
          height: 1,
          thickness: 1,
          indent: 12,
          endIndent: 12,
        ),
      ],
    ),
  );
}

class BirthdayList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BdayBloc, BdayState>(
      builder: (context, state) {
        DateTime today = DateTime.now();
        print(state);

        if (state is BdayLoadingSt)
          return Loading();
        else if (state is BdayLoadFailureSt)
          return Center(
              child: Text(
            'Error: cannot load friends :<',
            style: TextStyle(
              color: themeErrorRed,
              fontSize: 24.0,
            ),
          ));
        else {
          List<Friend> friendsList = (state as BdayLoadSuccessSt).bdays;

          if (friendsList.isEmpty) {
            return Container(
              child: Center(
                child: Text(
                  'You have no friends :(',
                  style: TextStyle(
                    fontSize: 24.0,
                  ),
                ),
              ),
            );
          } else
            return BlocBuilder<SearchCubit, String>(
              builder: (context, searchSt) {
                print(searchSt);
                List<Widget> widgets = [];
                if (searchSt == "" || searchSt == null) {
                  // if no search query
                  friendsList = sortFriends(friendsList);
                  List<int> headerPos = [0, 0, 0, 0];

                  // if there are birthdays today, add tiles under "Today" header
                  while (headerPos[0] < friendsList.length &&
                      (friendsList[headerPos[0]].birthday.month ==
                              today.month &&
                          friendsList[headerPos[0]].birthday.day == today.day))
                    headerPos[0]++;
                  if (headerPos[0] > 0) {
                    widgets.add(SliverStickyHeader(
                      header: _buildImportanceHeader('Today!'),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, i) =>
                              _buildBirthdayListTile(context, friendsList[i]),
                          childCount: headerPos[0],
                        ),
                      ),
                    ));
                  }
                  headerPos[1] = headerPos[0];

                  // if there are birthdays tomorrow, add tiles under "Tomorrow" header
                  while (headerPos[1] < friendsList.length &&
                      (friendsList[headerPos[1]]
                              .birthday
                              .toDateTime()
                              .difference(today)
                              .inHours <=
                          24)) headerPos[1]++;
                  if (headerPos[1] > headerPos[0]) {
                    widgets.add(SliverStickyHeader(
                      header: _buildImportanceHeader('Tomorrow!'),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, i) => _buildBirthdayListTile(
                              context, friendsList[headerPos[0] + i]),
                          childCount: headerPos[1] - headerPos[0],
                        ),
                      ),
                    ));
                  }
                  headerPos[2] = headerPos[1];

                  // if there are birthdays in a week, add tiles under "In a week" header
                  while (headerPos[2] < friendsList.length &&
                      (friendsList[headerPos[2]]
                              .birthday
                              .toDateTime()
                              .difference(today)
                              .inHours <=
                          7 * 24)) headerPos[2]++;
                  if (headerPos[2] > headerPos[1]) {
                    widgets.add(SliverStickyHeader(
                      header: _buildImportanceHeader('In a week'),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, i) => _buildBirthdayListTile(
                              context, friendsList[headerPos[1] + i]),
                          childCount: headerPos[2] - headerPos[1],
                        ),
                      ),
                    ));
                  }
                  headerPos[3] = headerPos[2];

                  // if there are birthdays in a month, add tiles under "In a month" header
                  while (headerPos[3] < friendsList.length &&
                      (friendsList[headerPos[3]].birthday.month ==
                              today.month + 1 ||
                          friendsList[headerPos[3]].birthday.month ==
                              today.month)) headerPos[3]++;
                  if (headerPos[3] > headerPos[2]) {
                    widgets.add(SliverStickyHeader(
                      header: _buildImportanceHeader('In a month'),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, i) => _buildBirthdayListTile(
                              context, friendsList[headerPos[2] + i]),
                          childCount: headerPos[3] - headerPos[2],
                        ),
                      ),
                    ));
                  }

                  // if there are any other birthdays remaining, add tiles under "In a while" header
                  if (headerPos[3] < friendsList.length) {
                    widgets.add(SliverStickyHeader(
                      header: _buildImportanceHeader('In a while'),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, i) => _buildBirthdayListTile(
                            context,
                            friendsList[headerPos[3] + i],
                          ),
                          childCount: friendsList.length - headerPos[3],
                        ),
                      ),
                    ));
                  }

                  return CustomScrollView(
                    slivers: widgets,
                  );
                } else {
                  // if there is search query
                  friendsList.forEach((friend) {
                    if (friend.name
                        .contains(RegExp(searchSt, caseSensitive: false)))
                      widgets.add(_buildBirthdayListTile(context, friend));
                  });
                  print(widgets);
                  print('hi00');
                  if (widgets.isEmpty)
                    return Center(
                      child: Text(
                        'Cannot find friend',
                        style: TextStyle(
                          fontSize: 24.0,
                        ),
                      ),
                    );
                  else
                    return CustomScrollView(
                      slivers: [
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                              (context, i) => widgets[i],
                              childCount: widgets.length),
                        )
                      ],
                    );
                }
              },
            );
        }
      },
    );
  }
}
