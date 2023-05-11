import 'package:app_food_2023/screens/home_screen.dart';
import 'package:app_food_2023/widgets/message.dart';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:app_food_2023/api/google_map/google_maps_place_picker.dart';

// ignore: implementation_imports, unused_import
import 'package:app_food_2023/api/google_map/src/google_map_place_picker.dart'; // do not import this yourself

// Your api key storage.

// Only to control hybrid composition and the renderer in Android
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/map/map_widgets.dart';

class Address {
  String address;
  double latitude;
  double longitude;
  DateTime dateTime;

  Address(this.address, this.latitude, this.longitude, this.dateTime);
}

class RecentAddresses {
  List<Address> _addresses = [];

  void addAddress(Address address) {
    _addresses.add(address);
  }

  List<Address> get addresses {
    // Sắp xếp các địa chỉ theo thời gian gần nhất đến xa nhất
    _addresses.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return _addresses;
  }
}

class AddressPage extends StatefulWidget {
  AddressPage({Key? key}) : super(key: key);

  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  PickResult? selectedPlace;
  // bool _showPlacePickerInContainer = false;
  // bool _showGoogleMapInContainer = false;
  TextEditingController _testlocation = new TextEditingController();
  bool _mapsInitialized = false;
  String _mapsRenderer = "latest";

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

  late GoogleMapController mapController;
  late String searchAddress;

  List<String> recentAddresses = [""];
  List<String> myAddresses = [
    'Nhà',
    'Công Ty',
    'Thêm địa chỉ...',
  ];

  List<IconData> myAddressIcons = [
    Icons.home_outlined,
    Icons.work_outline,
    Icons.add_outlined,
  ];

  @override
  void initState() {
    super.initState();

    // Lấy danh sách địa chỉ từ Local Storage
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        recentAddresses = prefs.getStringList("recentAddresses") ?? [];
      });
    });
  }

  void addRecentAddress(String address) {
    recentAddresses.insert(0, address); // thêm vào đầu danh sách
    if (recentAddresses.length > 10) {
      // giới hạn danh sách chỉ có tối đa 10 địa chỉ gần đây
      recentAddresses.removeLast(); // xóa phần tử cuối danh sách
    }
  }

  Future<Map<String, dynamic>?> getLocation(String? address) async {
    final apiKey =
        'AIzaSyBTnEOKQ0rLBrxd87TTtwDZcNOrzRtN-UQ'; // Replace with your Google Maps API key
    final apiUrl =
        'https://maps.googleapis.com/maps/api/geocode/json?address=${address}&key=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        final location = result['results'][0]['geometry']['location'];
        CustomSuccessMessage.showMessage('$location');
        return location;
      }
    }
    return Future.value(null);
  }

  Future<double?> getLatitudeFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      CustomSuccessMessage.showMessage(
          locations.first.latitude.toStringAsFixed(2) +
              "/" +
              locations.first.longitude.toStringAsFixed(2));

      if (locations.isNotEmpty) {
        return locations.first.latitude;
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting latitude: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Nhập địa chỉ',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AppHomeScreen()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _testlocation,
                      decoration: InputDecoration(
                        hintText: 'Nhập địa điểm hiện tại của bạn',
                        prefixIcon: IconButton(
                          icon: Icon(Icons.search_outlined),
                          onPressed: () async {
                            // await getLocation(_testlocation.text);
                            await getLatitudeFromAddress(_testlocation.text);
                          },
                        ),
                      ),
                      onChanged: (value) {
                        searchAddress = value;
                      },
                    ),
                  ),
                  // IconButton(
                  //   icon: Icon(Icons.map_outlined),
                  //   onPressed: () async {
                  //     initRenderer();
                  //     final status = await Geolocator.requestPermission();
                  //     if (status == LocationPermission.denied) {
                  //       CustomErrorMessage.showMessage(
                  //           "Bạn phải bật vị trí để chọn vị trí giao hàng!");
                  //       await Geolocator.requestPermission();
                  //       return;
                  //     } else if (status == LocationPermission.whileInUse ||
                  //         status == LocationPermission.always) {
                  //       CustomSuccessMessage.showMessage(
                  //           'Đã bật vị trí, đang lấy vị trí hiện tại của bạn..');
                  //       final position = await Geolocator.getCurrentPosition(
                  //         desiredAccuracy: LocationAccuracy.high,
                  //         timeLimit: Duration(seconds: 10),
                  //       );
                  //       final currentPosition =
                  //           LatLng(position.latitude, position.longitude);
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) {
                  //             return PlacePicker(
                  //               resizeToAvoidBottomInset:
                  //                   false, // only works in page mode, less flickery
                  //               apiKey: Platform.isAndroid
                  //                   ? APIKeys.androidApiKey
                  //                   : APIKeys.iosApiKey,
                  //               hintText: "Tìm vị trí ...",
                  //               searchingText: "Vui lòng chờ ...",
                  //               selectText: "Chọn địa điểm",
                  //               outsideOfPickAreaText:
                  //                   "Khu vực chưa hỗ trợ giao hàng",
                  //               initialPosition: currentPosition,
                  //               useCurrentLocation: true,
                  //               selectInitialPosition: true,
                  //               usePinPointingSearch: true,
                  //               usePlaceDetailSearch: true,
                  //               zoomGesturesEnabled: true,
                  //               zoomControlsEnabled: true,
                  //               onMapCreated: (GoogleMapController controller) {
                  //                 print("Map created");
                  //               },
                  //               onPlacePicked: (PickResult result) async {
                  //                 print(
                  //                     "Place picked: ${result.formattedAddress}");
                  //                 setState(() {
                  //                   setState(() {
                  //                     selectedPlace = result;

                  //                     // Thêm địa chỉ mới vào đầu danh sách recentAddresses
                  //                     recentAddresses.insert(
                  //                         0, result.formattedAddress!);
                  //                     print(result.formattedAddress!);
                  //                     // Lưu danh sách địa chỉ vào Local Storage
                  //                     SharedPreferences.getInstance()
                  //                         .then((prefs) {
                  //                       prefs.setStringList(
                  //                           "recentAddresses", recentAddresses);
                  //                     });
                  //                   });
                  //                 });
                  //                 await SharedPreferences.getInstance()
                  //                     .then((prefs) async {
                  //                   await prefs
                  //                       .setString("diachiHienTai",
                  //                           result.formattedAddress!)
                  //                       .then((value) {
                  //                     slideinTransition(
                  //                         context, AppHomeScreen(), false);
                  //                   });
                  //                 });
                  //               },

                  //               onMapTypeChanged: (MapType mapType) {
                  //                 print(
                  //                     "Map type changed to ${mapType.toString()}");
                  //               },
                  //             );
                  //           },
                  //         ),
                  //       );
                  //     } else if (status == LocationPermission.deniedForever) {
                  //       CustomErrorMessage.showMessage(
                  //           'Bạn đã tắt quyền truy cập vị trí của ứng dụng vui lòng bật lại trong cài đặt!');
                  //       await Geolocator.openLocationSettings();

                  //       return;
                  //     }
                  //   },
                  // ),
                  PlacePickerIconButton(),
                ],
              ),
            ),
            Container(),
            if (selectedPlace != null) ...[
              // Text(selectedPlace!.formattedAddress!),
              // Text("(lat: " +
              //     selectedPlace!.geometry!.location.lat.toString() +
              //     ", lng: " +
              //     selectedPlace!.geometry!.location.lng.toString() +
              //     ")"),
            ],
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Text(
                    'Địa điểm của tôi',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: myAddresses.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(myAddressIcons[index]),
                        title: Row(
                          children: [
                            Text(myAddresses[index]),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios, size: 16),
                          ],
                        ),
                        onTap: () {},
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          'Địa điểm gần đây',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Text(
                        'Xoá',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 134, 134, 134)),
                        textAlign: TextAlign.left,
                      ),
                      IconButton(
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.remove('recentAddresses');
                          prefs.remove('diachiHienTai');
                          setState(() {
                            recentAddresses = [];
                          });
                        },
                        icon: Icon(
                          Icons.delete_outline,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: recentAddresses.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          print(recentAddresses[index]);
                          SharedPreferences.getInstance().then((prefs) {
                            prefs.setString(
                                "diachiHienTai", recentAddresses[index]);
                          });
                        },
                        leading: Icon(Icons.history),
                        title: Row(
                          children: [
                            Flexible(
                              child: Text(recentAddresses[index]),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Color.fromARGB(255, 28, 120, 31),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void searchAddressOnMap() {
  //
  // }
}
