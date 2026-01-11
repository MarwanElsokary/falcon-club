import 'package:flutter/material.dart';

class LoginControllers {
  final phone = TextEditingController();
  final verifyCode = TextEditingController();

  //store data
  final email = TextEditingController();
  final name = TextEditingController();
  final lastName = TextEditingController();
  final password = TextEditingController();
  final confirmpassword = TextEditingController();
  final description = TextEditingController();
  //
  final height = TextEditingController();
  final weight = TextEditingController();
  final serialNumber = TextEditingController();

  void dispose() {
    phone.dispose();
    verifyCode.dispose();
    email.dispose();
    name.dispose();
    lastName.dispose();
    password.dispose();
    confirmpassword.dispose();
  }
}
