import 'package:flutter/material.dart';
import 'package:virgo/accessories/styles.dart';
import 'dart:math' as math;

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverSearchBarDelegate(
        minHeight: 60.0,
        maxHeight: 60.0,
        child: Container(
          color: Theme.of(context).backgroundColor,
          child: Container(
            margin:
                EdgeInsets.only(left: 12.0, right: 12.0, top: 8.0, bottom: 8.0),
            padding: EdgeInsets.only(left: 15.0),
            height: 60,
            decoration: BoxDecoration(
              color: themeGrey2,
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            child: InkWell(
              onTap: () {},
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(width: 12.0),
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: themeWhite),
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration.collapsed(
                          hintText: 'Search',
                          hintStyle: TextStyle(
                            color: themeWhite,
                            fontSize: 18.0,
                          )),
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SliverSearchBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverSearchBarDelegate({
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
  bool shouldRebuild(_SliverSearchBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
