import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:virgo/bloc/blocs.dart';
import 'package:virgo/bloc/profile/profile_cubit.dart';
import 'package:virgo/miscellaneous/schedule_notifications.dart';
import 'package:virgo/ui/profile/widgets/birthday_inkwell.dart';
import 'package:virgo/models/friend.dart';
import 'package:virgo/accessories/styles.dart';
import 'package:virgo/ui/profile/widgets/name_inkwell.dart';
import 'package:virgo/ui/profile/widgets/notifyme_checkboxes.dart';

import '../../accessories/styles.dart';
import '../../bloc/bday/bday_event.dart';
import '../../models/friend.dart';

// ignore: must_be_immutable
class Profile extends StatefulWidget {
  Friend friend;
  Profile(this.friend);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final notesTextFieldController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    notesTextFieldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Friend friend = this.widget.friend;

    return BlocProvider<ProfileCubit>(
      create: (context) => ProfileCubit(friend.copyWith()),
      child: Builder(
        // for GestureDetector BlocProvider.of()
        builder: (context) => GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();

              Friend friendUpdated =
                  BlocProvider.of<ProfileCubit>(context).state;
              BlocProvider.of<ProfileCubit>(context).updateFriend(
                  friendUpdated.copyWith(notes: notesTextFieldController.text));
            }
          },
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              elevation: 0.0,
              toolbarHeight: 60,
              title: Text(
                'Profile',
                style: GoogleFonts.merriweatherSans(
                  textStyle: TextStyle(
                    fontSize: 32,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    size: 35.0,
                    color: themeErrorRed,
                  ),
                  onPressed: () {
                    ScheduleNotifications notifications =
                        Provider.of<ScheduleNotifications>(context,
                            listen: false);
                    notifications.cancel(friend.alertBirthdayId);

                    friend.notifyMeId.forEach((id) => notifications.cancel(id));
                    Navigator.of(context).pop(friend);
                    BlocProvider.of<BdayBloc>(context)
                        .add(BdayDeletedByIdEv(friend.id));
                  },
                ),
              ],
            ),
            floatingActionButton: Opacity(
              opacity: 0.7,
              child: Builder(
                // for Scaffold.of()
                builder: (context) => FloatingActionButton(
                  child: Icon(
                    Icons.save,
                    size: 35.0,
                  ),
                  onPressed: () {
                    try {
                      Friend friendUpdated =
                          BlocProvider.of<ProfileCubit>(context).state;
                      if (friend.name != friendUpdated.name ||
                          (friend.birthday.month !=
                                  friendUpdated.birthday.month &&
                              friend.birthday.day !=
                                  friendUpdated.birthday.day)) {
                        // if name or birthday has been changed, change every
                        // notification id accordingly
                        ScheduleNotifications notifications =
                            Provider.of<ScheduleNotifications>(context,
                                listen: false);

                        // Cancel old notifications and create new ones based on new info
                        notifications.cancel(friend.alertBirthdayId);
                        friendUpdated = friendUpdated.copyWith(
                            alertBirthdayId: makeBirthdayReminder(
                                notifications,
                                friendUpdated.name,
                                friendUpdated.birthday,
                                friendUpdated.id));
                        for (var i = 0;
                            i < friendUpdated.notifyMeId.length;
                            i++) {
                          if (friend.notifyMeId[i] != null)
                            notifications.cancel(friend.notifyMeId[i]);
                          if (friendUpdated.notifyMeId[i] != null) {
                            friendUpdated.notifyMeId[i] = makeBirthdayReminder(
                                notifications,
                                friendUpdated.name,
                                friendUpdated.birthday,
                                friendUpdated.id,
                                recency: i);
                          }
                        }
                      } else // if neither has been changed, just change any new notification ids
                        for (int i = 0; i < friend.notifyMeId.length; i++) {
                          if (friendUpdated.notifyMeId[i] != null) {
                            if (friend.notifyMeId[i] != null)
                              friendUpdated.notifyMeId[i] =
                                  friend.notifyMeId[i];
                            else {
                              ScheduleNotifications notifications =
                                  Provider.of<ScheduleNotifications>(context,
                                      listen: false);
                              friendUpdated.notifyMeId[i] =
                                  makeBirthdayReminder(
                                      notifications,
                                      friendUpdated.name,
                                      friendUpdated.birthday,
                                      friendUpdated.id);
                            }
                          }
                        }

                      BlocProvider.of<BdayBloc>(context)
                          .add(BdayUpdatedEv(friendUpdated));
                      friend = friendUpdated.copyWith();
                      Scaffold.of(context).showSnackBar(SnackBar(
                        duration: Duration(milliseconds: 3000),
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.check,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Change saved successfully!',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    fontSize: 16,
                                  ),
                            ),
                          ],
                        ),
                      ));
                    } catch (e) {
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(milliseconds: 3000),
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.warning,
                                color: Theme.of(context).primaryColor,
                              ),
                              SizedBox(width: 12),
                              Text(
                                e,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      fontSize: 16,
                                      color: themeErrorRed,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            body: BlocBuilder<ProfileCubit, Friend>(
              builder: (context, friend) {
                return SingleChildScrollView(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          color: themeGrey2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: 10.0),
                              Hero(
                                tag: '${friend.id} avatar',
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () async {
                                      final picker = ImagePicker();
                                      PickedFile pickedFile;
                                      try {
                                        pickedFile = await picker.getImage(
                                          source: ImageSource.gallery,
                                          imageQuality: 25,
                                        );
                                      } catch (e) {
                                        print(e);
                                      } finally {
                                        if (pickedFile != null) {
                                          File imageFile =
                                              File(pickedFile.path);
                                          BlocProvider.of<BdayBloc>(context)
                                              .add(BdayUpdatedEv(
                                                  friend.copyWith(
                                                      avatar: imageFile
                                                          .readAsBytesSync())));
                                        }
                                      }
                                    },
                                    child: CircleAvatar(
                                      radius: 60,
                                      backgroundImage: friend.avatar == null
                                          ? AssetImage(friend.birthday
                                              .toAstrologyAvatar())
                                          : MemoryImage(friend.avatar),
                                      backgroundColor: themeWhite,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              NameInkWell(friend),
                              BirthdayInkWell(friend),
                              SizedBox(height: 10.0),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Text(
                                        'Notes: ',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontStyle: FontStyle.italic,
                                          color: themeWhite,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 150,
                                        padding: EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          color: themeWhite,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12.0)),
                                          border: Border.all(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 3.0,
                                          ),
                                        ),
                                        child: TextField(
                                          style: TextStyle(color: Colors.black),
                                          textCapitalization:
                                              TextCapitalization.sentences,
                                          decoration: InputDecoration.collapsed(
                                              hintText: 'Write notes here!'),
                                          textInputAction: TextInputAction.done,
                                          maxLines: null,
                                          controller: notesTextFieldController
                                            ..text =
                                                BlocProvider.of<ProfileCubit>(
                                                        context)
                                                    .state
                                                    .notes,
                                          onSubmitted: (text) {
                                            Friend friendUpdated =
                                                BlocProvider.of<ProfileCubit>(
                                                        context)
                                                    .state;
                                            BlocProvider.of<ProfileCubit>(
                                                    context)
                                                .updateFriend(friendUpdated
                                                    .copyWith(notes: text));
                                            // setState(() {
                                            //   friend =
                                            //       friend.copyWith(notes: text);
                                            // });
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      'Notify me: ',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontStyle: FontStyle.italic,
                                        color: themeWhite,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: NotifymeCheckboxes(friend),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// class SaveButton extends StatelessWidget {
//   final Friend friend;
//   SaveButton(this.friend);
//   @override
//   Widget build(BuildContext context) {

//     return ;
//   }
// }
