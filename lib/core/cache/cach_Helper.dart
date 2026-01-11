import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../feature/main_screen/data/model/my_profile_model.dart';

class CacheHelper {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    _prefs = await SharedPreferences.getInstance();
  }

  //save myProfile
  static Future<bool> savemyProfile(MyProfileModel myProfile) async {
    try {
      String jsonString = json.encode(myProfile.toJson()); // Convert to JSON
      return await _prefs?.setString('myProfile', jsonString) ?? false;
    } catch (e) {
      return false;
    }
  }

  // Retrieve AcceptTripModel (myProfile) from SharedPreferences
  static MyProfileModel? getmyProfile() {
    try {
      String? jsonString = _prefs?.getString('myProfile');
      if (jsonString != null && jsonString.isNotEmpty) {
        Map<String, dynamic> jsonMap = json.decode(jsonString);
        return MyProfileModel.fromJson(jsonMap); // Convert to AcceptTripModel
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> saveFcmTokn(String fcmTokn) async {
    try {
      return await _prefs?.setString('FCM', fcmTokn) ?? false;
    } catch (e) {
      return false;
    }
  }

  static String getFcmTokn() {
    try {
      return _prefs?.getString('FCM') ?? "";
    } catch (e) {
      return "";
    }
  }

  static clearShared() {
    _prefs?.clear();
  }
}
