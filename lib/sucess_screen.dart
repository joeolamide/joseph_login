import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Perfect',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}