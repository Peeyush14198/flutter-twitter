import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tweetx/screens/root_screen.dart';
import 'package:tweetx/util/custom_functions.dart';

void main() {
 // Firestore.instance.settings();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TweetX',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          backgroundColor: CustomFunctions().hexToColor("#262833"),
          // backgroundColor: Colors.white,
          primaryColor: Colors.redAccent,
          cursorColor: Colors.redAccent,
          disabledColor: Colors.white,
          // primaryColor: CustomFunctions().hexToColor("#67d5fe"),
          accentColor: CustomFunctions().hexToColor("#262833"),
          dividerColor: Colors.grey[400],
          // accentColor: CustomFunctions().hexToColor("#e32a76"),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          appBarTheme: AppBarTheme(
              color: Colors.white,
              textTheme: TextTheme(
                  title: TextStyle(color: Colors.white, fontSize: 17.0)),
              iconTheme: IconThemeData(color: Colors.redAccent)),
          iconTheme: IconThemeData(color: Colors.white),
          textTheme: TextTheme(
              title: TextStyle(
                  color: Colors.black,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w500),
              display1: TextStyle(
                color: Colors.black,
                fontSize: 15.0,
              ),
              button: TextStyle(color: Colors.white, fontSize: 15.0),
              display2: TextStyle(
                color: Colors.blueGrey,
                fontSize: 15.0,
              ),
              display3: TextStyle(
                  color: Colors.pinkAccent,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold),
              display4: TextStyle(
                color: Colors.black,
                fontSize: 10.0,
              ),
              headline: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  // color: CustomFunctions().hexToColor("#67d5fe"),
                  fontSize: 17.0))),
      home: RootScreen(),
    );
  }
}
