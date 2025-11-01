class UserEntity {
  final String id;
  final String name;
  final String email;
  final String password;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          email == other.email;

  @override
  int get hashCode => email.hashCode;
}
