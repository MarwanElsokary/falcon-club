class PlayerReport {
  final String id;
  final String captainName;
  final String? captainPhoto;
  final DateTime date;

  const PlayerReport({
    required this.id,
    required this.captainName,
    this.captainPhoto,
    required this.date,
  });

  factory PlayerReport.fromJson(Map<String, dynamic> json) => PlayerReport(
    id: json['id']?.toString() ?? '',
    captainName: json['captainName']?.toString() ??
        ('${json['firstName'] ?? ''} ${json['lastName'] ?? ''}'.trim()),
    captainPhoto: json['captainPhoto']?.toString() ??
        json['photoPath']?.toString(),
    date: json['date'] != null
        ? DateTime.tryParse(json['date'].toString()) ?? DateTime.now()
        : DateTime.now(),
  );
}