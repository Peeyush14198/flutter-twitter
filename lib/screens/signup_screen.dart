import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:tweetx/screens/feed_screen.dart';
import 'package:tweetx/screens/root_screen.dart';
import 'package:tweetx/util/auth.dart';
import 'package:tweetx/util/custom_functions.dart';
import 'package:tweetx/widgets/auth_title.dart';
import 'package:tweetx/widgets/custom_bounce_animation.dart';
import 'package:tweetx/widgets/custom_fade_animation.dart';
import 'package:tweetx/widgets/custom_loader.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController confirmPassword = new TextEditingController();
  final signUpFormKey = GlobalKey<FormState>();
  bool loader = false;

  String validateEmail(String value) {
    value = value.trim();
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Email is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }

  String validatePassword(String value) {
    Pattern pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = new RegExp(pattern);
    print(value);
    if (value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 6) {
      return 'Password must be of length more than 6';
    } else {
      if (!regex.hasMatch(value))
        return 'Should contain at least one upper letter eg. A\nShould contain at least one lower case eg. a\nShould contain at least one digit eg. 1\nShould contain at least one Special character eg. #';
      else
        return null;
    }
  }

  String validateConfirmPassword(String value) {
    if (value.isEmpty) {
      return "Confirm password";
    } else if (confirmPassword.text.trim().compareTo(password.text.trim()) !=
        0) {
      return "Password do not match";
    } else {
      return null;
    }
  }

  Future<bool> validateAndSave() async {
    final FormState form = signUpFormKey.currentState;
    if (form.validate()) {
      setState(() {
        loader = true;
      });
      try {
        AuthResult authResult = await Auth().createEmailPasswordUser(
            email.text.trim(), password.text.trim(), context);
        if (authResult != null) {
          setState(() {
            loader = false;
            String name = CustomFunctions().randomString(6);
            name = name[0].toUpperCase() + name.substring(1, name.length);
            Firestore.instance
                .collection("user")
                .document(authResult.user.uid)
                .setData({
              "email": email.text,
              "followers": [],
              "following": [],
              "name": name,
              "joined": Timestamp.now()
            });
            CustomFunctions().removeAllRoutes(context, RootScreen());
          });
        } else {
          setState(() {
            loader = false;
          });
        }
        form.save();
      } catch (e) {
        print(e);
        setState(() {
          loader = false;
        });
      }
    }
    return false;
  }

  Widget backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left,
                  color: Theme.of(context).primaryColor, size: 45.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget entryField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            style: Theme.of(context).textTheme.display1,
            autofocus: false,
            validator: isPassword ? validatePassword : validateEmail,
            controller: isPassword ? password : email,
            obscureText: isPassword ? true : false,
            decoration: InputDecoration(
              hintText: isPassword ? 'Password' : 'Email',
              hintStyle: Theme.of(context).textTheme.display3,
              border: InputBorder.none,
              prefixIcon: Icon(
                isPassword ? MdiIcons.security : Icons.mail,
                color: Theme.of(context).primaryColor,
              ),
              fillColor: Colors.black,
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            ),
          )
        ],
      ),
    );
  }

  Widget entryConfrimField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            style: Theme.of(context).textTheme.display1,
            autofocus: false,
            validator: validateConfirmPassword,
            controller: confirmPassword,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Type your password again',
              hintStyle: Theme.of(context).textTheme.display3,
              border: InputBorder.none,
              prefixIcon: Icon(
                MdiIcons.security,
                color: Theme.of(context).primaryColor,
              ),
              fillColor: Colors.black,
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            ),
          )
        ],
      ),
    );
  }

  Widget submitButton() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: CustomBounceButtonAnimation(
        onTap: () {
          validateAndSave();
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 40.0,
          color: Theme.of(context).primaryColor,
          child: Center(
            child: Text(
              "Register",
              style: Theme.of(context).textTheme.button,
            ),
          ),
        ),
      ),
    );
  }

  Widget loginAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Center(
            child: new Text(
              "By Continuing I agree to the",
              style: new TextStyle(color: Colors.grey),
            ),
          ),
          new SizedBox(
            height: 1.0,
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Center(
                child: new Text("Terms of Service and ",
                    style: new TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              new InkWell(
                onTap: () async {
                  const url = 'https://flutter.dev';
                  if (await canLaunch(url) != null) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                  //  launchURL(XploryoTheme().privacyPolicy, 0);
                },
                child: new Text(
                  "Privacy Policy",
                  style: new TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget emailPasswordWidget() {
    return Column(
      children: <Widget>[
        entryField("Email id"),
        entryField("Password", isPassword: true),
        entryConfrimField("Confirm Password"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return loader
        ? CustomLoaderWidget()
        : Scaffold(
            appBar: AppBar(
              title: Text(
                "Register",
                style: Theme.of(context).textTheme.title,
              ),
              centerTitle: true,
              elevation: 0,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ),
            body: Form(
                key: signUpFormKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 50.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: CustomFadeAnimation(
                          child: AuthTitle(),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: CustomFadeAnimation(
                          child: emailPasswordWidget(),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      loginAccountLabel(),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: CustomFadeAnimation(
                          child: submitButton(),
                        ),
                      )
                    ],
                  ),
                )));
  }
}
