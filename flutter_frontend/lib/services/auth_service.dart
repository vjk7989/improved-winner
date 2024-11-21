import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService extends ChangeNotifier {
  final String baseUrl = 'https://asdw-5bf5m9e9a-vikiis-projects.vercel.app/api';
  String? _token;
  bool get isAuthenticated => _token != null;

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
    );
  }

  Future<void> signup(String email, String password, String name, String mobile) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'name': name,
          'mobileNumber': mobile,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        await _saveToken();
        showToast('Account created successfully!');
        notifyListeners();
      } else {
        throw _handleError(response);
      }
    } catch (e) {
      showToast(e.toString());
      throw e;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        await _saveToken();
        showToast('Login successful!');
        notifyListeners();
      } else {
        throw _handleError(response);
      }
    } catch (e) {
      showToast(e.toString());
      throw e;
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/forget-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        showToast('Password reset instructions sent to your email');
      } else {
        throw _handleError(response);
      }
    } catch (e) {
      showToast(e.toString());
      throw e;
    }
  }

  Future<void> logout() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    showToast('Logged out successfully');
    notifyListeners();
  }

  Future<Map<String, dynamic>> getProfile() async {
    try {
      if (_token == null) throw 'Not authenticated';

      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw _handleError(response);
      }
    } catch (e) {
      showToast(e.toString());
      throw e;
    }
  }

  Future<void> updateProfile(String name, String mobile) async {
    try {
      if (_token == null) throw 'Not authenticated';

      final response = await http.put(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'mobileNumber': mobile,
        }),
      );

      if (response.statusCode == 200) {
        showToast('Profile updated successfully');
      } else {
        throw _handleError(response);
      }
    } catch (e) {
      showToast(e.toString());
      throw e;
    }
  }

  String _handleError(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      return data['error'] ?? 'An error occurred';
    } catch (_) {
      return 'An error occurred';
    }
  }

  Future<void> _saveToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', _token!);
  }

  Future<void> checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    notifyListeners();
  }
}