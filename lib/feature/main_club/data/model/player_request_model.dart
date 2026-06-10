class PlayerRequestModel {
  final String id;
  final String? phone;
  final String? email;
  final String? accountNumber;
  final String? photoPath;
  final String? name;
  final String? gender;

  const PlayerRequestModel({
    required this.id,
    this.phone,
    this.email,
    this.accountNumber,
    this.photoPath,
    this.name,
    this.gender,
  });

  factory PlayerRequestModel.fromJson(Map<String, dynamic> json) =>
      PlayerRequestModel(
        id: json['id']?.toString() ?? '',
        phone: json['phone']?.toString(),
        email: json['email']?.toString(),
        accountNumber: json['accountNumber']?.toString(),
        photoPath: json['photoPath']?.toString(),
        name: json['name']?.toString(),
        gender: json['gender']?.toString(),
      );
}