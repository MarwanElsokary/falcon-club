import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../invitation/ui/screen/send_invitation_screen.dart';
import '../../../player_notes/ui/screen/player_notes_screen.dart';
import '../../../player_reports/ui/screen/create_report_screen.dart';

class ClubActionsWidget extends StatelessWidget {
  final String playerId;
  final String playerName;

  const ClubActionsWidget({
    super.key,
    required this.playerId,
    required this.playerName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          // Action buttons row
          Row(
            children: [
              // Send Invitation
              Expanded(
                child: _buildActionButton(
                  context: context,
                  icon: Icons.mail_outline,
                  label: 'ارسال دعوة'.tr(),
                  color: mainColor,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SendInvitationScreen(
                          playerId: playerId,
                          playerName: playerName,
                        ),
                      ),
                    );
                  },
                ),
              ),
              horizontalSpace(8),
              // Add Note
              Expanded(
                child: _buildActionButton(
                  context: context,
                  icon: Icons.note_add_outlined,
                  label: 'ملاحظات'.tr(),
                  color: Colors.teal,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PlayerNotesScreen(
                          playerId: playerId,
                          playerName: playerName,
                        ),
                      ),
                    );
                  },
                ),
              ),
              horizontalSpace(8),
              // Create Report
              Expanded(
                child: _buildActionButton(
                  context: context,
                  icon: Icons.assessment_outlined,
                  label: 'تقرير'.tr(),
                  color: Colors.orange,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CreateReportScreen(
                          playerId: playerId,
                          playerName: playerName,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 22.w),
            verticalSpace(6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
