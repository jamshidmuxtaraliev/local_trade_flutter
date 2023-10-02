import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../screens/models/basket_model.dart';
import '../screens/models/product_model.dart';
import '../utils/constants.dart';
import '../utils/pref_utils.dart';

class Providers extends ChangeNotifier {
  Providers();

  Box<ProductModel> box = Hive.box<ProductModel>('products_table');
  var index = 0;
  var message_count = 0;

  List<ProductModel> cartItems = [];
  List<ProductModel> favProductItems = [];

  @override
  void notifyListeners() {
    super.notifyListeners();
  }

  void setIndex(int count) {
    index = count;
    notifyListeners();
  }

  int getIndex() {
    return index;
  }

  void setBadgeCount(int count) {
    message_count = count;
    notifyListeners();
  }

  int getBadgeCount() {
    return message_count;
  }

  void addToCart(String id, double count, double price, double totalPrice) {
    PrefUtils.addToCart(BasketModel(id, count, price, totalPrice));

    notifyListeners();
  }

  List<ProductModel> getCartItems() {
    cartItems = [];
    if (Constants.updateCart.isNotEmpty) {
      for (var element in Constants.updateCart) {
        PrefUtils.getCartList().forEach((item) {
          if (element.tovarId == item.id) {
            element.cartCount = item.count;
            element.cartPrice = item.price;
            element.cartTotalPrice = item.totalPrice;
            cartItems.add(element);
          }
        });
      }
    } else {
      if (PrefUtils.getCartList().isNotEmpty) {
        for (var element in box.values) {
          PrefUtils.getCartList().forEach((item) {
            if (element.tovarId == item.id) {
              element.cartCount = item.count;
              element.cartPrice = item.price;
              element.cartTotalPrice = item.totalPrice;
              cartItems.add(element);
            }
          });
        }
      } else {
        return [];
      }
    }
    return cartItems;
  }

  double getTotalSum() {
    var totalSum = 0.0;
    for (var it in PrefUtils.getCartList()) {
      totalSum += it.count * it.price;
    }
    return totalSum;
  }

  double getTotalCashback() {
    var totalCash = 0.0;
    for (var it in PrefUtils.getCartList()) {
      totalCash += it.totalPrice;
    }
    return totalCash;
  }

  List<ProductModel> getFav() {
    favProductItems = [];
    for (var element in box.values) {
      if (PrefUtils.getFavoriteList().contains(element.tovarId)) {
        favProductItems.add(element);
        element.favorite = true;
      }
    }
    return favProductItems;
  }

  void setFav(item) {
    PrefUtils.setFavoriteProduct(item);
    int indexx = box.values.toList().indexOf(item);
    box.putAt(indexx, item);
    notifyListeners();
  }

// void setOrderList(List<OrderModel> items) {
//   Constants.orderList = [];
//   Constants.orderList = items;
//   notifyListeners();
// }
//
// List<OrderModel> getOrderList() {
//   return Constants.orderList;
// }

// void setUpdateCart(items){
//   Constants.updateCart = [];
//   Constants.updateCart = items;
//   notifyListeners();
// }
}
