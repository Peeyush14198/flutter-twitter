import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tweetx/screens/other_profile.dart';
import 'package:tweetx/screens/profile_screen.dart';
import 'package:tweetx/util/custom_functions.dart';
import 'package:tweetx/widgets/custom_loader.dart';

class UserListScreen extends StatefulWidget {
  final DocumentSnapshot userDocumentSnapshot;
  UserListScreen({this.userDocumentSnapshot});
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "User List",
          style: Theme.of(context).textTheme.title,
        ),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection("user")
            .document(widget.userDocumentSnapshot.documentID)
            .snapshots(),
        builder: (context, userSnapshot) {
          if (!userSnapshot.hasData) {
            return CustomLoaderWidget();
          } else {
            List following = userSnapshot.data['following'] ?? [];
            return StreamBuilder(
              stream: Firestore.instance.collection("user").snapshots(),
              builder: (context, allSnapshot) {
                if (!allSnapshot.hasData) {
                  return CustomLoaderWidget();
                } else {
                  var ds = allSnapshot.data.documents;
                  return ListView.builder(
                    itemCount: ds.length,
                    itemBuilder: (context, index) {
                      return ds[index].documentID ==
                              widget.userDocumentSnapshot.documentID
                          ? Container()
                          : Column(
                              children: <Widget>[
                                // index==1?
                                // Container(
                                //   height: 20.0,
                                // ):Container(),
                                Container(
                                  margin: EdgeInsets.only(top: 10.0),
                                  width: double.infinity,
                                  child: InkWell(
                                    onTap: () {
                                      CustomFunctions().customNavigation(
                                          context,
                                          OtherProfileScreen(
                                            myId: widget.userDocumentSnapshot
                                                .documentID,
                                            hisId: ds[index].documentID,
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
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                                    "https://w0.pngwave.com/png/639/452/computer-icons-avatar-user-profile-people-icon-png-clip-art.png"),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 90.0, top: 10, right: 40.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                ds[index].data['name'],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .title,
                                              ),
                                              Container(
                                                height: 5.0,
                                              ),
                                              Text(
                                                ds[index].data['email'],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .display2,
                                              )
                                            ],
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: following.contains(
                                                  ds[index].documentID)
                                              ? Container(
                                                  margin: EdgeInsets.only(
                                                      right: 10.0),
                                                  width: 80.0,
                                                  height: 30.0,
                                                  color: Colors.grey,
                                                  child: Center(
                                                    child: Text(
                                                      "Following",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .display1,
                                                    ),
                                                  ),
                                                )
                                              : InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      List list = [];
                                                      list += following;
                                                      list.add(
                                                          ds[index].documentID);
                                                      print(list);
                                                      Firestore.instance
                                                          .collection("user")
                                                          .document(widget
                                                              .userDocumentSnapshot
                                                              .documentID)
                                                          .updateData({
                                                        "following": list
                                                      });
                                                      List list1 = [];
                                                      list1 += ds[index].data[
                                                              'followers'] ??
                                                          [];
                                                      list1.add(widget
                                                          .userDocumentSnapshot
                                                          .documentID);
                                                      Firestore.instance
                                                          .collection("user")
                                                          .document(ds[index]
                                                              .documentID)
                                                          .updateData({
                                                        "followers": list1
                                                      });
                                                    });
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        right: 10.0),
                                                    width: 80.0,
                                                    height: 30.0,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    child: Center(
                                                      child: Text(
                                                        "Follow",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .button,
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
                    },
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
