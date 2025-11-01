import 'package:mus_law/domain/entities/user_entity.dart';

abstract class IUserRepository {
  Future<void> updateUser(UserEntity user);
  Future<void> deleteUser(String email);
  Future<UserEntity?> getUser(String email);
}
