import 'package:Eserve/home/Search/SearchPro.dart';
import 'package:Eserve/home/bookingcust.dart';
import 'package:Eserve/home/customerbookshow.dart';
import 'package:Eserve/home/home_screen.dart';
import 'package:Eserve/nearby_map/nearby_ui.dart';
import 'package:Eserve/util/custom_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_icons/flutter_icons.dart';

class DataMain extends StatefulWidget {
  String profileId;
  String pu;
  String dn;
  String em;
  String ll;

  DataMain({this.profileId, this.dn, this.em, this.pu, this.ll});

  @override
  _DataMainState createState() => _DataMainState();
}

class _DataMainState extends State<DataMain> {
  CustomColors customColors = new CustomColors();
  int currentTabIndex = 0;
  List<Widget> pages;
  Widget currentPage;
  HomeScreen home;
  NearbyUi nearui;
  BookingFull bf;
  BookingCustomer bc;
  SearchPro sp;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    home = HomeScreen(
      profileId: widget.profileId,
      em: widget.em,
      pu: widget.pu,
      dn: widget.dn,
      ll: widget.ll,
    );
    nearui = NearbyUi();
    bf = BookingFull(pid: widget.profileId);
    bc = BookingCustomer(pid: widget.profileId);
    sp = SearchPro();
    pages = [home, nearui, bc];
    currentPage = home;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: customColors.primaryTextColor,
        activeColor: customColors.primaryColor,
        inactiveColor: customColors.secondaryTextColor,
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
            currentPage = pages[index];
          });
        },
        currentIndex: currentTabIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(MaterialCommunityIcons.home), title: Text("Home")),
          BottomNavigationBarItem(
              icon: Icon(MaterialCommunityIcons.map_marker),
              title: Text("Near By Services")),
          BottomNavigationBarItem(
              icon: Icon(MaterialCommunityIcons.timetable),
              title: Text("Your Hiring")),
        ],
      ),
      body: currentPage,
    );
  }
}
