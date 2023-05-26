import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../appstyle/screensize_aspectratio/mediaquery.dart';
import '../../controller/customercontrollers/cart.dart';

class CartViewDishImage extends StatelessWidget {
  final String imageUrl;

  const CartViewDishImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: InteractiveViewer(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(imageUrl),
                  ),
                  maxScale: 5.0,
                ),
              ),
            );
          },
        );
      },
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(16.0),
          ),
        ),
      ),
    );
  }
}

class CartViewDishName extends StatelessWidget {
  final String name;

  const CartViewDishName({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: ScreenRotate(context) ? 37 : 50,
        top: ScreenRotate(context) ? 0 : 30,
      ),
      height: MediaQuery.of(context).size.height,
      width: MediaWidth(context, 1.7),
      child: Text(
        name,
        overflow: TextOverflow.fade,
        style: GoogleFonts.nunito(
          fontSize: ScreenRotate(context) ? 14 : 16,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    );
  }
}

class CartItemQuantity extends StatefulWidget {
  final int initialQuantity;
  final double price;
  final String itemId;

  const CartItemQuantity({
    Key? key,
    required this.initialQuantity,
    required this.price,
    required this.itemId,
  }) : super(key: key);

  @override
  _CartItemQuantityState createState() => _CartItemQuantityState();
}

class _CartItemQuantityState extends State<CartItemQuantity> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: ScreenRotate(context) ? 35 : 15,
      left: 120,
      child: SizedBox(
        height: MediaHeight(context, 7),
        width: ScreenRotate(context)
            ? MediaWidth(context, 2)
            : MediaWidth(context, 1),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  formatCurrency(widget.price),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 5, 59, 3),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: ClipOval(
                    child: Material(
                      color: Color.fromARGB(255, 11, 122, 41),
                      child: InkWell(
                        splashColor: Colors.white,
                        onTap: () async {
                          if (widget.initialQuantity <= 1) {
                            // setState(() {
                            //   checkedItems.removeWhere(
                            //       (element) => element.dishID == widget.itemId);
                            //   cartItems!.removeWhere(
                            //     (element) => element.dishID == widget.itemId,
                            //   );
                            // });
                          }
                          setState(() {
                            decreaseQuantity(widget.itemId);
                          });
                        },
                        child: SizedBox(
                          width: 27,
                          height: 27,
                          child: Icon(
                            color: Colors.white,
                            Icons.remove,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 13.5),
                  child: Text(
                    "${widget.initialQuantity}",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
                ClipOval(
                  child: Material(
                    color: Color.fromARGB(255, 11, 122, 41),
                    // Button color
                    child: InkWell(
                      splashColor: Colors.white, // Splash color
                      onTap: () {
                        setState(() {
                          increaseQuantity(widget.itemId);
                        });
                      },
                      child: SizedBox(
                        width: 27,
                        height: 27,
                        child: Icon(
                          color: Colors.white,
                          Icons.add,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CartTotal extends StatefulWidget {
  const CartTotal({Key? key}) : super(key: key);

  @override
  State<CartTotal> createState() => _CartTotalState();
}

class _CartTotalState extends State<CartTotal> {
  double _totalCart = 0;
  StreamSubscription<double>? _cartTotalSubscription;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cartTotalSubscription ??= cartTotalStream().listen((totalCart) {
      setState(() {
        _totalCart = totalCart;
      });
    });
  }

  @override
  void dispose() {
    _cartTotalSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      formatCurrency(_totalCart),
      style: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: const Color(0xff02A88A),
      ),
    );
  }
}
