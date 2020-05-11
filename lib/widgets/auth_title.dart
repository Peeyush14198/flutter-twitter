import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.only(
      left: 10.0,
      right: 10.0
    ),
    child: Column(
      children: <Widget>[
        Text("Fill in the required details and click Proceed.\nFields marked * are manadatory")
      ],
    ),
    );
  }
}
