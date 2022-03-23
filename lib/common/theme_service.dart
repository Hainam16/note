import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class ThemeServices {
  static final GetStorage _box = GetStorage();
  static const _key = 'isDarkMode';

  static _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  static bool get _loadThemeFromBox => _box.read<bool>(_key) ?? false;

  ThemeMode get theme => _loadThemeFromBox ? ThemeMode.dark : ThemeMode.light;

  static switchTheme() {
    Get.changeThemeMode(_loadThemeFromBox ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFromBox);
  }
}
