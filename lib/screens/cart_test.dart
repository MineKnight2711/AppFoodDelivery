import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String Image;
  final double Price;

  Product({required this.id, required this.Image, required this.Price});

  factory Product.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Product(
      id: snapshot.id,
      Image: data['Image'],
      Price: data['Price'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Image': Image,
      'Price': Price,
    };
  }
}

class CartItemTest {
  final Product product;
  int quantity;

  CartItemTest({required this.product, this.quantity = 1});
}

class CartTest extends StatefulWidget {
  @override
  _CartTestState createState() => _CartTestState();
}

class _CartTestState extends State<CartTest> {
  List<Product> products = [];
  List<CartItemTest> cart = [];

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  void loadProducts() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('dishes').get();
    List<Product> loadedProducts =
        snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
    setState(() {
      products = loadedProducts;
    });
  }

  void addToCart(Product product, int quantity) {
    bool itemFound = false;
    for (CartItemTest item in cart) {
      if (item.product == product) {
        item.quantity += quantity;
        itemFound = true;
        break;
      }
    }
    if (!itemFound) {
      cart.add(CartItemTest(product: product, quantity: quantity));
    }
  }

  void removeFromCart(CartItemTest item) {
    setState(() {
      cart.remove(item);
    });
  }

  void clearCart() {
    setState(() {
      cart.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('My App'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    Product product = products[index];
                    return ListTile(
                      leading: Image.network(product.Image),
                      title: Text(product.id),
                      subtitle: Text('\$${product.Price}'),
                      trailing: ElevatedButton(
                        onPressed: () {
                          addToCart(product, 1);
                        },
                        child: Text('Add to cart'),
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CartScreen(
                            cart: cart,
                            removeFromCart: removeFromCart,
                            clearCart: clearCart)),
                  );
                },
                child: Text('View cart (${cart.length})'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  final List<CartItemTest> cart;
  final Function removeFromCart;
  final Function clearCart;

  CartScreen(
      {required this.cart,
      required this.removeFromCart,
      required this.clearCart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: ListView.builder(
        itemCount: cart.length,
        itemBuilder: (context, index) {
          CartItemTest item = cart[index];
          return ListTile(
            leading: Image.network(item.product.Image),
            title: Text(item.product.id),
            subtitle: Text('Quantity: ${item.quantity}'),
            trailing: IconButton(
              icon: Icon(Icons.remove_shopping_cart),
              onPressed: () {
                removeFromCart(item);
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              clearCart();
              Navigator.pop(context);
            },
            child: Text('Clear cart'),
          ),
        ),
      ),
    );
  }
}
