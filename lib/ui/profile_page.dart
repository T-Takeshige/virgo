import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:virgo/bloc/blocs.dart';
import 'package:virgo/miscellaneous/schedule_notifications.dart';
import 'package:virgo/ui/widgets/birthday_inkwell.dart';
import 'package:virgo/models/friend.dart';
import 'package:virgo/accessories/styles.dart';
import 'package:virgo/ui/widgets/loading.dart';
import 'package:virgo/ui/widgets/name_inkwell.dart';
import 'package:virgo/ui/widgets/notifyme_checkboxes.dart';

// ignore: must_be_immutable
class Profile extends StatefulWidget {
  String friendId;
  Profile(this.friendId);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final notesTextFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BdayBloc, BdayState>(
      builder: (context, state) {
        if (this.widget.friendId == null) return Loading();
        if (state is BdayLoadingSt)
          return Loading();
        else if (state is BdayLoadFailureSt)
          return Center(
              child: Text(
            'Error: cannot load friend :<',
            style: TextStyle(color: themeWhite),
          ));
        else {
          List<Friend> friendsList = (state as BdayLoadSuccessSt).bdays;
          Friend friend =
              friendsList.firstWhere((f) => f.id == this.widget.friendId);
          return GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
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
                      Icons.delete,
                      size: 35.0,
                    ),
                    onPressed: () {
                      this.widget.friendId = null;
                      ScheduleNotifications notifications =
                          Provider.of<ScheduleNotifications>(context,
                              listen: false);
                      notifications.cancel(friend.alertBirthdayId);

                      friend.notifyMeId
                          .forEach((id) => notifications.cancel(id));
                      Navigator.of(context).pop(friend);
                      BlocProvider.of<BdayBloc>(context)
                          .add(BdayDeletedByIdEv(friend.id));
                    },
                  )
                ],
              ),
              body: SingleChildScrollView(
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
                                        File imageFile = File(pickedFile.path);
                                        print(imageFile.path);
                                        friend = friend.copyWith(
                                            avatar:
                                                imageFile.readAsBytesSync());
                                        BlocProvider.of<BdayBloc>(context)
                                            .add(BdayUpdatedEv(friend));
                                        setState(() {});
                                      }
                                    }
                                  },
                                  child: CircleAvatar(
                                    radius: 60,
                                    backgroundImage: friend.avatar == null
                                        ? AssetImage(
                                            friend.birthday.toAstrologyAvatar())
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
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
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
                                          color: Theme.of(context).primaryColor,
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
                                          ..text = friend.notes,
                                        onSubmitted: (text) {
                                          try {
                                            friend =
                                                friend.copyWith(notes: text);
                                            BlocProvider.of<BdayBloc>(context)
                                                .add(BdayUpdatedEv(friend));
                                            Scaffold.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Notes are successfully updated!'),
                                            ));
                                          } catch (e) {
                                            print(e);
                                          }
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
              ),
            ),
          );
        }
      },
    );
  }
}
