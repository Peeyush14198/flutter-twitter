import 'package:flutter/material.dart';
import 'package:tweetx/screens/login_screen.dart';
import 'package:tweetx/screens/signup_screen.dart';
import 'package:tweetx/util/custom_functions.dart';
import 'package:tweetx/widgets/custom_bounce_animation.dart';

class TweetXMainScreen extends StatefulWidget {
  @override
  _TweetXMainScreenState createState() => _TweetXMainScreenState();
}

class _TweetXMainScreenState extends State<TweetXMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 100.0,
              ),
              Image.asset(
                "assets/images/logo.png",
                height: 200.0,
                width: MediaQuery.of(context).size.width,
              ),
              Container(
                height: 50.0,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 50.0,
                  right: 50.0,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: CustomBounceButtonAnimation(
                    onTap: () {
                      CustomFunctions()
                          .customNavigation(context, LoginScreen());
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40.0,
                      color: Theme.of(context).primaryColor,
                      child: Center(
                        child: Text(
                          "Sign In",
                          style: Theme.of(context).textTheme.button,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              CustomBounceButtonAnimation(
                onTap: () {
                  CustomFunctions().customNavigation(context, SignUpScreen());
                },
                child: Center(
                  child: Text(
                    "Create New Account",
                    style: Theme.of(context).textTheme.display3,
                  ),
                ),
              ),
              Container(
                height: 100.0,
              ),
              Center(
                child: Text(
                  "@ 2017 Momento Inc",
                  style: Theme.of(context).textTheme.display4,
                ),
              ),
              Container(
                height: 10.0,
              )
            ],
          )
        ],
      ),
    );
  }
}
