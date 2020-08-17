import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:virgo/accessories/styles.dart';
import 'package:virgo/bloc/blocs.dart';
import 'package:virgo/models/friend.dart';
import 'package:virgo/ui/profile_page.dart';

import 'loading.dart';

Widget _buildBirthdayListTile(BuildContext context, Friend friend) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 800),
          pageBuilder: (context, _, __) => Profile(friend),
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
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(width: 12),
          CircleAvatar(
            radius: 27,
            backgroundColor: Theme.of(context).primaryColor,
            child: Hero(
              tag: '${friend.id} avatar',
              placeholderBuilder: (context, heroSize, child) => CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
              ),
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
              ),
            ),
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
  Color color;
  switch (importance) {
    case 'Today!':
      color = themeLilac;
      break;
    case 'Tomorrow!':
      color = themeLilac1;
      break;
    case 'In a week':
      color = themeLilac2;
      break;
    case 'In a month':
      color = themeLilac3;
      break;
    case 'In a while':
      color = themeLilac4;
      break;
    default:
      color = themeCornfield;
  }

  return Container(
    height: 40.0,
    color: color,
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    alignment: Alignment.center,
    child: Text(
      importance,
      style: const TextStyle(color: Colors.white, fontSize: 24),
    ),
  );
}

class BirthdayList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BdayBloc, BdayState>(
      builder: (context, state) {
        DateTime now = DateTime.now();
        print(state);

        if (state is BdayLoadingSt)
          return Loading();
        else if (state is BdayLoadFailureSt)
          return Center(
              child: Text(
            'Error: cannot load friends :<',
            style: TextStyle(color: Colors.white),
          ));
        else {
          List<Friend> friendsList = (state as BdayLoadSuccessSt).bdays;
          List<Widget> widgets = [];

          if (friendsList.isEmpty) {
            return Container(
              child: Center(
                child: Text(
                  'You have no friends :(',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                  ),
                ),
              ),
            );
          }

          int index = 0;
          List<int> headerPos = [0, 0, 0, 0];

          // if there are birthdays today, create a new SliverStickyHeader for people
          // with birthdays today
          if (friendsList[index].birthday.month == now.month &&
              friendsList[index].birthday.day == now.day) {
            while (friendsList[index].birthday.month == now.month &&
                friendsList[index].birthday.day == now.day) {
              if (++index == friendsList.length) break;
            }
            headerPos[0] = index;
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

          // if there are birthdays tomorrow, create a new SliverStickyHead for people
          // with birthdays tomorrow
          DateTime dateTime = friendsList[index].birthday.toDateTime();
          if (dateTime.difference(now).inDays <= 1) {
            while (dateTime.difference(now).inDays <= 1) {
              if (++index == friendsList.length) break;
              dateTime = friendsList[index].birthday.toDateTime();
            }
            headerPos[1] = index;
            widgets.add(SliverStickyHeader(
              header: _buildImportanceHeader('Tomorrow!'),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) => _buildBirthdayListTile(
                    context,
                    friendsList[headerPos[0] + i],
                  ),
                  childCount: headerPos[1] - headerPos[0],
                ),
              ),
            ));
          } else {
            headerPos[1] = headerPos[0];
          }

          // if there are birthdays within a week, create a new SliverStickyHead for
          // people with birthdays within a week
          if (dateTime.difference(now).inDays <= 7) {
            while (dateTime.difference(now).inDays <= 7) {
              if (++index == friendsList.length) break;
              dateTime = friendsList[index].birthday.toDateTime();
            }
            headerPos[2] = index;
            widgets.add(SliverStickyHeader(
              header: _buildImportanceHeader('In a week'),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) => _buildBirthdayListTile(
                    context,
                    friendsList[headerPos[1] + i],
                  ),
                  childCount: headerPos[2] - headerPos[1],
                ),
              ),
            ));
          } else {
            headerPos[2] = headerPos[1];
          }

          // if there are birthdays next month, create a new SliverStickyHead for
          // people with birthdays wnext month
          if (dateTime.month == now.month + 1 || dateTime.month == now.month) {
            while (dateTime.month == now.month + 1 ||
                dateTime.month == now.month) {
              if (++index == friendsList.length) break;
              dateTime = friendsList[index].birthday.toDateTime();
            }
            headerPos[3] = index;
            widgets.add(SliverStickyHeader(
              header: _buildImportanceHeader('In a month'),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) => _buildBirthdayListTile(
                    context,
                    friendsList[headerPos[2] + i],
                  ),
                  childCount: headerPos[3] - headerPos[2],
                ),
              ),
            ));
          } else {
            headerPos[3] = headerPos[2];
          }

          // if there are any other people remaining, create a new SliverStickyHead
          // for them
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
        }
      },
    );
  }
}
