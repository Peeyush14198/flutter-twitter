import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tweetx/screens/feed_screen.dart';
import 'package:tweetx/screens/tweetx_main_screen.dart';
import 'package:tweetx/widgets/custom_loader.dart';

class SplashScreen extends StatefulWidget {
  final bool userLoggedIn;
  final String userId;
  SplashScreen({this.userLoggedIn,this.userId});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    if (widget.userLoggedIn) {
      Timer(
          Duration(seconds: 2),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => FeedScreen(
                userId: widget.userId,
              ))));
    } else {
      Timer(
          Duration(seconds: 2),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => TweetXMainScreen())));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CustomLoaderWidget()),
    );
  }
}
