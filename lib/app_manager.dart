import 'package:githao/notifier/theme_notifier.dart';
import 'package:githao/util/prefs_manager.dart';

class AppManager {
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;
  static final AppManager _appManager = AppManager._internal();
  factory AppManager() {
    return _appManager;
  }
  AppManager._internal() {
    prefsManager.init();
  }
  Future<void> init() async {
    if(!_isInitialized) {
      await prefsManager.init();
    }
    _isInitialized = true;
  }
}

AppManager appManager = AppManager();
