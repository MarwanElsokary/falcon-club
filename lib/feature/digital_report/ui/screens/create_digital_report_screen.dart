import 'package:falconclubapp/core/di/dependency_injection.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/show_error_snack_bar.dart';
import 'package:falconclubapp/core/widget/showSuccesSnackBar.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:falconclubapp/feature/club_team/data/model/club_player_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../cubit/digitalReportCubit.dart';
import '../../data/model/digitalReportModel.dart';
import '../../data/repo/digitalReportRepo.dart';
import '../widget/report_pages.dart';

// ── Entry point ───────────────────────────────────────────────────────────────
Future<bool?> showCreateDigitalReport(
  BuildContext context, {
  required ClubPlayer player,
}) {
  return Navigator.of(context).push<bool>(
    MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (_) => DigitalReportCubit(getIt<DigitalReportRepo>()),
        child: CreateDigitalReportScreen(player: player),
      ),
      fullscreenDialog: true,
    ),
  );
}

// ── Screen ────────────────────────────────────────────────────────────────────
class CreateDigitalReportScreen extends StatefulWidget {
  final ClubPlayer player;
  const CreateDigitalReportScreen({super.key, required this.player});

  @override
  State<CreateDigitalReportScreen> createState() =>
      _CreateDigitalReportScreenState();
}

class _CreateDigitalReportScreenState extends State<CreateDigitalReportScreen> {
  final _pageCtrl = PageController();
  int _currentPage = 0;

  static const _pageTitles = [
    '1 / 6 — البدنية',
    '2 / 6 — مهاريا / خططيا',
    '3 / 6 — مهاريا (تابع)',
    '4 / 6 — مهاريا (تابع)',
    '5 / 6 — نفسيا',
    '6 / 6 — عام',
  ];

  // ── values ────────────────────────────────────────────────────────────────
  int speed = 3, strength = 3, agility = 3, endurance = 3;
  int attacking = 3,
      shooting = 3,
      runningBall = 3,
      passing = 3,
      movementWithoutBall1 = 3;
  int ballAbsorption = 3,
      ballControl = 3,
      ballReception = 3,
      vision = 3,
      throwIn = 3,
      goalkeeping = 3;
  int finishing = 3,
      dribbling = 3,
      quickThinking = 3,
      creativity = 3,
      oneOnOneDefense = 3,
      oneOnOneOffense = 3,
      chestControl = 3,
      positionAwareness = 3,
      heading = 3,
      defensivePositioning = 3;
  int calm = 3,
      commitment = 3,
      leadership = 3,
      motivation = 3,
      concentration = 3,
      cooperation = 3;
  int aggressiveness = 3,
      senseOfResponsibility = 3,
      strengthOfCharacter = 3,
      communication = 3,
      personalCleanliness = 3,
      attendance = 3,
      overallRating = 3;

  // ── controllers ───────────────────────────────────────────────────────────
  final _physicalNotes = TextEditingController();
  final _attackingNotes = TextEditingController();
  final _shootingNotes = TextEditingController();
  final _runningBallNotes = TextEditingController();
  final _passingNotes = TextEditingController();
  final _movementNotes = TextEditingController();
  final _ballAbsorptionNotes = TextEditingController();
  final _ballControlNotes = TextEditingController();
  final _ballReceptionNotes = TextEditingController();
  final _visionNotes = TextEditingController();
  final _throwInNotes = TextEditingController();
  final _goalkeepingNotes = TextEditingController();
  final _finishingNotes = TextEditingController();
  final _dribblingNotes = TextEditingController();
  final _quickThinkingNotes = TextEditingController();
  final _creativityNotes = TextEditingController();
  final _oneOnOneDefenseNotes = TextEditingController();
  final _oneOnOneOffenseNotes = TextEditingController();
  final _chestControlNotes = TextEditingController();
  final _positionAwarenessNotes = TextEditingController();
  final _headingNotes = TextEditingController();
  final _defensivePositioningNotes = TextEditingController();
  final _psychologicalNotes = TextEditingController();
  final _generalNotes = TextEditingController();

  @override
  void dispose() {
    _pageCtrl.dispose();
    for (final c in [
      _physicalNotes,
      _attackingNotes,
      _shootingNotes,
      _runningBallNotes,
      _passingNotes,
      _movementNotes,
      _ballAbsorptionNotes,
      _ballControlNotes,
      _ballReceptionNotes,
      _visionNotes,
      _throwInNotes,
      _goalkeepingNotes,
      _finishingNotes,
      _dribblingNotes,
      _quickThinkingNotes,
      _creativityNotes,
      _oneOnOneDefenseNotes,
      _oneOnOneOffenseNotes,
      _chestControlNotes,
      _positionAwarenessNotes,
      _headingNotes,
      _defensivePositioningNotes,
      _psychologicalNotes,
      _generalNotes,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  // ── navigation ────────────────────────────────────────────────────────────
  void _next() {
    if (_currentPage < _pageTitles.length - 1) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    } else {
      _submit();
    }
  }

  void _prev() {
    if (_currentPage > 0) {
      _pageCtrl.previousPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    }
  }

  void _submit() {
    context.read<DigitalReportCubit>().submitReport(
      CreateDigitalReportRequest(
        playerId: widget.player.id,
        playerName: widget.player.name,
        height: 0,
        weight: 0,
        playerAge: widget.player.age,
        month: _monthAr(),
        season: '2025-2026',
        speed: speed,
        strength: strength,
        agility: agility,
        endurance: endurance,
        physicalComments: _physicalNotes.text,
        attacking: attacking,
        attackingComments: _attackingNotes.text,
        shooting: shooting,
        shootingComments: _shootingNotes.text,
        runningBall: runningBall,
        runningBallComments: _runningBallNotes.text,
        passing: passing,
        passingComments: _passingNotes.text,
        movementWithoutBall1: movementWithoutBall1,
        movementWithoutBall1Comments: _movementNotes.text,
        ballAbsorption: ballAbsorption,
        ballAbsorptionComments: _ballAbsorptionNotes.text,
        ballControl: ballControl,
        ballControlComments: _ballControlNotes.text,
        ballReception: ballReception,
        ballReceptionComments: _ballReceptionNotes.text,
        vision: vision,
        visionComments: _visionNotes.text,
        throwIn: throwIn,
        throwInComments: _throwInNotes.text,
        goalkeeping: goalkeeping,
        goalkeepingComments: _goalkeepingNotes.text,
        finishing: finishing,
        finishingComments: _finishingNotes.text,
        dribbling: dribbling,
        dribblingComments: _dribblingNotes.text,
        quickThinking: quickThinking,
        quickThinkingComments: _quickThinkingNotes.text,
        creativity: creativity,
        creativityComments: _creativityNotes.text,
        oneOnOneDefense: oneOnOneDefense,
        oneOnOneDefenseComments: _oneOnOneDefenseNotes.text,
        oneOnOneOffense: oneOnOneOffense,
        oneOnOneOffenseComments: _oneOnOneOffenseNotes.text,
        chestControl: chestControl,
        chestControlComments: _chestControlNotes.text,
        positionAwareness: positionAwareness,
        positionAwarenessComments: _positionAwarenessNotes.text,
        heading: heading,
        headingComments: _headingNotes.text,
        defensivePositioning: defensivePositioning,
        defensivePositioningComments: _defensivePositioningNotes.text,
        calm: calm,
        commitment: commitment,
        leadership: leadership,
        motivation: motivation,
        concentration: concentration,
        cooperation: cooperation,
        psychologicalComments: _psychologicalNotes.text,
        aggressiveness: aggressiveness,
        senseOfResponsibility: senseOfResponsibility,
        strengthOfCharacter: strengthOfCharacter,
        communication: communication,
        personalCleanliness: personalCleanliness,
        attendance: attendance,
        overallRating: overallRating,
        generalComments: _generalNotes.text,
      ),
    );
  }

  String _monthAr() {
    const m = [
      '',
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    return m[DateTime.now().month];
  }

  // ── build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocListener<DigitalReportCubit, DigitalReportState>(
        listener: (context, state) {
          if (state is DigitalReportSubmitSuccess) {
            showSuccesSnackBar(
              context: context,
              title: 'تم حفظ التقرير بنجاح ✓',
            );
            Navigator.of(context).pop(true);
          }
          if (state is DigitalReportSubmitError) {
            showErrorSnackBar(context: context, title: state.error);
          }
        },
        child: Scaffold(
          backgroundColor: whiteclr,
          appBar: _buildAppBar(),
          body: Column(
            children: [
              _buildProgressBar(),
              Expanded(child: _buildPageView()),
              _buildNavBar(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: mainColor,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.close, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Column(
        children: [
          TextUtils(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            text: 'تقرير رقمي — ${widget.player.name}',
          ),
          Text(
            _pageTitles[_currentPage],
            style: TextStyle(color: Colors.white60, fontSize: 11.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      color: mainColor,
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 12.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: LinearProgressIndicator(
          value: (_currentPage + 1) / _pageTitles.length,
          backgroundColor: Colors.white24,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          minHeight: 5.h,
        ),
      ),
    );
  }

  Widget _buildPageView() {
    return PageView(
      controller: _pageCtrl,
      physics: const NeverScrollableScrollPhysics(),
      onPageChanged: (i) => setState(() => _currentPage = i),
      children: [
        ReportPage1Physical(
          speed: speed,
          strength: strength,
          agility: agility,
          endurance: endurance,
          onSpeedChanged: (v) => setState(() => speed = v),
          onStrengthChanged: (v) => setState(() => strength = v),
          onAgilityChanged: (v) => setState(() => agility = v),
          onEnduranceChanged: (v) => setState(() => endurance = v),
          physicalNotes: _physicalNotes,
        ),
        ReportPage2Skills1(
          attacking: attacking,
          shooting: shooting,
          runningBall: runningBall,
          passing: passing,
          movementWithoutBall1: movementWithoutBall1,
          onAttackingChanged: (v) => setState(() => attacking = v),
          onShootingChanged: (v) => setState(() => shooting = v),
          onRunningBallChanged: (v) => setState(() => runningBall = v),
          onPassingChanged: (v) => setState(() => passing = v),
          onMovementChanged: (v) => setState(() => movementWithoutBall1 = v),
          attackingNotes: _attackingNotes,
          shootingNotes: _shootingNotes,
          runningBallNotes: _runningBallNotes,
          passingNotes: _passingNotes,
          movementNotes: _movementNotes,
        ),
        ReportPage3Skills2(
          ballAbsorption: ballAbsorption,
          ballControl: ballControl,
          ballReception: ballReception,
          vision: vision,
          throwIn: throwIn,
          goalkeeping: goalkeeping,
          onBallAbsorptionChanged: (v) => setState(() => ballAbsorption = v),
          onBallControlChanged: (v) => setState(() => ballControl = v),
          onBallReceptionChanged: (v) => setState(() => ballReception = v),
          onVisionChanged: (v) => setState(() => vision = v),
          onThrowInChanged: (v) => setState(() => throwIn = v),
          onGoalkeepingChanged: (v) => setState(() => goalkeeping = v),
          ballAbsorptionNotes: _ballAbsorptionNotes,
          ballControlNotes: _ballControlNotes,
          ballReceptionNotes: _ballReceptionNotes,
          visionNotes: _visionNotes,
          throwInNotes: _throwInNotes,
          goalkeepingNotes: _goalkeepingNotes,
        ),
        ReportPage4Skills3(
          finishing: finishing,
          dribbling: dribbling,
          quickThinking: quickThinking,
          creativity: creativity,
          oneOnOneDefense: oneOnOneDefense,
          oneOnOneOffense: oneOnOneOffense,
          chestControl: chestControl,
          positionAwareness: positionAwareness,
          heading: heading,
          defensivePositioning: defensivePositioning,
          onFinishingChanged: (v) => setState(() => finishing = v),
          onDribblingChanged: (v) => setState(() => dribbling = v),
          onQuickThinkingChanged: (v) => setState(() => quickThinking = v),
          onCreativityChanged: (v) => setState(() => creativity = v),
          onOneOnOneDefenseChanged: (v) => setState(() => oneOnOneDefense = v),
          onOneOnOneOffenseChanged: (v) => setState(() => oneOnOneOffense = v),
          onChestControlChanged: (v) => setState(() => chestControl = v),
          onPositionAwarenessChanged: (v) =>
              setState(() => positionAwareness = v),
          onHeadingChanged: (v) => setState(() => heading = v),
          onDefensivePositioningChanged: (v) =>
              setState(() => defensivePositioning = v),
          finishingNotes: _finishingNotes,
          dribblingNotes: _dribblingNotes,
          quickThinkingNotes: _quickThinkingNotes,
          creativityNotes: _creativityNotes,
          oneOnOneDefenseNotes: _oneOnOneDefenseNotes,
          oneOnOneOffenseNotes: _oneOnOneOffenseNotes,
          chestControlNotes: _chestControlNotes,
          positionAwarenessNotes: _positionAwarenessNotes,
          headingNotes: _headingNotes,
          defensivePositioningNotes: _defensivePositioningNotes,
        ),
        ReportPage5Psychological(
          calm: calm,
          commitment: commitment,
          leadership: leadership,
          motivation: motivation,
          concentration: concentration,
          cooperation: cooperation,
          onCalmChanged: (v) => setState(() => calm = v),
          onCommitmentChanged: (v) => setState(() => commitment = v),
          onLeadershipChanged: (v) => setState(() => leadership = v),
          onMotivationChanged: (v) => setState(() => motivation = v),
          onConcentrationChanged: (v) => setState(() => concentration = v),
          onCooperationChanged: (v) => setState(() => cooperation = v),
          psychologicalNotes: _psychologicalNotes,
        ),
        ReportPage6General(
          aggressiveness: aggressiveness,
          senseOfResponsibility: senseOfResponsibility,
          strengthOfCharacter: strengthOfCharacter,
          communication: communication,
          personalCleanliness: personalCleanliness,
          attendance: attendance,
          overallRating: overallRating,
          onAggressivenessChanged: (v) => setState(() => aggressiveness = v),
          onSenseOfResponsibilityChanged: (v) =>
              setState(() => senseOfResponsibility = v),
          onStrengthOfCharacterChanged: (v) =>
              setState(() => strengthOfCharacter = v),
          onCommunicationChanged: (v) => setState(() => communication = v),
          onPersonalCleanlinessChanged: (v) =>
              setState(() => personalCleanliness = v),
          onAttendanceChanged: (v) => setState(() => attendance = v),
          onOverallRatingChanged: (v) => setState(() => overallRating = v),
          generalNotes: _generalNotes,
        ),
      ],
    );
  }

  Widget _buildNavBar() {
    final isLast = _currentPage == _pageTitles.length - 1;
    return BlocBuilder<DigitalReportCubit, DigitalReportState>(
      builder: (context, state) {
        final isLoading = state is DigitalReportSubmitting;
        return Container(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 28.h),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: greyClr.withOpacity(0.15))),
          ),
          child: Row(
            children: [
              if (_currentPage > 0) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: isLoading ? null : _prev,
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      side: const BorderSide(color: mainColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    child: Text(
                      'السابق',
                      style: TextStyle(
                        color: mainColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
              ],
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    elevation: 0,
                  ),
                  child: isLoading
                      ? CupertinoActivityIndicator(
                          color: Colors.white,
                          radius: 11.w,
                        )
                      : Text(
                          isLast ? 'حفظ التقرير' : 'التالي',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
