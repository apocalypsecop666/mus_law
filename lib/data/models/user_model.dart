import 'package:hive/hive.dart';
import 'package:mus_law/domain/entities/user_entity.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends UserEntity {
  @override
  @HiveField(0)
  String get id => super.id;

  @override
  @HiveField(1)
  String get name => super.name;

  @override
  @HiveField(2)
  String get email => super.email;

  @override
  @HiveField(3)
  String get password => super.password;

  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.password,
  });

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      password: entity.password,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
      };
}
