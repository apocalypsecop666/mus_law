import 'package:mus_law/data/models/user_model.dart';
import 'package:mus_law/data/sources/auth_local_storage.dart';
import 'package:mus_law/domain/entities/user_entity.dart';
import 'package:mus_law/domain/repositories/i_user_repository.dart';

class UserRepository implements IUserRepository {
  final AuthLocalStorage _storage;

  UserRepository(this._storage);

  @override
  Future<void> updateUser(UserEntity user) async {
    final userModel = UserModel.fromEntity(user);
    await _storage.save('users_box', user.email, userModel.toJson());

    final currentUser = _storage.get('current_user_box', 'current_user');
    if (currentUser != null && currentUser['email'] == user.email) {
      await _storage.save(
          'current_user_box', 'current_user', userModel.toJson(),);
    }
  }

  @override
  Future<void> deleteUser(String email) async {
    await _storage.delete('users_box', email);
    final currentUser = _storage.get('current_user_box', 'current_user');
    if (currentUser != null && currentUser['email'] == email) {
      await _storage.delete('current_user_box', 'current_user');
    }
  }

  @override
  Future<UserEntity?> getUser(String email) async {
    final userData = _storage.get('users_box', email);
    if (userData is Map<String, dynamic>) {
      return UserModel(
          id: userData['id'] as String,
          name: userData['name'] as String,
          email: userData['email'] as String,
          password: userData['password'] as String,);
    }
    return null;
  }
}
