import 'package:flutter/material.dart';
import 'package:mus_law/core/utils/connectivity_utils.dart';
import 'package:mus_law/data/repositories/auth_repository.dart';
import 'package:mus_law/data/sources/secure_storage.dart';
import 'package:mus_law/domain/entities/user_entity.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository;
  UserEntity? _currentUser;
  bool _isLoading = false;
  bool _isAutoLogin = false;

  UserEntity? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAutoLogin => _isAutoLogin;
  bool get isLoggedIn => _currentUser != null;

  AuthProvider(this._authRepository);

  Future<bool> autoLogin() async {
    if (_isLoading) return false;
    
    _isAutoLogin = true;
    _isLoading = true;
    notifyListeners();

    try {
      // Check if we have stored credentials
      final credentials = await SecureStorage.getUserCredentials();
      final email = credentials['email'];
      final password = credentials['password'];

      if (email != null && password != null) {
        final user = await _authRepository.login(email, password);
        if (user != null) {
          _currentUser = user;
          _isLoading = false;
          _isAutoLogin = false;
          notifyListeners();
          return true;
        }
      }
    } catch (e) {
      // Empty case
    }

    _isLoading = false;
    _isAutoLogin = false;
    notifyListeners();
    return false;
  }

  Future<bool> login(String email, String password) async {
    if (_isLoading) return false;

    _isLoading = true;
    notifyListeners();

    try {
      // Check internet connection
      final hasInternet = await ConnectivityUtils.hasInternetConnection();
      if (!hasInternet) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final user = await _authRepository.login(email, password);
      if (user != null) {
        _currentUser = user;
        // Save credentials for auto-login
        await SecureStorage.saveUserCredentials(email, password);
        await SecureStorage.saveSessionToken(DateTime.now().toIso8601String());
        
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      // Empty case
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> register(String name, String email, String password) async {
    if (_isLoading) return false;

    _isLoading = true;
    notifyListeners();

    try {
      final hasInternet = await ConnectivityUtils.hasInternetConnection();
      if (!hasInternet) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final newUser = UserEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        password: password,
      );

      await _authRepository.register(newUser);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout({bool confirm = true}) async {
    if (confirm) {
      // Show confirmation dialog in UI
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _authRepository.logout();
      await SecureStorage.deleteSessionToken();
      await SecureStorage.deleteUserCredentials();
      
      _currentUser = null;
    } catch (e) {
      // Empty case
    }

    _isLoading = false;
    notifyListeners();
  }

  void confirmLogout() {
    logout(confirm: false);
  }
}
