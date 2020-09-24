import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virgo/accessories/styles.dart';
import 'package:virgo/bloc/search/search_cubit.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  FocusNode searchBarFocusNode;

  @override
  void initState() {
    super.initState();
    searchBarFocusNode = FocusNode();
  }

  @override
  void dispose() {
    searchBarFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Container(
        margin: EdgeInsets.only(left: 12.0, right: 12.0, top: 8.0, bottom: 8.0),
        padding: EdgeInsets.only(left: 15.0),
        height: 60,
        decoration: BoxDecoration(
          color: themeGrey2,
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        child: InkWell(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (currentFocus.hasPrimaryFocus) searchBarFocusNode.requestFocus();
          },
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: TextField(
                  focusNode: searchBarFocusNode,
                  style: TextStyle(color: themeWhite),
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration.collapsed(
                      hintText: 'Search',
                      hintStyle: TextStyle(
                        color: themeWhite,
                        fontSize: 18.0,
                      )),
                  textInputAction: TextInputAction.done,
                  onChanged: (search) => BlocProvider.of<SearchCubit>(context)
                      .changeSearch(search),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
