import 'package:flutter/material.dart';

class ScreenHome extends StatelessWidget{
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello World"),
      ),
      body: SafeArea(
        child: Center(
          child: Text("Welcome to Home"),
        ),
      ),
    );
  }

}