import 'package:flutter/material.dart';
import 'package:templateplease/pages/main.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Template, Please',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: mainPage(),
    ),
  );
}

