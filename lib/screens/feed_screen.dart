import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:tweetx/screens/other_profile.dart';
import 'package:tweetx/screens/post.dart';
import 'package:tweetx/screens/profile_screen.dart';
import 'package:tweetx/util/custom_functions.dart';
import 'package:tweetx/widgets/custom_drawer.dart';
import 'package:tweetx/widgets/custom_fade_animation.dart';
import 'package:tweetx/widgets/custom_loader.dart';

class FeedScreen extends StatefulWidget {
  final String userId;
  FeedScreen({this.userId});
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController _hideButtonController;
  var _isVisible;

  @override
  void initState() {
    _isVisible = true;
    _hideButtonController = new ScrollController();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isVisible == true) {
          /* only set when the previous state is false
             * Less widget rebuilds
             */

          setState(() {
            _isVisible = false;
          });
        }
      } else {
        if (_hideButtonController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_isVisible == false) {
            /* only set when the previous state is false
               * Less widget rebuilds
               */

            setState(() {
              _isVisible = true;
            });
          }
        }
      }
    });
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("user")
          .document(widget.userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CustomLoaderWidget();
        } else {
          return Scaffold(
            key: scaffoldKey,
            floatingActionButton: Visibility(
                visible: _isVisible,
                child: SpeedDial(
                  marginRight: 18,
                  marginBottom: 20,
                  animatedIcon: AnimatedIcons.add_event,
                  animatedIconTheme: IconThemeData(size: 22.0),
                  closeManually: false,
                  curve: Curves.bounceIn,
                  overlayColor: Colors.black,
                  overlayOpacity: 0.5,
                  tooltip: 'Speed Dial',
                  heroTag: 'speed-dial-hero-tag',
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 8.0,
                  shape: CircleBorder(),
                  children: [
                    SpeedDialChild(
                        child: Icon(Icons.add),
                        backgroundColor: Color(0xFFe9b59f),
                        label: 'Post',
                        labelStyle: Theme.of(context).textTheme.display1,
                        onTap: () {
                          CustomFunctions().customNavigation(
                              context, Post(userSnapshot: snapshot.data));
                        }),
                  ],
                )),
            drawer: CustomDrawer(userSnapshot: snapshot.data),
            appBar: AppBar(
              title: Text(
                "My Feed",
                style: Theme.of(context).textTheme.title,
              ),
              centerTitle: true,
              leading: IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Colors.black,
                  ),
                  onPressed: () => scaffoldKey.currentState.openDrawer()),
              actions: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                )
              ],
            ),
            body: StreamBuilder(
              stream: Firestore.instance
                  .collection("activity")
                  .orderBy('timeStamp', descending: true)
                  .snapshots(),
              builder: (context, activitySnapshot) {
                if (!activitySnapshot.hasData) {
                  return CustomLoaderWidget();
                } else {
                  var ds = activitySnapshot.data.documents;
                  List following = snapshot.data['following'] ?? [];
                  List feedList = [];
                  for (int i = 0; i < ds.length; i++) {
                    if (following.contains(ds[i].data['uid']) ||
                        ds[i].data['uid'] == widget.userId) {
                      feedList.add(ds[i].data);
                    }
                  }
                  return ListView.builder(
                    itemCount: feedList.length,
                    controller: _hideButtonController,
                    itemBuilder: (context, index) {
                      Timestamp previousTimestamp =
                          feedList[index]['timeStamp'];
                      DateTime currentTimestamp = Timestamp.now().toDate();
                      var postTime = "";
                      if (currentTimestamp
                              .difference(previousTimestamp.toDate())
                              .inSeconds >
                          60) {
                        if (currentTimestamp
                                .difference(previousTimestamp.toDate())
                                .inMinutes >
                            60) {
                          if (Timestamp.now()
                                  .toDate()
                                  .difference(previousTimestamp.toDate())
                                  .inHours >
                              24) {
                            postTime =
                                "${currentTimestamp.difference(previousTimestamp.toDate()).inDays}d";
                          } else {
                            postTime =
                                "${currentTimestamp.difference(previousTimestamp.toDate()).inHours}h";
                          }
                        } else {
                          postTime =
                              "${currentTimestamp.difference(previousTimestamp.toDate()).inMinutes}m";
                        }
                      } else {
                        postTime =
                            "${currentTimestamp.difference(previousTimestamp.toDate()).inSeconds}s";
                      }
                      return FutureBuilder(
                        future: Firestore.instance
                            .collection("user")
                            .document(feedList[index]['uid'])
                            .get(),
                        builder: (context, userSnap) {
                          // print(CustomFunctions().randomString(6));
                          if (!userSnap.hasData) {
                            return Container();
                          } else {
                            return CustomFadeAnimation(
                                child: Padding(
                              padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                              child: Card(
                                elevation: 5.0,
                                color: Colors.white,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        height: 10.0,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 10.0, right: 10.0),
                                        child: InkWell(
                                          onTap: () {
                                            if (userSnap.data.documentID ==
                                                snapshot.data.documentID) {
                                              CustomFunctions()
                                                  .customNavigation(
                                                      context,
                                                      ProfileScreen(
                                                        userSnapshot:
                                                            userSnap.data,
                                                      ));
                                            } else {
                                              CustomFunctions()
                                                  .customNavigation(
                                                      context,
                                                      OtherProfileScreen(
                                                        myId: snapshot
                                                            .data.documentID,
                                                        hisId: userSnap
                                                            .data.documentID,
                                                      ));
                                            }
                                          },
                                          child: Row(
                                            children: <Widget>[
                                              Stack(
                                                children: <Widget>[
                                                  CircleAvatar(
                                                    maxRadius: 20.0,
                                                    minRadius: 20.0,
                                                    backgroundColor:
                                                        Colors.white,
                                                    backgroundImage:
                                                        CachedNetworkImageProvider(
                                                            "https://w0.pngwave.com/png/639/452/computer-icons-avatar-user-profile-people-icon-png-clip-art.png"),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 50.0, top: 3),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Text(
                                                          userSnap.data['name'],
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .display1,
                                                        ),
                                                        Container(
                                                          height: 5.0,
                                                        ),
                                                        Text(
                                                          userSnap
                                                              .data['email'],
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .display2,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Spacer(),
                                              Text(
                                                postTime,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .display1,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 20.0,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 10.0, right: 10.0),
                                        child: Text(
                                          feedList[index]['post'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .display1,
                                        ),
                                      ),
                                      Container(
                                        height: 20.0,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ));
                          }
                        },
                      );
                    },
                  );
                }
              },
            ),
          );
        }
      },
    );
  }
}
