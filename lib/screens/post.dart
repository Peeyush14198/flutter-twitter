import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tweetx/widgets/custom_bounce_animation.dart';
import 'package:tweetx/widgets/custom_loader.dart';

class Post extends StatefulWidget {
  final DocumentSnapshot userSnapshot;
  Post({this.userSnapshot});
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  TextEditingController textEditingController = new TextEditingController();
  bool loader = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Post",
          style: Theme.of(context).textTheme.title,
        ),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: loader
          ? CustomLoaderWidget()
          : Stack(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: EdgeInsets.all(14),
                      child: Container(
                        child: TextField(
                          style: Theme.of(context).textTheme.display1,
                          controller: textEditingController,
                          maxLines: null,
                          maxLength: 80,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Write Something....',
                              hintStyle: Theme.of(context).textTheme.subhead),
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: CustomBounceButtonAnimation(
                      onTap: () {
                        if (textEditingController.text != null ||
                            textEditingController.text
                                    .toString()
                                    .compareTo(" ") !=
                                0) {
                          setState(() {
                            loader = true;
                          });
                          Firestore.instance.collection("activity").add({
                            "post": textEditingController.text,
                            "uid": widget.userSnapshot.documentID,
                            "timeStamp": Timestamp.now()
                          }).then((onValue) {
                            setState(() {
                              loader = false;
                              textEditingController.text = "";
                              Navigator.of(context).pop();
                              // Navigator.of(context).pop();
                            });
                          });
                        } else {}
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        height: 40.0,
                        width: MediaQuery.of(context).size.height,
                        color: Theme.of(context).primaryColor,
                        child: Center(
                          child: Text(
                            "Make a post",
                            style: Theme.of(context).textTheme.button,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
