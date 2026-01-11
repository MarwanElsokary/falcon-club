import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class PlayerRadarChart extends StatelessWidget {
  final double speed;
  final double strength;
  final double ballControl;
  final double tackling;
  final double dribbling;

  const PlayerRadarChart({
    super.key,
    required this.speed,
    required this.strength,
    required this.ballControl,
    required this.tackling,
    required this.dribbling,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: RadarChart(
        RadarChartData(
          radarShape: RadarShape.polygon,
          tickCount: 1,
          ticksTextStyle: const TextStyle(color: Colors.transparent),
          tickBorderData: const BorderSide(color: Colors.white24),
          radarBorderData: const BorderSide(color: Colors.white, width: 2),
          gridBorderData: const BorderSide(color: Colors.white24),

          dataSets: [
            RadarDataSet(
              fillColor: Colors.white.withOpacity(0.15),
              borderColor: Colors.white,
              borderWidth: 2,
              entryRadius: 4,
              dataEntries: [
                RadarEntry(value: speed),
                RadarEntry(value: strength),
                RadarEntry(value: ballControl),
                RadarEntry(value: tackling),
                RadarEntry(value: dribbling),
              ],
            ),
          ],

          titleTextStyle: GoogleFonts.cairo(
            color: Colors.white,
            fontSize: 10.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.30,
          ),
          getTitle: (index, angle) {
            switch (index) {
              case 0:
                return RadarChartTitle(text: "السرعة\n$speed", angle: 0);
              case 1:
                return RadarChartTitle(text: "القوة\n$strength", angle: 0);
              case 2:
                return RadarChartTitle(text: "المراوغة\n$dribbling", angle: 0);
              case 3:
                return RadarChartTitle(text: "التدخل\n$tackling", angle: 0);
              case 4:
                return RadarChartTitle(
                  text: "التحكم بالكرة\n$ballControl",
                  angle: 0,
                );
              default:
                return const RadarChartTitle(text: "");
            }
          },
        ),
      ),
    );
  }
}
