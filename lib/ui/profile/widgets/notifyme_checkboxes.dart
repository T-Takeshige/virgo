import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virgo/bloc/profile/profile_cubit.dart';
import 'package:virgo/models/friend.dart';

class NotifymeCheckboxes extends StatelessWidget {
  final Friend friend;
  NotifymeCheckboxes(this.friend);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        MyCheckBoxTile(
          label: 'a day before',
          index: 0,
          friend: friend,
          onChanged: () {
            List<int> notifyMeId = List<int>.from(friend.notifyMeId);
            notifyMeId[0] = notifyMeId[0] == null ? 0 : null;
            BlocProvider.of<ProfileCubit>(context)
                .updateFriend(friend.copyWith(notifyMeId: notifyMeId));
          },
        ),
        MyCheckBoxTile(
          label: 'a week before',
          index: 1,
          friend: friend,
          onChanged: () {
            List<int> notifyMeId = List<int>.from(friend.notifyMeId);
            notifyMeId[1] = notifyMeId[1] == null ? 1 : null;
            BlocProvider.of<ProfileCubit>(context)
                .updateFriend(friend.copyWith(notifyMeId: notifyMeId));
          },
        ),
        MyCheckBoxTile(
          label: 'a month before',
          index: 2,
          friend: friend,
          onChanged: () {
            List<int> notifyMeId = List<int>.from(friend.notifyMeId);
            notifyMeId[2] = notifyMeId[2] == null ? 2 : null;
            BlocProvider.of<ProfileCubit>(context)
                .updateFriend(friend.copyWith(notifyMeId: notifyMeId));
          },
        ),
      ],
    );
  }
}

class MyCheckBoxTile extends StatelessWidget {
  final String label;
  final int index;
  final Friend friend;
  final Function onChanged;
  MyCheckBoxTile({this.label, this.index, this.friend, this.onChanged});

  @override
  Widget build(BuildContext context) {
    bool _isSelected = friend.notifyMeId[index] != null;
    return InkWell(
      onTap: () {
        onChanged();
      },
      child: Padding(
        padding: EdgeInsets.only(left: 5.0, top: 8.0, bottom: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 18.0,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 24.0,
              width: 24.0,
              child: Theme(
                data: ThemeData(
                  unselectedWidgetColor: Theme.of(context).primaryColor,
                ),
                child: Checkbox(
                  activeColor: Theme.of(context).primaryColor,
                  checkColor: Colors.white,
                  value: _isSelected,
                  onChanged: (bool value) {
                    onChanged();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
