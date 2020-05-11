import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:math';

class CustomFunctions {
  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
 

String randomString(int length) {
   var rand = new Random();
   var codeUnits = new List.generate(
      length, 
      (index){
        int n= rand.nextInt(33)+97;
         return n>122?122:n;
      }
   );
   
   return new String.fromCharCodes(codeUnits);
}
  void customNavigation(BuildContext context, Widget navigateTo) {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.leftToRight, child: navigateTo));
  }

  void removeAllRoutes(BuildContext context, Widget navigateTo) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => navigateTo),
        (Route<dynamic> route) => false);
  }
}
