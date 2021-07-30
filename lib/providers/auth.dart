import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class Auth with ChangeNotifier {
  String _token = "";
  DateTime _expiry = DateTime.now();
  String _userId = "";

  Future<void> signup(String email, String password) async {
    const path = "identitytoolkit.googleapis.com";
    const apiKey = "AIzaSyBr_qnfLDStUxZUzF-nnSEhonJ8GPnIFWg";
    final url = Uri.https(path, "/v1/accounts:signUp?key=$apiKey");

    final response = await http.post(url, body: json.encode({
      "email": email,
      "password": password,
      "returnSecureToken": true,
    }));
  }
}
