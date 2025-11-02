import 'package:mus_law/data/sources/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsStorage implements LocalStorage {
  static SharedPreferences? _prefs;

  @override
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Future<void> save(
    String boxName,
    String key,
    Map<String, dynamic> value,
  ) async {
    await _ensureInitialized();
    final fullKey = '$boxName::$key';
    await _prefs!.setString(fullKey, _encodeMap(value));
  }

  @override
  Map<String, dynamic>? get(String boxName, String key) {
    if (_prefs == null) return null;
    final fullKey = '$boxName::$key';
    final value = _prefs!.getString(fullKey);
    return value != null ? _decodeMap(value) : null;
  }

  @override
  Future<void> delete(String boxName, String key) async {
    await _ensureInitialized();
    final fullKey = '$boxName::$key';
    await _prefs!.remove(fullKey);
  }

  @override
  bool containsKey(String boxName, String key) {
    if (_prefs == null) return false;
    final fullKey = '$boxName::$key';
    return _prefs!.containsKey(fullKey);
  }

  String _encodeMap(Map<String, dynamic> map) {
    final entries = map.entries.map((e) => '${e.key}:${e.value}').toList();
    return entries.join('|');
  }

  Map<String, dynamic> _decodeMap(String encoded) {
    final map = <String, dynamic>{};
    final pairs = encoded.split('|');
    for (final pair in pairs) {
      final parts = pair.split(':');
      if (parts.length >= 2) {
        // Join back if there were colons in the value
        final key = parts[0];
        final value = parts.sublist(1).join(':');
        map[key] = value;
      }
    }
    return map;
  }

  Future<void> _ensureInitialized() async {
    if (_prefs == null) {
      await init();
    }
  }
}
