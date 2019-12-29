import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Mapping.dart';
import 'Authentication.dart';
void main() {
  runApp(new HealthyFood());
}

class HealthyFood extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: " Healthy Food",
      theme: new ThemeData(
        primaryColor: Colors.pink,
      ),
      home: MappingPage(auth: Auth(),),
    );
  }
}
