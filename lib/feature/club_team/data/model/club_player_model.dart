class ClubPlayer {
  final String id;
  final String accountNumber;
  final String? photoPath;
  final String name;
  final int age;
  final String gender;
  final String position;
  final int direction;
  final String foot;
  final double tps;

  const ClubPlayer({
    required this.id,
    required this.accountNumber,
    this.photoPath,
    required this.name,
    required this.age,
    required this.gender,
    required this.position,
    required this.direction,
    required this.foot,
    required this.tps,
  });

  factory ClubPlayer.fromJson(Map<String, dynamic> json) => ClubPlayer(
        id: json['id']?.toString() ?? '',
        accountNumber: json['accountNumber']?.toString() ?? '',
        photoPath: json['photoPath']?.toString(),
        name: json['name']?.toString() ??
            ('${json['firstName'] ?? ''} ${json['lastName'] ?? ''}'.trim()),
        age: (json['age'] as num?)?.toInt() ?? 0,
        gender: json['gender']?.toString() ?? '',
        position: json['position']?.toString() ??
            json['positionName']?.toString() ??
            '',
        direction: (json['direction'] as num?)?.toInt() ?? 0,
        foot: json['foot']?.toString() ?? '',
        tps: (json['tps'] as num?)?.toDouble() ?? 0.0,
      );

  // Backward-compatible getters for existing code that used old field names
  String get fullName => name;
  String? get photo => photoPath;
  String? get positionName => position;
}
