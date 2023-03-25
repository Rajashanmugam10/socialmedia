import 'package:circle/screens/admin.dart';
import 'package:circle/screens/homepage.dart';
import 'package:circle/screens/saved.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:overlapping_panels/overlapping_panels.dart';
import 'package:side_navigation/side_navigation.dart';

class Ex extends StatefulWidget {
  const Ex({Key? key}) : super(key: key);

  @override
  State<Ex> createState() => _ExState();
}

List<Widget> views = const [HomePage(), Admin(), Saved()];

/// The currently selected index of the bar
int selectedIndex = 0;

final europeanCountries = [
  'Albania',
  'Andorra',
  'Armenia',
  'Austria',
  'Azerbaijan',
  'Belarus',
  'Belgium',
  'Bosnia and Herzegovina',
  'Bulgaria',
  'Croatia',
  'Cyprus',
  'Czech Republic',
  'Denmark',
  'Estonia',
  'Finland',
  'France',
  'Georgia',
  'Germany',
  'Greece',
  'Hungary',
  'Iceland',
  'Ireland',
  'Italy',
  'Kazakhstan',
  'Kosovo',
  'Latvia',
  'Liechtenstein',
  'Lithuania',
  'Luxembourg',
  'Macedonia',
  'Malta',
  'Moldova',
  'Monaco',
  'Montenegro',
  'Netherlands',
  'Norway',
  'Poland',
  'Portugal',
  'Romania',
  'Russia',
  'San Marino',
  'Serbia',
  'Slovakia',
  'Slovenia',
  'Spain',
  'Sweden',
  'Switzerland',
  'Turkey',
  'Ukraine',
  'United Kingdom',
  'Vatican City'
];

class _ExState extends State<Ex> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        OverlappingPanels(
          restWidth: MediaQuery.of(context).size.width / 2,
          left: Builder(builder: (context) {
            return const HomePage();
          }),
          right: Builder(
            builder: (context) => const Saved(),
          ),
          main: Builder(
            builder: (context) {
              return const HomePage();
            },
          ),
          // onSideChange: (side) {
          //   setState(() {
          //     if (side == RevealSide.main) {
          //       // hide something
          //     } else if (side == RevealSide.left) {
          //       // show something
          //     }
          //   });
          // },
        ),
      ],
    );
    //  Scaffold(
    //   body: Row(
    //     children: [
    //       SideNavigationBar(
    //         toggler: SideBarToggler(
    //             expandIcon: Icons.keyboard_arrow_right,
    //             shrinkIcon: Icons.keyboard_arrow_left,
    //             onToggle: () {
    //               print('Toggle');
    //             }),
    //         initiallyExpanded: false,
    //         selectedIndex: selectedIndex,
    //         header: const SideNavigationBarHeader(
    //             image: SizedBox(
    //               height: 90,
    //               child: CircleAvatar(
    //                 child: Icon(Icons.account_balance),
    //               ),
    //             ),
    //             title: Text('Title widget'),
    //             subtitle: Text('Subtitle widget')),
    //         footer: const SideNavigationBarFooter(label: Text('Footer label')),
    //         items: const [
    //           SideNavigationBarItem(
    //             icon: Icons.dashboard,
    //             label: 'Dashboard',
    //           ),
    //           SideNavigationBarItem(
    //             icon: Icons.person,
    //             label: 'Account',
    //           ),
    //           SideNavigationBarItem(
    //             icon: Icons.settings,
    //             label: 'Settings',
    //           ),
    //         ],
    //         onTap: (index) {
    //           setState(() {
    //             selectedIndex = index;
    //           });
    //         },
    //         theme: SideNavigationBarTheme(
    //           backgroundColor: Colors.blue,
    //           togglerTheme: SideNavigationBarTogglerTheme.standard(),
    //           itemTheme: SideNavigationBarItemTheme.standard(),
    //           dividerTheme: SideNavigationBarDividerTheme.standard(),
    //         ),
    //       ),

    //       /// Make it take the rest of the available width
    //       Expanded(
    //         child: views.elementAt(selectedIndex),
    //       )
    //     ],
    //   ),

    //   // Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    //   //   Flexible(
    //   //     child: ListView.builder(
    //   //         itemCount: europeanCountries.length,
    //   //         itemBuilder: (context, index) {
    //   //           return ListTile(
    //   //             title: Text(europeanCountries[index]),
    //   //           );
    //   //         }),
    //   //   ),
    //   // ]),
    // );
  }
}
