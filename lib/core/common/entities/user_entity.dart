class UserEntity {
  final String id;
  final String? email;
  final String name;
  final String avatarUrl;
  final String phoneNumber;
  final DateTime updatedAt;

  UserEntity({
    required this.id,
    this.email,
    required this.name,
    required this.avatarUrl,
    required this.phoneNumber,
    required this.updatedAt,
  });
}
