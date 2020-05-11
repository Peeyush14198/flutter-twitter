import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:tweetx/screens/profile_screen.dart';
import 'package:tweetx/screens/root_screen.dart';
import 'package:tweetx/screens/users_screen.dart';
import 'package:tweetx/util/custom_functions.dart';

class CustomDrawer extends StatelessWidget {
  final DocumentSnapshot userSnapshot;
  CustomDrawer({this.userSnapshot});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 50.0,
          ),
          Container(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Stack(
                children: <Widget>[
                  CircleAvatar(
                    maxRadius: 50.0,
                    minRadius: 50.0,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(
                        "https://w0.pngwave.com/png/639/452/computer-icons-avatar-user-profile-people-icon-png-clip-art.png"),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 110.0, top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          userSnapshot.data['name'],
                          style: Theme.of(context).textTheme.title,
                        ),
                        Container(
                          height: 5.0,
                        ),
                        Text(
                          userSnapshot.data['email'],
                          style: Theme.of(context).textTheme.display2,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Divider(),
          Container(
            height: 50.0,
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: InkWell(
              onTap: () {
                CustomFunctions().customNavigation(
                    context,
                    ProfileScreen(
                      userSnapshot: userSnapshot,
                    ));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  Container(
                    width: 10.0,
                  ),
                  Text(
                    "My Profile",
                    style: Theme.of(context).textTheme.display1,
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 10.0,
          ),
          Divider(),
          Container(
            height: 10.0,
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: InkWell(
              onTap: () {
                CustomFunctions().customNavigation(
                    context,
                    UserListScreen(
                      userDocumentSnapshot: userSnapshot,
                    ));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.info,
                    color: Colors.black,
                  ),
                  Container(
                    width: 10.0,
                  ),
                  Text(
                    "User List",
                    style: Theme.of(context).textTheme.display1,
                  )
                ],
              ),
            ),
          ),
          Divider(),
          Container(
            height: 10.0,
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: InkWell(
              onTap: () {
                FirebaseAuth.instance.signOut().then((onValue) =>
                    {CustomFunctions().removeAllRoutes(context, RootScreen())});
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    MdiIcons.logout,
                    color: Colors.black,
                  ),
                  Container(
                    width: 10.0,
                  ),
                  Text(
                    "Sign Out",
                    style: Theme.of(context).textTheme.display1,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
