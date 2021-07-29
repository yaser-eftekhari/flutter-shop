import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String imageUrl;
  final String description;
  final String title;
  final double price;
  bool isFavorite;

  Product({
    required this.imageUrl,
    required this.description,
    required this.title,
    required this.price,
    required this.id,
    this.isFavorite = false,
  });

  void _rollback(bool variable, bool oldStatus) {
    variable = oldStatus;
    notifyListeners();
  }

  Future<void> toggleFavoriteState() async {
    const path = "flutter-sample-store-default-rtdb.firebaseio.com";
    final url = Uri.https(path, "/products/$id.json");

    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final response = await http.patch(
        url,
        body: json.encode({
          'isFavorite': isFavorite,
        }),
      );
      if(response.statusCode >= 400) {
        _rollback(isFavorite, oldStatus);
      }
    } catch (error) {
      _rollback(isFavorite, oldStatus);
    }
  }
}
