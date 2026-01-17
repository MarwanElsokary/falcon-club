// lib/core/manager/app_lifecycle_manager.dart
import 'package:flutter/material.dart';
import 'package:falcon/core/helpers/shared_pref_helper.dart';

import '../../../../core/helpers/constants.dart';

class AppLifecycleManager extends StatefulWidget {
  final Widget child;

  const AppLifecycleManager({super.key, required this.child});

  @override
  State<AppLifecycleManager> createState() => _AppLifecycleManagerState();
}

class _AppLifecycleManagerState extends State<AppLifecycleManager>
    with WidgetsBindingObserver {
  DateTime? _lastShownTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkAndShowProfileReminder();
    }
  }

  Future<void> _checkAndShowProfileReminder() async {
    // التحقق كل 24 ساعة
    final now = DateTime.now();
    if (_lastShownTime != null &&
        now.difference(_lastShownTime!).inHours < 24) {
      return;
    }

    final token = await SharedPrefHelper.getSecuredString(
      SharedPrefKeys.userToken,
    );

    if (token != null && token.isNotEmpty) {
      final isCompleted = await SharedPrefHelper.getBool(
        SharedPrefKeys.isCompleted,
      ) ?? false;

      if (!isCompleted) {
        _showPeriodicReminder();
        _lastShownTime = now;
      }
    }
  }

  void _showPeriodicReminder() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.person_add_alt_1, color: Colors.orange[800]),
            SizedBox(width: 10),
            Text('تذكير', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          'ملفك الشخصي لا يزال غير مكتمل. إكماله سيمكنك من:'
              '\n• المشاركة في المباريات'
              '\n• التواصل مع اللاعبين'
              '\n• الحصول على إحصائيات شخصية'
              '\n• تحسين فرص الانضمام للأندية',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('لاحقاً'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/complete-profile');
            },
            child: Text('إكمال الآن'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}