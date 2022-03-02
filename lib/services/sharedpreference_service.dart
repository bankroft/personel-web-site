import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  SharedPreferences? _prefs;
  bool _initialized = false;
  static final SharedPreferenceService _singleton = SharedPreferenceService._();

  factory SharedPreferenceService() {
    return _singleton;
  }

  SharedPreferenceService._();

  Future<void> init() async {
    if (!_initialized) {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
    }
  }

  Future<bool> setBool(String key, bool value) async {
    await init();
    return _prefs!.setBool(key, value);
  }

  Future<bool?> getBool(String key) async {
    await init();
    return _prefs!.getBool(key);
  }

  Future<bool> setString(String key, String value) async {
    await init();
    return _prefs!.setString(key, value);
  }

  Future<String?> getString(String key) async {
    await init();
    return _prefs!.getString(key);
  }

  Future<bool> setInt(String key, int value) async {
    await init();
    return _prefs!.setInt(key, value);
  }

  Future<int?> getInt(String key) async {
    await init();
    return _prefs!.getInt(key);
  }

  Future<SharedPreferences> get prefs async {
    await init();
    return _prefs!;
  }

  Future<void> deleteByKey(String key) async {
    _prefs!.remove(key);
  }
}
