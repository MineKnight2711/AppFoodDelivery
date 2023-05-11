import 'package:app_food_2023/appstyle/screensize_aspectratio/mediaquery.dart';
import 'package:app_food_2023/screens/customer/cart_view.dart';
import 'package:app_food_2023/screens/customer/coupons_list.dart';
import 'package:app_food_2023/widgets/transitions_animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:app_food_2023/api/google_map/google_maps_place_picker.dart';

// ignore: implementation_imports, unused_import
import 'package:app_food_2023/api/google_map/src/google_map_place_picker.dart'; // do not import this yourself
import 'dart:io' show Platform;

// Your api key storage.
import 'package:app_food_2023/api/google_map/keys.dart';

// Only to control hybrid composition and the renderer in Android
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home_screen.dart';
import 'payment_method.dart';

class CheckoutScreenView extends StatefulWidget {
  // CheckoutScreenView({Key? key}) : super(key: key);

  final double? amount;

  CheckoutScreenView({Key? key, this.amount}) : super(key: key);

  static final kInitialPosition = LatLng(10.8231, 106.6297);

  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  @override
  State<CheckoutScreenView> createState() => _CheckoutScreenViewState();
}

class _CheckoutScreenViewState extends State<CheckoutScreenView> {
  List dataCheckout = [
    {
      "photo":
          "https://i.ibb.co/dG68KJM/photo-1513104890138-7c749659a591-crop-entropy-cs-tinysrgb-fit-max-fm-jpg-ixid-Mnwy-ODA4-ODh8-MHwxf-H.jpg",
      "product_name": "Frenzy Pizza",
      "price": 25,
      "category": "Food",
      "description":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
    },
    {
      "photo":
          "https://i.ibb.co/mHtmhmP/photo-1521305916504-4a1121188589-crop-entropy-cs-tinysrgb-fit-max-fm-jpg-ixid-Mnwy-ODA4-ODh8-MHwxf-H.jpg",
      "product_name": "Beef Burger",
      "price": 22,
      "category": "Food",
      "description":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
    },
  ];

  List<String> recentAddresses = [];
  PickResult? selectedPlace;
  bool _showPlacePickerInContainer = false;
  bool _showGoogleMapInContainer = false;

  bool _mapsInitialized = false;
  String _mapsRenderer = "latest";

  bool isLoading = false;
  void initRenderer() {
    if (_mapsInitialized) return;
    if (widget.mapsImplementation is GoogleMapsFlutterAndroid) {
      switch (_mapsRenderer) {
        case "legacy":
          (widget.mapsImplementation as GoogleMapsFlutterAndroid)
              .initializeWithRenderer(AndroidMapRenderer.legacy);
          break;
        case "latest":
          (widget.mapsImplementation as GoogleMapsFlutterAndroid)
              .initializeWithRenderer(AndroidMapRenderer.latest);
          break;
      }
    }
    setState(() {
      _mapsInitialized = true;
    });
  }

  Future<String?> _getLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final location = prefs.getString("diachiHienTai");

    return location;
  }

  void addRecentAddress(String address) {
    recentAddresses.insert(0, address); // thêm vào đầu danh sách
    if (recentAddresses.length > 10) {
      // giới hạn danh sách chỉ có tối đa 10 địa chỉ gần đây
      recentAddresses.removeLast(); // xóa phần tử cuối danh sách
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE9F1F5),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "Thanh Toán",
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            slideinTransition(context, CardScreenView(), true);
          },
          icon: const Icon(
            Icons.arrow_back,
            size: 24.0,
            color: Colors.black,
          ),
        ),
        actions: [
          const Icon(
            Icons.message_outlined,
            size: 24.0,
            color: Colors.black,
          ),
          const SizedBox(
            width: 23.0,
          ),
          Stack(
            children: const [
              Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.notifications_outlined,
                  size: 30.0,
                  color: Colors.black,
                ),
              ),
              Positioned(
                top: 8,
                right: 0,
                child: CircleAvatar(
                  radius: 8,
                  backgroundColor: Colors.red,
                  child: Text(
                    "2",
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 23.0,
          ),
          const SizedBox(
            width: 23.0,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 24.0,
              ),
              Container(
                height: 130.99,
                width: 335,
                decoration: const BoxDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Địa chỉ giao",
                        style: GoogleFonts.poppins(
                            fontSize: 13, fontWeight: FontWeight.w700)),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      height: 100.0,
                      width: 335,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 38.0, vertical: 10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            16.0,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 4.0,
                          ),
                          Expanded(
                            child: FutureBuilder(
                              future: _getLocation(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return GestureDetector(
                                    child: Text(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        snapshot.data.toString(),
                                        style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal)),
                                    onTap: () {
                                      print(snapshot.data.toString());
                                    },
                                  );
                                }
                                return GestureDetector();
                              },
                            ),
                          ),
                          InkWell(
                            child: Text(
                              "Thay đổi địa chỉ",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: const Color(0xff01A688),
                              ),
                            ),
                            onTap: () {
                              initRenderer();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return PlacePicker(
                                      resizeToAvoidBottomInset:
                                          false, // only works in page mode, less flickery
                                      apiKey: Platform.isAndroid
                                          ? APIKeys.androidApiKey
                                          : APIKeys.iosApiKey,
                                      hintText: "Find a place ...",
                                      searchingText: "Please wait ...",
                                      selectText: "Select place",
                                      outsideOfPickAreaText:
                                          "Place not in area",
                                      initialPosition:
                                          CheckoutScreenView.kInitialPosition,
                                      useCurrentLocation: true,
                                      selectInitialPosition: true,
                                      usePinPointingSearch: true,
                                      usePlaceDetailSearch: true,
                                      zoomGesturesEnabled: true,
                                      zoomControlsEnabled: true,
                                      onMapCreated:
                                          (GoogleMapController controller) {
                                        print("Map created");
                                      },
                                      onPlacePicked: (PickResult result) {
                                        print("Place picked: ${result.formattedAddress} - " +
                                            "lat: ${result.geometry!.location.lat.toString()} - " +
                                            "lng: ${result.geometry!.location.lng.toString()}");

                                        setState(() {
                                          setState(() {
                                            selectedPlace = result;

                                            // Thêm địa chỉ mới vào đầu danh sách recentAddresses
                                            recentAddresses.insert(
                                                0, result.formattedAddress!);

                                            print(result.formattedAddress!);
                                            // Lưu danh sách địa chỉ vào Local Storage
                                            SharedPreferences.getInstance()
                                                .then((prefs) {
                                              prefs.setStringList(
                                                  "recentAddresses",
                                                  recentAddresses);
                                            });
                                            Navigator.of(context).pop();
                                          });
                                        });
                                      },

                                      onMapTypeChanged: (MapType mapType) {
                                        print(
                                            "Map type changed to ${mapType.toString()}");
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                          if (selectedPlace != null) ...[
                            Text(selectedPlace!.formattedAddress!),

                            // Text(selectedPlace!.formattedAddress! +
                            //     "(lat: " +
                            //     selectedPlace!.geometry!.location.lat
                            //         .toString() +
                            //     ", lng: " +
                            //     selectedPlace!.geometry!.location.lng
                            //         .toString() +
                            //     ")"),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Container(
                height: 209.75,
                width: 335,
                decoration: const BoxDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Sản phẩm",
                        style: GoogleFonts.poppins(
                            fontSize: 13, fontWeight: FontWeight.w700)),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      height: 180.0,
                      width: 335,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            16.0,
                          ),
                        ),
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            dataCheckout.length,
                            (index) {
                              var item = dataCheckout[index];
                              return ListTile(
                                leading: Container(
                                  height: 60.0,
                                  width: 60.0,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        "${item['photo']}",
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(
                                        16.0,
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text("${item['product_name']}",
                                    style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500)),
                                subtitle: Text("\$${item['price']}",
                                    style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: const Color(0xff02A88A),
                                        fontWeight: FontWeight.normal)),
                                trailing: Text("Quantity 1",
                                    style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        color: const Color(0xffBABEBF),
                                        fontWeight: FontWeight.normal)),
                              );
                            },
                          )),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              const SizedBox(
                height: 15.0,
              ),
              SizedBox(
                height: 300,
                width: 335,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Tóm tắt thanh toán",
                        style: GoogleFonts.poppins(
                            fontSize: 13, fontWeight: FontWeight.w700)),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      height: 150,
                      width: 335,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            16.0,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [],
                          ),
                          Row(
                            children: [
                              Text("Mã giảm giá: ",
                                  style: GoogleFonts.poppins(
                                      color: const Color(0xff516971),
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal)),
                              const Spacer(),
                              Text("-${widget.amount}đ",
                                  style: GoogleFonts.poppins(
                                      color: const Color(0xff516971),
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal)),
                            ],
                          ),
                          const Divider(),
                          Row(
                            children: [
                              Text("Tạm tính",
                                  style: GoogleFonts.poppins(
                                      color: const Color(0xff516971),
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal)),
                              const Spacer(),
                              Text("\789.000đ",
                                  style: GoogleFonts.poppins(
                                      color: const Color(0xff516971),
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal)),
                            ],
                          ),
                          const Divider(),
                          Row(
                            children: [
                              Text("814.000đ",
                                  style: GoogleFonts.poppins(
                                      color: const Color(0xff516971),
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal)),
                              const Spacer(),
                              Text("\800.000đ",
                                  style: GoogleFonts.poppins(
                                      color: const Color(0xff516971),
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: MediaHeight(context, 6),
        padding: const EdgeInsets.all(24.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(
              32.0,
            ),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.attach_money_outlined,
                  size: 19,
                  color: const Color(0xff516971),
                ),
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {
                    // Thực hiện hành động khi người dùng nhấn vào chữ "Collect Coupon"
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PaymentScreen()),
                    );
                  },
                  child: Text("Tiền mặt",
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 90, 95, 97),
                      )),
                ),
                SizedBox(
                  width: 40,
                ),
                // Text("^",
                //     style: GoogleFonts.poppins(
                //       fontSize: 14,
                //       fontWeight: FontWeight.bold,
                //       color: Color.fromARGB(255, 123, 133, 136),
                //     )),
                Icon(
                  CupertinoIcons.arrowtriangle_up_circle,
                  size: 18,
                  color: const Color(0xff516971),
                ),
                SizedBox(
                  width: 10.5,
                ),
                Text("|",
                    style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 123, 133, 136),
                    )),
                SizedBox(
                  width: 39,
                ),
                GestureDetector(
                  onTap: () {
                    // Thực hiện hành động khi người dùng nhấn vào chữ "Collect Coupon"
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CouponsListCustomer()),
                    );
                  },
                  child: Text(
                    "THÊM VOUCHER",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff01A688),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 22,
            ),
            Row(
              children: [
                Column(
                  children: [
                    Text("814.000đ",
                        style: GoogleFonts.poppins(
                            decoration: TextDecoration.lineThrough,
                            color: const Color(0xff516971),
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                    Text("\800.000đ",
                        style: GoogleFonts.poppins(
                            color: const Color(0xff02A88A),
                            fontSize: 15,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
                Spacer(),
                SizedBox(
                  width: 250.29,
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffFFB039),
                        // shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.circular(62), // <-- Radius
                        // ),
                      ),
                      onPressed: () async {
                        isLoading = true;
                        print(isLoading);
                        setState(() {});
                        Future.delayed(
                          const Duration(seconds: 3),
                          () async {
                            isLoading = false;
                            setState(() {});
                            print(isLoading);
                            await showDialog<void>(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  actions: <Widget>[
                                    Container(
                                      height: 430.0,
                                      width: 335,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(
                                            16.0,
                                          ),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 108.0,
                                            width: 108,
                                            margin: const EdgeInsets.only(
                                                top: 61.0,
                                                left: 90,
                                                right: 90,
                                                bottom: 45),
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                  16.0,
                                                ),
                                              ),
                                              image: DecorationImage(
                                                image: AssetImage(
                                                  "assets/images/icon-succes-transaction.png",
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Text(
                                              "Đơn hàng của bạn đã đặt thành công",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500)),
                                          const SizedBox(
                                            height: 25.0,
                                          ),
                                          Text(
                                              "Chúng tôi sẽ sớm liên hệ với bạn, và giao cho shipper để có thể gửi hàng ngay đến nơi nhận sớm nhất",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  color:
                                                      const Color(0xff516971),
                                                  fontWeight: FontWeight.w500)),
                                          const SizedBox(
                                            height: 35.0,
                                          ),
                                          SizedBox(
                                            width: 280,
                                            height: 50,
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0xffFFB039),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50), // <-- Radius
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const AppHomeScreen()),
                                                  );
                                                },
                                                child: const Text("oke")),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                      child: (isLoading != false)
                          ? const CircularProgressIndicator()
                          : const Text("Thanh Toán")),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
