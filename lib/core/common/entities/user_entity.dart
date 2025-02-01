class UserEntity {
  final String id;
  final String email;
  final String name;
  final String? avatarUrl;

  UserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
  });
}
