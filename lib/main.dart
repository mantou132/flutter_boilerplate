import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/home.dart';
import './home.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext _context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

void main() => runApp(App());
