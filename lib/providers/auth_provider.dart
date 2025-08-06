import 'package:flutter/foundation.dart';
import 'package:onmitrix/models/login_response.dart';
import 'package:onmitrix/services/api/api_service.dart';
import 'package:onmitrix/utils/session_manager.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  LoginResponse? _user;

  bool get isLoading => _isLoading;
  String? get error => _error;
  LoginResponse? get user => _user;
  bool get isLoggedIn => _user != null;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      final response = LoginResponse(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        name: email.split('@')[0],
        token: 'dummy_token_${DateTime.now().millisecondsSinceEpoch}',
      );
      
      _user = response;
      await SessionManager().setUser(response);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signup(String email, String password, String name) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      final response = LoginResponse(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        name: name,
        token: 'dummy_token_${DateTime.now().millisecondsSinceEpoch}',
      );
      
      _user = response;
      await SessionManager().setUser(response);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await SessionManager().clearSession();
      _user = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkAuthStatus() async {
    _user = await SessionManager().getUser();
    notifyListeners();
  }
}