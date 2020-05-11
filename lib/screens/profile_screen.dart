import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tweetx/screens/other_profile.dart';
import 'package:tweetx/util/custom_functions.dart';
import 'package:tweetx/widgets/custom_fade_animation.dart';
import 'package:tweetx/widgets/custom_loader.dart';

class ProfileScreen extends StatefulWidget {
  final DocumentSnapshot userSnapshot;
  ProfileScreen({this.userSnapshot});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("user")
          .document(widget.userSnapshot.documentID)
          .snapshots(),
      builder: (context, parentSnapshot) {
        if (!parentSnapshot.hasData) {
          return CustomLoaderWidget();
        } else {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
                appBar: AppBar(
                  title: Text(
                    "Profile",
                    style: Theme.of(context).textTheme.title,
                  ),
                  centerTitle: true,
                  leading: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  bottom: PreferredSize(
                      child: CustomFadeAnimation(
                          child: Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              child: Padding(
                                padding:
                                    EdgeInsets.only(left: 10.0, right: 10.0),
                                child: Stack(
                                  children: <Widget>[
                                    CircleAvatar(
                                      maxRadius: 40.0,
                                      minRadius: 40.0,
                                      backgroundColor: Colors.white,
                                      backgroundImage: NetworkImage(
                                          "https://w0.pngwave.com/png/639/452/computer-icons-avatar-user-profile-people-icon-png-clip-art.png"),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 90.0, top: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            parentSnapshot.data['name'],
                                            style: Theme.of(context)
                                                .textTheme
                                                .title,
                                          ),
                                          Container(
                                            height: 5.0,
                                          ),
                                          Text(
                                            parentSnapshot.data['email'],
                                            style: Theme.of(context)
                                                .textTheme
                                                .display2,
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 10.0,
                            ),
                            TabBar(tabs: [
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10.0),
                                child: Text(
                                  "${parentSnapshot.data['followers'].length}\nFollowers",
                                  style: Theme.of(context).textTheme.display1,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10.0),
                                child: Text(
                                  "${parentSnapshot.data['following'].length}\nFollowing",
                                  style: Theme.of(context).textTheme.display1,
                                ),
                              ),
                            ])
                          ],
                        ),
                      )),
                      preferredSize: const Size.fromHeight(150.0)),
                ),
                body: TabBarView(children: [
                  CustomFadeAnimation(
                    child: followerList(parentSnapshot),
                  ),
                  CustomFadeAnimation(
                    child: followingList(parentSnapshot),
                  )
                ])),
          );
        }
      },
    );
  }

  Widget followerList(parentSnapshot) {
    List<Widget> list = [];
    List followers = parentSnapshot.data['followers'] ?? [];
    List following = parentSnapshot.data['following'] ?? [];
    list.add(Container(
      height: 20.0,
    ));
    for (int i = 0; i < followers.length; i++) {
      list.add(StreamBuilder(
        stream: Firestore.instance
            .collection("user")
            .document(followers[i])
            .snapshots(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return Container();
          } else {
            return Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: InkWell(
                    onTap: () {
                      CustomFunctions().customNavigation(
                          context,
                          OtherProfileScreen(
                            myId: widget.userSnapshot.documentID,
                            hisId: snap.data.documentID,
                          ));
                    },
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: CircleAvatar(
                            maxRadius: 30.0,
                            minRadius: 30.0,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(
                                "https://w0.pngwave.com/png/639/452/computer-icons-avatar-user-profile-people-icon-png-clip-art.png"),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 90.0, top: 10, right: 40.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                snap.data['name'],
                                style: Theme.of(context).textTheme.title,
                              ),
                              Container(
                                height: 5.0,
                              ),
                              Text(
                                snap.data['email'],
                                style: Theme.of(context).textTheme.display2,
                              )
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: following.contains(followers[i])
                              ? Container(
                                  margin: EdgeInsets.only(right: 10.0),
                                  width: 80.0,
                                  height: 30.0,
                                  color: Colors.grey,
                                  child: Center(
                                    child: Text(
                                      "Following",
                                      style:
                                          Theme.of(context).textTheme.display1,
                                    ),
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    setState(() {
                                      List list = [];
                                      list += following;
                                      list.add(followers[i]);
                                      print(list);
                                      Firestore.instance
                                          .collection("user")
                                          .document(
                                              widget.userSnapshot.documentID)
                                          .updateData({"following": list});
                                      List list1 = [];
                                      list1 += snap.data['followers'] ?? [];
                                      list1.add(widget.userSnapshot.documentID);
                                      Firestore.instance
                                          .collection("user")
                                          .document(snap.data.documentID)
                                          .updateData({"followers": list1});
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(right: 10.0),
                                    width: 80.0,
                                    height: 30.0,
                                    color: Theme.of(context).primaryColor,
                                    child: Center(
                                      child: Text(
                                        "Follow",
                                        style:
                                            Theme.of(context).textTheme.button,
                                      ),
                                    ),
                                  ),
                                ),
                        )
                      ],
                    ),
                  ),
                ),
                Divider()
              ],
            );
          }
        },
      ));
    }
    return ListView(
      children: list,
    );
  }

  Widget followingList(parentSnapshot) {
    List<Widget> list = [];
    List followers = parentSnapshot.data['followers'] ?? [];
    List following = parentSnapshot.data['following'] ?? [];
    print(following.length);
    list.add(Container(
      height: 20.0,
    ));
    for (int i = 0; i < following.length; i++) {
      list.add(StreamBuilder(
        stream: Firestore.instance
            .collection("user")
            .document(following[i])
            .snapshots(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return Container();
          } else {
            return Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: InkWell(
                    onTap: () {
                      CustomFunctions().customNavigation(
                          context,
                          OtherProfileScreen(
                            myId: widget.userSnapshot.documentID,
                            hisId: following[i],
                          ));
                    },
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: CircleAvatar(
                            maxRadius: 30.0,
                            minRadius: 30.0,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(
                                "https://w0.pngwave.com/png/639/452/computer-icons-avatar-user-profile-people-icon-png-clip-art.png"),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 90.0, top: 10, right: 40.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                snap.data['name'],
                                style: Theme.of(context).textTheme.title,
                              ),
                              Container(
                                height: 5.0,
                              ),
                              Text(
                                snap.data['email'],
                                style: Theme.of(context).textTheme.display2,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider()
              ],
            );
          }
        },
      ));
    }
    return ListView(
      children: list,
    );
  }
}
