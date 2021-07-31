import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

import 'dart:convert';

class Auth with ChangeNotifier {
  String _token = "";
  DateTime _expiry = DateTime.now();
  String _userId = "";

  Future<void> _authenticate(String email, String password, String segment) async {
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
      if(responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
    } catch(error) {
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
