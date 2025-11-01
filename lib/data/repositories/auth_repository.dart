import 'package:mus_law/data/models/user_model.dart';
import 'package:mus_law/data/sources/auth_local_storage.dart';
import 'package:mus_law/domain/entities/user_entity.dart';
import 'package:mus_law/domain/repositories/i_auth_repository.dart';

class AuthRepository implements IAuthRepository {
  final AuthLocalStorage _storage;

  AuthRepository(this._storage);

  @override
  Future<void> register(UserEntity user) async {
    final userModel = UserModel.fromEntity(user);
    await _storage.save('users_box', user.email, userModel.toJson());
  }

  @override
  Future<UserEntity?> login(String email, String password) async {
    final userData = _storage.get('users_box', email);
    
    if (userData != null && 
        userData['password'] != null && 
        userData['password'] == password) {
      
      final user = UserModel(
        id: userData['id'].toString(),
        name: userData['name'].toString(),
        email: userData['email'].toString(),
        password: userData['password'].toString(),
      );
      
      await _storage.save('current_user_box', 'current_user', user.toJson());
      return user;
    }
    return null;
  }

  @override
  Future<void> logout() async {
    await _storage.delete('current_user_box', 'current_user');
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final userData = _storage.get('current_user_box', 'current_user');
    
    if (userData != null) {
      return UserModel(
        id: userData['id'].toString(),
        name: userData['name'].toString(),
        email: userData['email'].toString(),
        password: userData['password'].toString(),
      );
    }
    return null;
  }
}
