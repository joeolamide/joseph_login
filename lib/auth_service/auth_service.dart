import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:joseph_login/sucess_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String _signUpUrl = 'https://eldercall-p.onrender.com/auth/signup';
  final String _loginUrl = 'https://eldercall-p.onrender.com/auth/login';

  Future<bool> signUp(String fullName, String email, String password, String confirmPassword, BuildContext context) async {
    final response = await http.post(
      Uri.parse(_signUpUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'fullname': fullName,'email': email, 'password': password, 'confirmPassword': confirmPassword }),
    );

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('Sign up successful'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return true;
    } else {
      print('Sign up failed with status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      String errorMessage = 'Sign up failed';
      try {
        final errorData = jsonDecode(response.body);
        if (errorData is Map<String, dynamic> && errorData.containsKey('error')) {
          errorMessage = errorData['error'];
        }
      } catch (e) {
        print('Error decoding response body: $e');
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return false;
    }
  }

 
Future<bool> login(String email, String password, BuildContext context) async {
  final response = await http.post(
    Uri.parse(_loginUrl),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );

  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    final token = responseData['token'];
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token); // Use setString since token is a String

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Success'),
        content: Text('Login successful'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SuccessScreen()),
            ),
            child: Text('OK'),
          ),
        ],
      ),
    );
    return true;
  } else {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text('Login failed'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
    return false;
  }
}
}