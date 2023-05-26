import 'dart:async';

import 'package:app_food_2023/appstyle/succes_messages/success_style.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../appstyle/error_messages/error_style.dart';
import '../../model/cart_model.dart';

import '../../model/dishes_model.dart';
import '../../screens/home_screen.dart';
import '../../widgets/popups.dart';

List<CartItem>? cartItems = [];
Timer? timer;
int totalQuantity = 0;
bool? isChecked = false, showRemoveAll = false;

double totalCart = 0.0;

User? user;
_getCurrentUser() async {
  await FirebaseAuth.instance.authStateChanges().listen((User? currentUser) {
    user = currentUser;
  });
}

String formatCurrency(double? value) {
  final currentcy = new NumberFormat('#,##0', 'ID');
  String result =
      currentcy.format(double.parse((value ?? 0.0).toStringAsFixed(0))) + " đ";
  return result;
}

Set<CartItem> checkedItems = {};

Future<bool> compareCart() async {
  print(checkedItems.length);

  final querySnapshot = await FirebaseFirestore.instance
      .collection('cart')
      .where('UserID', isEqualTo: user?.uid)
      .get();
  if (querySnapshot.docs.length == checkedItems.length &&
      querySnapshot.docs.isNotEmpty &&
      checkedItems.isNotEmpty) {
    return true;
  } else {
    return false;
  }
}

Future<bool> getCurrentCheckedItems() async {
  if (checkedItems.length > 0)
    return true;
  else
    return false;
}

Stream<QuerySnapshot<Map<String, dynamic>>> cartListStream() async* {
  await _getCurrentUser();
  yield* FirebaseFirestore.instance
      .collection('cart')
      .where('UserID', isEqualTo: user?.uid)
      .snapshots();
}

int checkSl(BuildContext context, int sl) {
  if (sl < 1 || sl > 100) {
    QuantityRange(context);
    if (sl < 1) return 1;
    if (sl > 100) return 100;
  }
  return sl;
}

void addToCart(BuildContext context, DishModel dish, int quantity) async {
  await _getCurrentUser();

  if (user == null) {
    cannotAddToCart();
    return;
  } else {
    final refCart = await FirebaseFirestore.instance.collection('cart');
    await refCart
        .where('DishID', isEqualTo: dish.id)
        .where('UserID', isEqualTo: user?.uid)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot doc = querySnapshot.docs.first;
        int currentQuantity = doc.get('Quantity');
        int newQuantity = currentQuantity + quantity;
        double price = dish.Price!;
        double newTotal = price * newQuantity;

        doc.reference.update({
          'Quantity': newQuantity,
          'Total': newTotal,
        });
      } else {
        refCart.add({
          'DishID': dish.id,
          'UserID': user?.uid,
          'Quantity': quantity,
          'Total': dish.Price! * quantity,
        });
      }
    });
    addToCartSucceededPopup(context);
  }
}

StreamController<double>? _cartTotalController;
Stream<double> cartTotalStream() {
  _cartTotalController ??= StreamController<double>();
  return _cartTotalController!.stream;
}

void updateCartTotalStream() {
  if (_cartTotalController != null && !_cartTotalController!.isClosed) {
    double totalCart = checkedItems.fold(
        0, (previousValue, item) => previousValue + item.total);
    _cartTotalController!.add(totalCart);
  }
}

void resetCartTotalStream() {
  _cartTotalController?.close();
  checkedItems.clear();
  isChecked = false;
  _cartTotalController = null;
}

void increaseQuantity(String? dishID) async {
  final refCart = await FirebaseFirestore.instance
      .collection('cart')
      .where('UserID', isEqualTo: user?.uid)
      .where('DishID', isEqualTo: dishID);
  final querySnapshot = await refCart.get();
  if (querySnapshot.docs.isNotEmpty) {
    final cartItemSnapshot = querySnapshot.docs.first;
    int oldQuantity = cartItemSnapshot.get('Quantity');
    double total = cartItemSnapshot.get('Total');
    int newQuantity = oldQuantity + 1;
    double dishPrice = total / oldQuantity;
    double newTotal = dishPrice * newQuantity;
    if (checkedItems.where((element) => element.dishID == dishID).isNotEmpty) {
      CartItem cartItemToUpdate =
          checkedItems.firstWhere((item) => item.dishID == dishID);
      checkedItems.remove(cartItemToUpdate);
      cartItemToUpdate.quantity = newQuantity;
      cartItemToUpdate.total = newTotal;
      checkedItems.add(cartItemToUpdate);
      updateCartTotalStream();
    }

    await cartItemSnapshot.reference.update({
      "Total": newTotal,
      "Quantity": newQuantity,
    });
    updateCartTotalStream();
  }
}

decreaseQuantity(String? dishID) async {
  final refCart = await FirebaseFirestore.instance
      .collection('cart')
      .where('UserID', isEqualTo: user?.uid)
      .where('DishID', isEqualTo: dishID);
  final querySnapshot = await refCart.get();
  if (querySnapshot.docs.isNotEmpty) {
    final cartItemSnapshot = querySnapshot.docs.first;
    int oldQuantity = cartItemSnapshot.get('Quantity');
    double total = cartItemSnapshot.get('Total');

    int newQuantity = oldQuantity - 1;
    double dishPrice = total / oldQuantity;
    double newTotal = dishPrice * newQuantity;

    if (oldQuantity <= 1) {
      await cartItemSnapshot.reference.delete();
      checkedItems.removeWhere((element) => element.dishID == dishID);
      cartItems!.removeWhere((element) => element.dishID == dishID);

      await compareCart();
      await getCurrentCheckedItems();
      updateCartTotalStream();
      removeFromCartSucceed();
    } else {
      await cartItemSnapshot.reference.update({
        "Total": newTotal,
        "Quantity": newQuantity,
      });
      if (checkedItems
          .where((element) => element.dishID == dishID)
          .isNotEmpty) {
        CartItem cartItemToUpdate =
            checkedItems.firstWhere((item) => item.dishID == dishID);
        checkedItems.remove(cartItemToUpdate);
        cartItemToUpdate.quantity = newQuantity;
        cartItemToUpdate.total = newTotal;
        checkedItems.add(cartItemToUpdate);
      }

      updateCartTotalStream();
    }
  }
}

bool checkQuantity(bool check) {
  if (check == true)
    return true;
  else
    return false;
}

removeFromCart(String dishID) async {
  final refCart = await FirebaseFirestore.instance.collection('cart');
  final cartItemSnapshot = await refCart
      .where('DishID', isEqualTo: dishID)
      .where('UserID', isEqualTo: user?.uid)
      .get();
  checkedItems.removeWhere((element) => element.dishID == dishID);
  if (cartItemSnapshot.docs.isNotEmpty) {
    final docSnapshot = cartItemSnapshot.docs.first;
    await docSnapshot.reference.delete();
    await compareCart();
    await getCurrentCheckedItems();
    updateCartTotalStream();
    removeFromCartSucceed();
  }
}

void toggleChecked(CartItem item) {
  if (checkedItems
      .where((element) => element.dishID == item.dishID)
      .isNotEmpty) {
    checkedItems.removeWhere((element) => element.dishID == item.dishID);
  } else {
    checkedItems.add(item);
  }
  updateCartTotalStream();
  print(checkedItems.length);
}

void checkedAll() {
  if (isChecked == true) {
    //chọn thì foreach add to Set
    if (cartItems != null) {
      if (checkedItems.isEmpty) {
        //Trường hợp không có sản phẩm được chọn
        for (var item in cartItems!) {
          checkedItems.add(item);
        }
      } else {
        //Trường hợp đã có sản phẩm được chọn
        checkedItems.clear();
        for (var item in cartItems!) {
          checkedItems.add(item);
        }
      }
    }
  } else {
    //Bỏ chọn thì clear Set
    checkedItems.clear();
  }
  updateCartTotalStream();
}

void clearCart(BuildContext context) async {
  final refCart = FirebaseFirestore.instance.collection('cart');
  final cartSnapshot =
      await refCart.where('UserID', isEqualTo: user?.uid).get();

  for (final doc in cartSnapshot.docs) {
    await doc.reference.delete();
  }

  removeSucceed();
  checkedItems.clear();
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => AppHomeScreen()),
  );
  updateCartTotalStream();
}

void removeChosenItems() async {
  List<String?> checkedDishIDs =
      checkedItems.map((item) => item.dishID).toList();
  final refCart = FirebaseFirestore.instance.collection('cart');
  final cartSnapshot = await refCart
      .where('UserID', isEqualTo: user?.uid)
      .where('DishID', whereIn: checkedDishIDs)
      .get();

  for (final doc in cartSnapshot.docs) {
    await doc.reference.delete().then((value) {
      removeSucceed();
    });
  }
  updateCartTotalStream();
  await compareCart();
}
