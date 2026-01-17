// lib/feature/profile/widget/profile_completion_progress.dart
import 'package:flutter/material.dart';
import 'package:falcon/core/helpers/shared_pref_helper.dart';

import '../../../../core/helpers/constants.dart';

class ProfileCompletionProgress extends StatelessWidget {
  final VoidCallback? onTap;

  const ProfileCompletionProgress({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getCompletionPercentage(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return SizedBox();

        final percentage = snapshot.data!;

        return GestureDetector(
          onTap: onTap,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: Colors.orange[800],
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'تقدم إكمال ملفك الشخصي',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Text(
                      '${percentage.toInt()}%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.orange[800],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                LinearProgressIndicator(
                  value: percentage / 100,
                  backgroundColor: Colors.orange[100],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.black
                  ),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
                SizedBox(height: 8),
                if (percentage < 100)
                  Text(
                    'أكمل باقي البيانات للتمتع بجميع المزايا',
                    style: TextStyle(
                      color: Colors.orange[700],
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<double> _getCompletionPercentage() async {
    // منطق حساب النسبة المئوية للإكمال
    // يمكنك تخصيصه حسب احتياجاتك
    final token = await SharedPrefHelper.getSecuredString(
      SharedPrefKeys.userToken,
    );

    if (token == null) return 0.0;

    final isCompleted = await SharedPrefHelper.getBool(
      SharedPrefKeys.isCompleted,
    ) ?? false;

    return isCompleted ? 100.0 : 30.0; // مثال
  }
}