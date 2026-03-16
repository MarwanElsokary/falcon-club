import 'package:flutter/material.dart';
import 'report_widgets.dart';

// ══════════════════════════════════════════════════════════════════════════════
// صفحة 1 — البدنية
// ══════════════════════════════════════════════════════════════════════════════
class ReportPage1Physical extends StatelessWidget {
  final int speed, strength, agility, endurance;
  final ValueChanged<int> onSpeedChanged, onStrengthChanged,
      onAgilityChanged, onEnduranceChanged;
  final TextEditingController physicalNotes;

  const ReportPage1Physical({
    super.key,
    required this.speed, required this.strength,
    required this.agility, required this.endurance,
    required this.onSpeedChanged, required this.onStrengthChanged,
    required this.onAgilityChanged, required this.onEnduranceChanged,
    required this.physicalNotes,
  });

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      sectionNumber: 1,
      sectionTitle: 'البدنية',
      child: Column(
        children: [
          RatingRow(label: 'السرعة', labelEn: 'SPEED', emoji: '⚡', value: speed, onChanged: onSpeedChanged),
          RatingRow(label: 'القوة', labelEn: 'STRENGTH', emoji: '💪', value: strength, onChanged: onStrengthChanged),
          RatingRow(label: 'الرشاقة', labelEn: 'AGILITY', emoji: '🤸', value: agility, onChanged: onAgilityChanged),
          RatingRow(label: 'التحمل', labelEn: 'ENDURANCE', emoji: '❤️', value: endurance, onChanged: onEnduranceChanged),
          NotesField(controller: physicalNotes),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// صفحة 2 — مهاريا / خططيا (جزء 1)
// ══════════════════════════════════════════════════════════════════════════════
class ReportPage2Skills1 extends StatelessWidget {
  final int attacking, shooting, runningBall, passing, movementWithoutBall1;
  final ValueChanged<int> onAttackingChanged, onShootingChanged,
      onRunningBallChanged, onPassingChanged, onMovementChanged;
  final TextEditingController attackingNotes, shootingNotes,
      runningBallNotes, passingNotes, movementNotes;

  const ReportPage2Skills1({
    super.key,
    required this.attacking, required this.shooting,
    required this.runningBall, required this.passing,
    required this.movementWithoutBall1,
    required this.onAttackingChanged, required this.onShootingChanged,
    required this.onRunningBallChanged, required this.onPassingChanged,
    required this.onMovementChanged,
    required this.attackingNotes, required this.shootingNotes,
    required this.runningBallNotes, required this.passingNotes,
    required this.movementNotes,
  });

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      sectionNumber: 2,
      sectionTitle: 'مهاريا / خططيا',
      child: Column(
        children: [
          RatingRow(label: 'المهاجمة', emoji: '🎯', value: attacking, onChanged: onAttackingChanged, notes: attackingNotes),
          RatingRow(label: 'التصويب على المرمى', emoji: '⚽', value: shooting, onChanged: onShootingChanged, notes: shootingNotes),
          RatingRow(label: 'الجري بالكرة', emoji: '🏃', value: runningBall, onChanged: onRunningBallChanged, notes: runningBallNotes),
          RatingRow(label: 'تمرير الكرة بباطن القدم', emoji: '🔄', value: passing, onChanged: onPassingChanged, notes: passingNotes),
          RatingRow(label: 'التحرك بدون كرة', emoji: '🏃', value: movementWithoutBall1, onChanged: onMovementChanged, notes: movementNotes),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// صفحة 3 — مهاريا / خططيا (جزء 2)
// ══════════════════════════════════════════════════════════════════════════════
class ReportPage3Skills2 extends StatelessWidget {
  final int ballAbsorption, ballControl, ballReception, vision, throwIn, goalkeeping;
  final ValueChanged<int> onBallAbsorptionChanged, onBallControlChanged,
      onBallReceptionChanged, onVisionChanged, onThrowInChanged, onGoalkeepingChanged;
  final TextEditingController ballAbsorptionNotes, ballControlNotes,
      ballReceptionNotes, visionNotes, throwInNotes, goalkeepingNotes;

  const ReportPage3Skills2({
    super.key,
    required this.ballAbsorption, required this.ballControl,
    required this.ballReception, required this.vision,
    required this.throwIn, required this.goalkeeping,
    required this.onBallAbsorptionChanged, required this.onBallControlChanged,
    required this.onBallReceptionChanged, required this.onVisionChanged,
    required this.onThrowInChanged, required this.onGoalkeepingChanged,
    required this.ballAbsorptionNotes, required this.ballControlNotes,
    required this.ballReceptionNotes, required this.visionNotes,
    required this.throwInNotes, required this.goalkeepingNotes,
  });

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      sectionNumber: 2,
      sectionTitle: 'مهاريا / خططيا (تابع)',
      child: Column(
        children: [
          RatingRow(label: 'امتصاص الكرة', emoji: '🫧', value: ballAbsorption, onChanged: onBallAbsorptionChanged, notes: ballAbsorptionNotes),
          RatingRow(label: 'كتم الكرة', emoji: '🤲', value: ballControl, onChanged: onBallControlChanged, notes: ballControlNotes),
          RatingRow(label: 'استلام الكرة', emoji: '✋', value: ballReception, onChanged: onBallReceptionChanged, notes: ballReceptionNotes),
          RatingRow(label: 'الرؤية', labelEn: 'VISION', emoji: '👁️', value: vision, onChanged: onVisionChanged, notes: visionNotes),
          RatingRow(label: 'رمية التماس', emoji: '⚽', value: throwIn, onChanged: onThrowInChanged, notes: throwInNotes),
          RatingRow(label: 'حراسة المرمى', emoji: '🛡️', value: goalkeeping, onChanged: onGoalkeepingChanged, notes: goalkeepingNotes),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// صفحة 4 — مهاريا / خططيا (جزء 3)
// ══════════════════════════════════════════════════════════════════════════════
class ReportPage4Skills3 extends StatelessWidget {
  final int finishing, dribbling, quickThinking, creativity,
      oneOnOneDefense, oneOnOneOffense, chestControl,
      positionAwareness, heading, defensivePositioning;
  final ValueChanged<int> onFinishingChanged, onDribblingChanged,
      onQuickThinkingChanged, onCreativityChanged, onOneOnOneDefenseChanged,
      onOneOnOneOffenseChanged, onChestControlChanged,
      onPositionAwarenessChanged, onHeadingChanged, onDefensivePositioningChanged;
  final TextEditingController finishingNotes, dribblingNotes,
      quickThinkingNotes, creativityNotes, oneOnOneDefenseNotes,
      oneOnOneOffenseNotes, chestControlNotes, positionAwarenessNotes,
      headingNotes, defensivePositioningNotes;

  const ReportPage4Skills3({
    super.key,
    required this.finishing, required this.dribbling,
    required this.quickThinking, required this.creativity,
    required this.oneOnOneDefense, required this.oneOnOneOffense,
    required this.chestControl, required this.positionAwareness,
    required this.heading, required this.defensivePositioning,
    required this.onFinishingChanged, required this.onDribblingChanged,
    required this.onQuickThinkingChanged, required this.onCreativityChanged,
    required this.onOneOnOneDefenseChanged, required this.onOneOnOneOffenseChanged,
    required this.onChestControlChanged, required this.onPositionAwarenessChanged,
    required this.onHeadingChanged, required this.onDefensivePositioningChanged,
    required this.finishingNotes, required this.dribblingNotes,
    required this.quickThinkingNotes, required this.creativityNotes,
    required this.oneOnOneDefenseNotes, required this.oneOnOneOffenseNotes,
    required this.chestControlNotes, required this.positionAwarenessNotes,
    required this.headingNotes, required this.defensivePositioningNotes,
  });

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      sectionNumber: 2,
      sectionTitle: 'مهاريا / خططيا (تابع)',
      child: Column(
        children: [
          RatingRow(label: 'الإنهاء على المرمى', emoji: '🎯', value: finishing, onChanged: onFinishingChanged, notes: finishingNotes),
          RatingRow(label: 'المراوغة', emoji: '🔄', value: dribbling, onChanged: onDribblingChanged, notes: dribblingNotes),
          RatingRow(label: 'سرعة البديهة', emoji: '💡', value: quickThinking, onChanged: onQuickThinkingChanged, notes: quickThinkingNotes),
          RatingRow(label: 'الابتكار داخل الملعب', emoji: '💡', value: creativity, onChanged: onCreativityChanged, notes: creativityNotes),
          RatingRow(label: '1×1 دفاعيا', emoji: '🛡️', value: oneOnOneDefense, onChanged: onOneOnOneDefenseChanged, notes: oneOnOneDefenseNotes),
          RatingRow(label: '1×1 هجوميا', emoji: '⚡', value: oneOnOneOffense, onChanged: onOneOnOneOffenseChanged, notes: oneOnOneOffenseNotes),
          RatingRow(label: 'امتصاص بالصدر', emoji: '🫱', value: chestControl, onChanged: onChestControlChanged, notes: chestControlNotes),
          RatingRow(label: 'وعي اللاعب بمركزه', emoji: '📍', value: positionAwareness, onChanged: onPositionAwarenessChanged, notes: positionAwarenessNotes),
          RatingRow(label: 'ضرب الكرة بالرأس', emoji: '🏐', value: heading, onChanged: onHeadingChanged, notes: headingNotes),
          RatingRow(label: 'وقفة لاعب الدفاع', emoji: '🛡️', value: defensivePositioning, onChanged: onDefensivePositioningChanged, notes: defensivePositioningNotes),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// صفحة 5 — نفسيا
// ══════════════════════════════════════════════════════════════════════════════
class ReportPage5Psychological extends StatelessWidget {
  final int calm, commitment, leadership, motivation, concentration, cooperation;
  final ValueChanged<int> onCalmChanged, onCommitmentChanged,
      onLeadershipChanged, onMotivationChanged,
      onConcentrationChanged, onCooperationChanged;
  final TextEditingController psychologicalNotes;

  const ReportPage5Psychological({
    super.key,
    required this.calm, required this.commitment, required this.leadership,
    required this.motivation, required this.concentration, required this.cooperation,
    required this.onCalmChanged, required this.onCommitmentChanged,
    required this.onLeadershipChanged, required this.onMotivationChanged,
    required this.onConcentrationChanged, required this.onCooperationChanged,
    required this.psychologicalNotes,
  });

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      sectionNumber: 3,
      sectionTitle: 'نفسيا',
      child: Column(
        children: [
          RatingRow(label: 'الهدوء', labelEn: 'CALM', emoji: '😌', value: calm, onChanged: onCalmChanged),
          RatingRow(label: 'الالتزام', labelEn: 'COMMITMENT', emoji: '✅', value: commitment, onChanged: onCommitmentChanged),
          RatingRow(label: 'القيادة', labelEn: 'LEADERSHIP', emoji: '👑', value: leadership, onChanged: onLeadershipChanged),
          RatingRow(label: 'التحفيز', labelEn: 'MOTIVATION', emoji: '🔥', value: motivation, onChanged: onMotivationChanged),
          RatingRow(label: 'التركيز', labelEn: 'CONCENTRATION', emoji: '🎯', value: concentration, onChanged: onConcentrationChanged),
          RatingRow(label: 'التعاون', labelEn: 'COOPERATE', emoji: '🤝', value: cooperation, onChanged: onCooperationChanged),
          NotesField(controller: psychologicalNotes),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// صفحة 6 — عام
// ══════════════════════════════════════════════════════════════════════════════
class ReportPage6General extends StatelessWidget {
  final int aggressiveness, senseOfResponsibility, strengthOfCharacter,
      communication, personalCleanliness, attendance, overallRating;
  final ValueChanged<int> onAggressivenessChanged, onSenseOfResponsibilityChanged,
      onStrengthOfCharacterChanged, onCommunicationChanged,
      onPersonalCleanlinessChanged, onAttendanceChanged, onOverallRatingChanged;
  final TextEditingController generalNotes;

  const ReportPage6General({
    super.key,
    required this.aggressiveness, required this.senseOfResponsibility,
    required this.strengthOfCharacter, required this.communication,
    required this.personalCleanliness, required this.attendance,
    required this.overallRating,
    required this.onAggressivenessChanged, required this.onSenseOfResponsibilityChanged,
    required this.onStrengthOfCharacterChanged, required this.onCommunicationChanged,
    required this.onPersonalCleanlinessChanged, required this.onAttendanceChanged,
    required this.onOverallRatingChanged,
    required this.generalNotes,
  });

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      sectionNumber: 4,
      sectionTitle: 'عام',
      child: Column(
        children: [
          RatingRow(label: 'العدوانية', labelEn: 'Aggressiveness', emoji: '💢', value: aggressiveness, onChanged: onAggressivenessChanged),
          RatingRow(label: 'حس المسؤولية', labelEn: 'SENSE OF RESPONSIBILITY', emoji: '📋', value: senseOfResponsibility, onChanged: onSenseOfResponsibilityChanged),
          RatingRow(label: 'قوة الشخصية', labelEn: 'STRENGTH OF CHARACTER', emoji: '💪', value: strengthOfCharacter, onChanged: onStrengthOfCharacterChanged),
          RatingRow(label: 'التواصل', labelEn: 'COMMUNICATION', emoji: '💬', value: communication, onChanged: onCommunicationChanged),
          RatingRow(label: 'النظافة الشخصية', labelEn: 'PERSONAL CLEANLINESS', emoji: '✨', value: personalCleanliness, onChanged: onPersonalCleanlinessChanged),
          RatingRow(label: 'الحضور', labelEn: 'ATTENDANCE', emoji: '📅', value: attendance, onChanged: onAttendanceChanged),
          const Divider(height: 20),
          RatingRow(
            label: 'التقييم الكامل',
            labelEn: 'Full Assessment',
            emoji: '⭐',
            value: overallRating,
            onChanged: onOverallRatingChanged,
            highlight: true,
          ),
          NotesField(controller: generalNotes, hint: 'ملاحظات عامة...'),
        ],
      ),
    );
  }
}