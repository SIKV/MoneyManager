import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

final preferencesProvider = Provider<Preferences>((_) => Preferences());

const _keyTheme = 'theme';

class Preferences {
  late final SharedPreferences _prefs;

  AppThemeType? _theme;
  AppThemeType? get theme =>_theme;

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();

    final themeId = _prefs.getInt(_keyTheme);
    if (themeId != null) {
      _theme = AppThemeType.values
          .firstWhere((element) => element.id == themeId);
    }
  }

  void setTheme(AppThemeType? theme) {
    if (theme != null) {
      _prefs.setInt(_keyTheme, theme.id);
    } else {
      _prefs.remove(_keyTheme);
    }
    _theme = theme;
  }
}

