import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../feature/main_screen/data/model/my_profile_model.dart';

class CacheHelper {
  static SharedPreferences? _prefs;

  // =======================
  // 🔹 INIT
  // =======================
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    _prefs = await SharedPreferences.getInstance();
  }

  // =======================
  // 🔹 MY PROFILE (WITH TIME)
  // =======================
  static Future<bool> savemyProfile(MyProfileModel myProfile) async {
    try {
      final data = {
        "time": DateTime.now().millisecondsSinceEpoch,
        "data": myProfile.toJson(),
      };

      return await _prefs?.setString('myProfile', jsonEncode(data)) ?? false;
    } catch (_) {
      return false;
    }
  }

  static MyProfileModel? getmyProfile() {
    try {
      final raw = _prefs?.getString('myProfile');
      if (raw == null || raw.isEmpty) return null;

      final decoded = jsonDecode(raw);
      return MyProfileModel.fromJson(decoded['data']);
    } catch (_) {
      return null;
    }
  }

  static bool isMyProfileValid({
    Duration minutes = const Duration(minutes: 10),
  }) {
    try {
      final raw = _prefs?.getString('myProfile');
      if (raw == null) return false;

      final decoded = jsonDecode(raw);
      final cachedTime = decoded['time'];

      final now = DateTime.now().millisecondsSinceEpoch;
      return (now - cachedTime) <= minutes.inMilliseconds;
    } catch (_) {
      return false;
    }
  }

  // =======================
  // 🔹 FCM TOKEN
  // =======================
  static Future<bool> saveFcmTokn(String fcmTokn) async {
    try {
      return await _prefs?.setString('FCM', fcmTokn) ?? false;
    } catch (_) {
      return false;
    }
  }

  static String getFcmTokn() {
    try {
      return _prefs?.getString('FCM') ?? "";
    } catch (_) {
      return "";
    }
  }

  static Future<bool> saveCategories(String json) async {
    return await _prefs?.setString('categories', json) ?? false;
  }

  static String? getCategories() {
    return _prefs?.getString('categories');
  }

  // =======================
  // 🔹 CLEAR
  // =======================
  static Future<void> clearShared() async {
    await _prefs?.clear();
  }

  static Future<bool> saveHomeTrials(String json) async {
    return await _prefs?.setString('home_trials', json) ?? false;
  }

  static String? getHomeTrials() {
    return _prefs?.getString('home_trials');
  }
  // دالة عامة لحفظ أي String
  static Future<bool> setString(String key, String value) async {
    try {
      return await _prefs?.setString(key, value) ?? false;
    } catch (e) {
      return false;
    }
  }

  // دالة عامة لجلب أي String
  static String getString(String key) {
    try {
      return _prefs?.getString(key) ?? '';
    } catch (e) {
      return '';
    }
  }
}
