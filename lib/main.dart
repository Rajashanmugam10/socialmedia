import 'package:circle/ex.dart';
import 'package:circle/myprofile.dart';
import 'package:circle/newex.dart';
import 'package:circle/screens/homepage.dart';
import 'package:circle/screens/login.dart';
import 'package:circle/screens/navigator.dart';
import 'package:circle/screens/otp.dart';
import 'package:circle/screens/phone.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screens/test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      title: "Circle",
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.active) {
            if (snapShot.hasData) {
              return const HomePage();
            } else if (snapShot.hasError) {
              return Center(
                child: Text('${snapShot.error}'),
              );
            }
          }
          if (snapShot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }
          return const LoginScreen();
        },
      ),
    );
  }
}
