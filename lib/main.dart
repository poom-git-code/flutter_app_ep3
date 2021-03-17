import 'package:flutter/material.dart';
import 'package:flutter_app_ep3/views/home_ui.dart';

void main(){
  runApp(
    MaterialApp(
      home: HomeUI(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff457373),
        fontFamily: 'Kanit',
      ),
    )
  );
}