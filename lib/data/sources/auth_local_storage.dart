import 'package:hive_flutter/hive_flutter.dart';
import 'package:mus_law/data/sources/local_storage.dart';

class AuthLocalStorage implements LocalStorage {
  @override
  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<Map<String, dynamic>>('users_box');
    await Hive.openBox<Map<String, dynamic>>('current_users_box');
  }

  @override
  Future<void> save(
    String boxName,
    String key,
    Map<String, dynamic> value,
  ) async {
    final box = Hive.box<Map<String, dynamic>>(boxName);
    await box.put(key, value);
  }

  @override
  Map<String, dynamic>? get(String boxName, String key) {
    final box = Hive.box<Map<String, dynamic>>(boxName);
    return box.get(key);
  }

  @override
  Future<void> delete(String boxName, String key) async {
    final box = Hive.box<Map<String, dynamic>>(boxName);
    await box.delete(key);
  }

  @override
  bool containsKey(String boxName, String key) {
    final box = Hive.box<Map<String, dynamic>>(boxName);
    return box.containsKey(key);
  }
}
