import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

import 'core/models/account.dart';
import 'core/models/user.dart';

class AppSession extends ChangeNotifier {
  AppSession({required SharedPreferences preferences}) : _preferences = preferences;

  static const String _loggedInKey = 'logged_in';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';

  final SharedPreferences _preferences;
  User? _currentUser;
  Account? _selectedAccount;
  bool _isLoggedIn = false;

  User? get currentUser => _currentUser;
  Account? get selectedAccount => _selectedAccount;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> initialize() async {
    _isLoggedIn = _preferences.getBool(_loggedInKey) ?? false;
    final email = _preferences.getString(_userEmailKey);
    final name = _preferences.getString(_userNameKey);

    if (_isLoggedIn && email != null && name != null) {
      _currentUser = User(id: 'cached', name: name, email: email);
    }
    notifyListeners();
  }

  Future<void> login(User user) async {
    _currentUser = user;
    _isLoggedIn = true;
    await _preferences.setBool(_loggedInKey, true);
    await _preferences.setString(_userEmailKey, user.email);
    await _preferences.setString(_userNameKey, user.name);
    notifyListeners();
  }

  Future<void> setSelectedAccount(Account account) async {
    _selectedAccount = account;
    notifyListeners();
  }

  Future<void> logout() async {
    _currentUser = null;
    _selectedAccount = null;
    _isLoggedIn = false;
    await _preferences.remove(_loggedInKey);
    await _preferences.remove(_userEmailKey);
    await _preferences.remove(_userNameKey);
    notifyListeners();
  }
}
