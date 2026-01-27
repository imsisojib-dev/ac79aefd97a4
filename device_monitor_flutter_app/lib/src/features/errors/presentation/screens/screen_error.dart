import 'package:flutter/material.dart';

class ScreenError extends StatelessWidget {
  final String message;

  const ScreenError({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Page Not Found!',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Text(message),
        ),
      ),
    );
  }
}
