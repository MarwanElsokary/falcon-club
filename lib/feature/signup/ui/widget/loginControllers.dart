import 'package:flutter/material.dart';

class LoginControllers {
  // Auth controllers
  final email = TextEditingController();
  final password = TextEditingController();
  final phone = TextEditingController();
  final verifyCode = TextEditingController();

  // Profile controllers
  final name = TextEditingController();
  final lastName = TextEditingController();
  final height = TextEditingController();
  final weight = TextEditingController();

  void dispose() {
    email.dispose();
    password.dispose();
    phone.dispose();
    verifyCode.dispose();
    name.dispose();
    lastName.dispose();
    height.dispose();
    weight.dispose();
  }

  void clearAll() {
    email.clear();
    password.clear();
    phone.clear();
    verifyCode.clear();
    name.clear();
    lastName.clear();
    height.clear();
    weight.clear();
  }
}