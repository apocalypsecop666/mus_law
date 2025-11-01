abstract class LocalStorage {
  Future<void> init();
  Future<void> save(String boxName, String key, Map<String, dynamic> value);
  Map<String, dynamic>? get(String boxName, String key);
  Future<void> delete(String boxName, String key);
  bool containsKey(String boxName, String key);
}
