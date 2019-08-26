import 'package:shared_preferences/shared_preferences.dart';

setPrefString(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

setPrefInt(String key, int value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt(key, value);
}

setPrefDouble(String key, double value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setDouble(key, value);
}

setPrefStringList(String key, List<String> value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList(key, value);
}

setPrefBool(String key, bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool(key, value);
}

getPrefString(String key, {String defaultValue = ''}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key) ?? defaultValue;
}

getPrefInt(String key, {int defaultValue = 0}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt(key) ?? defaultValue;
}

getPrefDouble(String key, {double defaultValue = 0}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getDouble(key) ?? defaultValue;
}

getPrefStringList(String key, {List<String> defaultValue = const []}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList(key) ?? defaultValue;
}

getPrefBool(String key, {bool defaultValue = false}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool(key) ?? defaultValue;
}

removePref(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove(key);
}

prefContains(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.get(key) != null;
}
