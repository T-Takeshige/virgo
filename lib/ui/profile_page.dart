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

  // @override
  // void initState() {
  //   super.initState();
  //   notesTextFieldController.text = widget.friend.notes;
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   notesTextFieldController.dispose();
  // }

  // @override
  // void didUpdateWidget(Profile oldWidget) {
  //   setState(() {});
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BdayBloc, BdayState>(
      builder: (context, state) {
        if (state is BdayLoadingSt)
          return Loading();
        else if (state is BdayLoadFailureSt)
          return Center(
              child: Text(
            'Error: cannot load friend :<',
            style: TextStyle(color: Colors.white),
          ));
        else {
          List<Friend> friendsList = (state as BdayLoadSuccessSt).bdays;
          Friend friend =
              friendsList.firstWhere((f) => f.id == this.widget.friendId);
          DateTime now = DateTime.now();
          Color birthdayColor;
          if (friend.birthday.month == now.month &&
              friend.birthday.day == now.day)
            birthdayColor = themeLilac;
          else {
            DateTime birthday = friend.birthday.toDateTime();
            if (birthday.difference(now).inDays <= 1)
              birthdayColor = themeLilac1;
            else if (birthday.difference(now).inDays <= 7)
              birthdayColor = themeLilac2;
            else if (birthday.month == now.month + 1 ||
                birthday.month == now.month)
              birthdayColor = themeLilac3;
            else
              birthdayColor = themeLilac4;
          }

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
                toolbarHeight: 72,
                title: Text(
                  'Virgo',
                  style: GoogleFonts.merriweather(
                    textStyle: TextStyle(
                      fontSize: 48,
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
                      ScheduleNotifications notifications =
                          Provider.of<ScheduleNotifications>(context,
                              listen: false);
                      notifications.cancel(friend.alertBirthdayId);

                      friend.notifyMeId
                          .forEach((id) => notifications.cancel(id));
                      Navigator.of(context).pop();
                      BlocProvider.of<BdayBloc>(context)
                          .add(BdayDeletedByIdEv(friend.id));
                    },
                  )
                ],
              ),
              body: SingleChildScrollView(
                child: Container(
                  height: (MediaQuery.of(context).size.height - 65) * 0.95,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Flexible(
                        flex: 4,
                        child: Container(
                          color: birthdayColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Hero(
                                tag: '${friend.id} avatar',
                                placeholderBuilder:
                                    (context, heroSize, child) => CircleAvatar(
                                  radius: 60,
                                  backgroundColor: Colors.white,
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () async {
                                      final picker = ImagePicker();
                                      final PickedFile pickedFile =
                                          await picker.getImage(
                                        source: ImageSource.gallery,
                                        imageQuality: 25,
                                      );
                                      if (pickedFile == null) {
                                        return;
                                      } else {
                                        File imageFile = File(pickedFile.path);
                                        print(imageFile.path);
                                        friend = friend.copyWith(
                                            avatar:
                                                imageFile.readAsBytesSync());
                                        BlocProvider.of<BdayBloc>(context)
                                            .add(BdayUpdatedEv(friend));
                                        setState(() {});
                                      }
                                    },
                                    child: CircleAvatar(
                                      radius: 60,
                                      backgroundImage: friend.avatar == null
                                          ? AssetImage(friend.birthday
                                              .toAstrologyAvatar())
                                          : MemoryImage(friend.avatar),
                                      backgroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              NameInkWell(friend),
                              BirthdayInkWell(friend),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 6,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Notes: ',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.all(4.0),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12.0)),
                                            border: Border.all(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 3.0,
                                            ),
                                          ),
                                          child: TextField(
                                            textCapitalization:
                                                TextCapitalization.sentences,
                                            decoration:
                                                InputDecoration.collapsed(
                                                    hintText:
                                                        'Write notes here!'),
                                            textInputAction:
                                                TextInputAction.done,
                                            maxLines: null,
                                            controller: notesTextFieldController
                                              ..text = friend.notes,
                                            onSubmitted: (text) {
                                              friend =
                                                  friend.copyWith(notes: text);
                                              BlocProvider.of<BdayBloc>(context)
                                                  .add(BdayUpdatedEv(friend));
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: Row(
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
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: NotifymeCheckboxes(friend),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
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
