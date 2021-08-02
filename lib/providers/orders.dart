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
  final String? authToken;
  List<OrderItem> _orders = [];

  Orders(this.authToken, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    const path = "flutter-sample-store-default-rtdb.firebaseio.com";
    final url = Uri.https(path, "/orders.json?auth=$authToken");
    try {
      final List<OrderItem> loadedOrders = [];
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if(extractedData == null) return;
      extractedData.forEach((orderID, orderData) {
        loadedOrders.add(
          OrderItem(
            id: orderID,
            amount: orderData["amount"],
            dateTime: DateTime.parse(orderData["dateTime"]),
            products: (orderData["products"] as List<dynamic>)
                .map(
                  (item) => CartItem(
                      title: item["title"],
                      id: item["id"],
                      price: item["price"],
                      quantity: item["quantity"]),
                )
                .toList(),
          ),
        );
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const path = "flutter-sample-store-default-rtdb.firebaseio.com";
    final url = Uri.https(path, "/orders.json?auth=$authToken");

    final timeStamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        "amount": total,
        "dateTime": timeStamp.toIso8601String(),
        "products": cartProducts
            .map((item) => {
                  "id": item.id,
                  "price": item.price,
                  "title": item.title,
                  "quantity": item.quantity,
                })
            .toList(),
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
