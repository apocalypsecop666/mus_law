import 'package:mus_law/domain/entities/user_entity.dart';

abstract class IAuthRepository {
  Future<void> register(UserEntity user);
  Future<UserEntity?> login(String email, String password);
  Future<void> logout();
  Future<UserEntity?> getCurrentUser();
}
