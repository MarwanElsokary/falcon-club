import 'package:flutter/material.dart';

class PackageController {
  final cardNumber = TextEditingController();
  final cardName = TextEditingController();

  //store data
  final cvv = TextEditingController();
  final expireData = TextEditingController();

  void dispose() {
    cardName.dispose();
    cardNumber.dispose();
    cvv.dispose();
    expireData.dispose();
  }
}
