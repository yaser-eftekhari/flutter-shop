import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

import 'dart:convert';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiry;
  String? _userId;

  bool get isAuthenticated {
    return token != null;
  }

  String? get token {
    if (_expiry != null) {
      if (_token != null && _expiry!.isAfter(DateTime.now())) {
        return _token;
      }
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String segment) async {
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:$segment?key=AIzaSyBr_qnfLDStUxZUzF-nnSEhonJ8GPnIFWg");

    try {
      final response = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true,
          }));

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData["idToken"];
      _userId = responseData["localId"];
      _expiry = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData["expiresIn"]),
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> signin(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }
}
