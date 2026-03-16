// ── GET /api/Club/PlayerDigitalReports ───────────────────────────────────────
class DigitalReportSummary {
  final int id;
  final String date;
  final String name;

  const DigitalReportSummary({
    required this.id,
    required this.date,
    required this.name,
  });

  factory DigitalReportSummary.fromJson(Map<String, dynamic> json) =>
      DigitalReportSummary(
        id: (json['id'] as num?)?.toInt() ?? 0,
        date: json['date']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
      );
}

// ── POST /api/Club/AddDigitalReport ──────────────────────────────────────────
class CreateDigitalReportRequest {
  // معلومات اللاعب
  final String playerId;
  final String playerName;
  final double height;
  final double weight;
  final int playerAge;
  final String month;
  final String season;

  // 1. البدنية
  final int speed;
  final int strength;
  final int agility;
  final int endurance;
  final String physicalComments;

  // 2. مهاريا / خططيا
  final int attacking;
  final String attackingComments;
  final int shooting;
  final String shootingComments;
  final int runningBall;
  final String runningBallComments;
  final int passing;
  final String passingComments;
  final int movementWithoutBall1;
  final String movementWithoutBall1Comments;
  final int ballAbsorption;
  final String ballAbsorptionComments;
  final int ballControl;
  final String ballControlComments;
  final int ballReception;
  final String ballReceptionComments;
  final int vision;
  final String visionComments;
  final int throwIn;
  final String throwInComments;
  final int goalkeeping;
  final String goalkeepingComments;
  final int finishing;
  final String finishingComments;
  final int dribbling;
  final String dribblingComments;
  final int quickThinking;
  final String quickThinkingComments;
  final int creativity;
  final String creativityComments;
  final int oneOnOneDefense;
  final String oneOnOneDefenseComments;
  final int oneOnOneOffense;
  final String oneOnOneOffenseComments;
  final int chestControl;
  final String chestControlComments;
  final int positionAwareness;
  final String positionAwarenessComments;
  final int heading;
  final String headingComments;
  final int defensivePositioning;
  final String defensivePositioningComments;

  // 3. نفسيا
  final int calm;
  final int commitment;
  final int leadership;
  final int motivation;
  final int concentration;
  final int cooperation;
  final String psychologicalComments;

  // 4. عام
  final int aggressiveness;
  final int senseOfResponsibility;
  final int strengthOfCharacter;
  final int communication;
  final int personalCleanliness;
  final int attendance;
  final int overallRating;
  final String generalComments;

  const CreateDigitalReportRequest({
    required this.playerId,
    required this.playerName,
    required this.height,
    required this.weight,
    required this.playerAge,
    required this.month,
    required this.season,
    required this.speed,
    required this.strength,
    required this.agility,
    required this.endurance,
    this.physicalComments = '',
    required this.attacking,
    this.attackingComments = '',
    required this.shooting,
    this.shootingComments = '',
    required this.runningBall,
    this.runningBallComments = '',
    required this.passing,
    this.passingComments = '',
    required this.movementWithoutBall1,
    this.movementWithoutBall1Comments = '',
    required this.ballAbsorption,
    this.ballAbsorptionComments = '',
    required this.ballControl,
    this.ballControlComments = '',
    required this.ballReception,
    this.ballReceptionComments = '',
    required this.vision,
    this.visionComments = '',
    required this.throwIn,
    this.throwInComments = '',
    required this.goalkeeping,
    this.goalkeepingComments = '',
    required this.finishing,
    this.finishingComments = '',
    required this.dribbling,
    this.dribblingComments = '',
    required this.quickThinking,
    this.quickThinkingComments = '',
    required this.creativity,
    this.creativityComments = '',
    required this.oneOnOneDefense,
    this.oneOnOneDefenseComments = '',
    required this.oneOnOneOffense,
    this.oneOnOneOffenseComments = '',
    required this.chestControl,
    this.chestControlComments = '',
    required this.positionAwareness,
    this.positionAwarenessComments = '',
    required this.heading,
    this.headingComments = '',
    required this.defensivePositioning,
    this.defensivePositioningComments = '',
    required this.calm,
    required this.commitment,
    required this.leadership,
    required this.motivation,
    required this.concentration,
    required this.cooperation,
    this.psychologicalComments = '',
    required this.aggressiveness,
    required this.senseOfResponsibility,
    required this.strengthOfCharacter,
    required this.communication,
    required this.personalCleanliness,
    required this.attendance,
    required this.overallRating,
    this.generalComments = '',
  });

  Map<String, dynamic> toJson() => {
    'playerId': playerId,
    'playerName': playerName,
    'height': height,
    'weight': weight,
    'playerAge': playerAge,
    'month': month,
    'season': season,
    'speed': speed,
    'strength': strength,
    'agility': agility,
    'endurance': endurance,
    'physicalComments': physicalComments,
    'attacking': attacking,
    'attackingComments': attackingComments,
    'shooting': shooting,
    'shootingComments': shootingComments,
    'runningBall': runningBall,
    'runningBallComments': runningBallComments,
    'passing': passing,
    'passingComments': passingComments,
    'movementWithoutBall1': movementWithoutBall1,
    'movementWithoutBall1Comments': movementWithoutBall1Comments,
    'ballAbsorption': ballAbsorption,
    'ballAbsorptionComments': ballAbsorptionComments,
    'ballControl': ballControl,
    'ballControlComments': ballControlComments,
    'ballReception': ballReception,
    'ballReceptionComments': ballReceptionComments,
    'vision': vision,
    'visionComments': visionComments,
    'throwIn': throwIn,
    'throwInComments': throwInComments,
    'goalkeeping': goalkeeping,
    'goalkeepingComments': goalkeepingComments,
    'finishing': finishing,
    'finishingComments': finishingComments,
    'dribbling': dribbling,
    'dribblingComments': dribblingComments,
    'quickThinking': quickThinking,
    'quickThinkingComments': quickThinkingComments,
    'creativity': creativity,
    'creativityComments': creativityComments,
    'oneOnOneDefense': oneOnOneDefense,
    'oneOnOneDefenseComments': oneOnOneDefenseComments,
    'oneOnOneOffense': oneOnOneOffense,
    'oneOnOneOffenseComments': oneOnOneOffenseComments,
    'chestControl': chestControl,
    'chestControlComments': chestControlComments,
    'positionAwareness': positionAwareness,
    'positionAwarenessComments': positionAwarenessComments,
    'heading': heading,
    'headingComments': headingComments,
    'defensivePositioning': defensivePositioning,
    'defensivePositioningComments': defensivePositioningComments,
    'calm': calm,
    'commitment': commitment,
    'leadership': leadership,
    'motivation': motivation,
    'concentration': concentration,
    'cooperation': cooperation,
    'psychologicalComments': psychologicalComments,
    'aggressiveness': aggressiveness,
    'senseOfResponsibility': senseOfResponsibility,
    'strengthOfCharacter': strengthOfCharacter,
    'communication': communication,
    'personalCleanliness': personalCleanliness,
    'attendance': attendance,
    'overallRating': overallRating,
    'generalComments': generalComments,
  };
}
