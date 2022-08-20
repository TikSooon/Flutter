//flutter
import 'package:beat_sheet/MainPage.dart';
import 'package:flutter/material.dart';
import 'main.dart';

//One Shot

import 'Trash.dart';



//Route to Homepage
Route toMain() {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => MainPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0, -1);
        var end = Offset.zero;
        var curve = Curves.easeInOut;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      }
  );
}

//Route to Trash Page
Route toTrashPage() {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => TrashPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1, 0);
        var end = Offset.zero;
        var curve = Curves.easeInOut;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      }
  );
}
/*
//CALL SHEET
//Route to CS.main
Route toCS_main(int index) {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => CS_main(index: index),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1, 0);
        var end = Offset.zero;
        var curve = Curves.easeInOut;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: tween.animate(animation),
          child: child,
        );
      }
  );
}


//Route to CS.Sub.location
Route toCS_locationImgView(int index, List<dynamic> locationList) {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => CS_locationImgView(index: index, locationList: locationList),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0, 1);
        var end = Offset.zero;
        var curve = Curves.easeInOut;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: tween.animate(animation),
          child: child,
        );
      }
  );
}

//Route to CS.Sub.schedule


 */