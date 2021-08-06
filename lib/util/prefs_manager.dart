import 'dart:convert';

import 'package:githao_v2/network/entity/user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'string_extension.dart';

class PrefsManager {
  static const keyUsernames = 'usernames';
  static const keyToken = 'token';
  static const keyUser = 'user_entity';
  /// 请求限制次数
  static const keyRateLimit = 'x-ratelimit-limit';
  /// 请求限制使用次数
  static const keyRateLimitUsed = 'x-ratelimit-used';
  /// 请求次数的重置时间
  static const keyRateLimitReset = 'x-ratelimit-reset';

  late SharedPreferences _prefs;
  bool initialized = false;
  SharedPreferences get prefs => _prefs;
  static final PrefsManager _prefsManager = PrefsManager._internal();
  factory PrefsManager() => _prefsManager;
  PrefsManager._internal();

  Future<void> init() async {
    if(initialized == false) {
      _prefs = await SharedPreferences.getInstance();
      initialized = true;
    }
  }

  String? getToken({String? userName}) {
    if(userName.isNullOrEmpty()) {
      return _prefs.getString(keyToken);
    } else {
      return _prefs.getString('$userName-$keyToken');
    }
  }

  Future<bool> setToken(String token, {String? userName}) {
    if(userName.isNullOrEmpty()) {
      return _prefs.setString(keyToken, token);
    } else {
      return _prefs.setString('$userName-$keyToken', token);
    }
  }

  List<String> getUsernames() => prefs.getStringList(keyUsernames) ?? [];
  Future<bool> _setUsernames(List<String> usernames) => _prefs.setStringList(keyUsernames, usernames);
  Future<bool> addUsername(String userName) {
    final List<String> usernames = getUsernames();
    if(!usernames.contains(userName)) {
      usernames.add(userName);
      return _setUsernames(usernames);
    }
    return Future.value(true);
  }
  Future<bool> removeUsername(String userName) {
    final List<String> usernames = getUsernames();
    usernames.remove(userName);
    return _setUsernames(usernames);
  }

  UserEntity? getUser() {
    String? value = _prefs.getString(keyUser);
    if(value!.isNotEmpty) {
      dynamic entity = jsonDecode(value);
      UserEntity userEntity = UserEntity.fromJson(entity);
      return userEntity;
    } else {
      return null;
    }
  }
  Future<bool> setUser(UserEntity userEntity) {
    return _prefs.setString(keyUser, jsonEncode(userEntity));
  }

  int? getRateLimit() => _prefs.getInt(keyRateLimit);
  Future<bool> setRateLimit(int limit) => _prefs.setInt(keyRateLimit, limit);

  int? getRateLimitUsed() => _prefs.getInt(keyRateLimitUsed);
  Future<bool> setRateLimitUsed(int used) => _prefs.setInt(keyRateLimitUsed, used);

  int? getRateLimitReset() => _prefs.getInt(keyRateLimitReset);
  Future<bool> setRateLimitReset(int reset) => _prefs.setInt(keyRateLimitReset, reset);

}

PrefsManager prefsManager = PrefsManager();