import 'package:hive_flutter/hive_flutter.dart';
import 'package:mus_law/data/sources/local_storage.dart';

class AuthLocalStorage implements LocalStorage {
  bool _isInitialized = false;

  @override
  Future<void> init() async {
    if (_isInitialized) return;

    await Hive.initFlutter();
    await Hive.openBox<dynamic>('users_box');
    await Hive.openBox<dynamic>('current_user_box');
    _isInitialized = true;
  }

  @override
  Future<void> save(
    String boxName,
    String key,
    Map<String, dynamic> value,
  ) async {
    await _ensureInitialized();
    final box = Hive.box<dynamic>(boxName);
    await box.put(key, value);
  }

  @override
  Map<String, dynamic>? get(String boxName, String key) {
    if (!_isInitialized) return null;
    final box = Hive.box<dynamic>(boxName);
    final dynamic value = box.get(key);

    if (value is Map) {
      return value.cast<String, dynamic>();
    }
    return null;
  }

  @override
  Future<void> delete(String boxName, String key) async {
    await _ensureInitialized();
    final box = Hive.box<dynamic>(boxName);
    await box.delete(key);
  }

  @override
  bool containsKey(String boxName, String key) {
    if (!_isInitialized) return false;
    final box = Hive.box<dynamic>(boxName);
    return box.containsKey(key);
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await init();
    }
  }
}
