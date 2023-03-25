import 'package:circle/screens/saved.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Navi extends StatefulWidget {
  @override
  _NaviState createState() => _NaviState();
}

class _NaviState extends State<Navi> {
  int _selectedIndex = 0;

  // static const List<Widget> _widgetOptions = <Widget>[
  //   Text('home Page',
  //       style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
  //   Text('liked videos Page',
  //       style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
  //   Text('search Page',
  //       style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
  //   Text('settings ',
  //       style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            // child: _widgetOptions.elementAt(_selectedIndex),
            ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(.1),
              )
            ],
          ),
          child: SafeArea(
            child: GNav(
              rippleColor: Colors.black,
              hoverColor: Colors.black,
              gap: 8,
              activeColor: Colors.black,
              iconSize: 24,
              haptic: true,
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.black,
              color: Colors.white,
              tabs: const [
                GButton(
                  backgroundColor: Colors.black,
                  icon: Icons.home,
                  iconActiveColor: Colors.blue,
                  text: 'Home',
                  textColor: Colors.white,
                ),
                GButton(
                  backgroundColor: Colors.black,
                  iconActiveColor: Colors.blue,
                  icon: Icons.favorite,
                  textColor: Colors.white,
                  text: 'liked videos',
                ),
                GButton(
                  backgroundColor: Colors.black,
                  icon: Icons.search,
                  textColor: Colors.white,
                  iconActiveColor: Colors.blue,
                  text: 'search',
                ),
                GButton(
                  backgroundColor: Colors.black,
                  icon: Icons.settings,
                  textColor: Colors.white,
                  iconActiveColor: Colors.blue,
                  text: 'settings',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ));
  }
}
