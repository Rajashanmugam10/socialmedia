import 'package:circle/screens/addin.dart';
import 'package:circle/screens/admin.dart';
import 'package:circle/screens/homepage.dart';
import 'package:circle/screens/saved.dart';
import "package:flutter/material.dart";
import 'package:overlapping_panels/overlapping_panels.dart';

class Newex extends StatefulWidget {
  const Newex({Key? key}) : super(key: key);

  @override
  State<Newex> createState() => _NewexState();
}

class _NewexState extends State<Newex> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        OverlappingPanels(
          restWidth: MediaQuery.of(context).size.width / 2,
          // Using the Builder widget is not required. You can pass your widget directly.
          // But to use `OverlappingPanels.of(context)` you need to wrap your widget in a Builder
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
          onSideChange: (side) {
            setState(() {
              if (side == RevealSide.main) {
                // hide something
              } else if (side == RevealSide.left) {
                // show something
              }
            });
          },
        ),
      ],
    );
  }
}
