import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import 'cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.dateTime,
    required this.id,
    required this.products,
    required this.amount,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const path = "flutter-sample-store-default-rtdb.firebaseio.com";
    final url = Uri.https(path, "/orders.json");

    final timeStamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        "amount": total,
        "dateTime": timeStamp.toIso8601String(),
        "products": cartProducts.map((item) => {
          "id": item.id,
          "price": item.price,
          "title": item.title,
          "quantity": item.quantity,
        }).toList(),
      }),
    );
    _orders.insert(
      0,
      OrderItem(
        dateTime: timeStamp,
        id: json.decode(response.body)['name'],
        products: cartProducts,
        amount: total,
      ),
    );
    notifyListeners();
  }
}
