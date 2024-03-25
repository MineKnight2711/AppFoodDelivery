import 'package:app_food_2023/screens/home_screen.dart';
import 'package:app_food_2023/widgets/appbar.dart';
import 'package:app_food_2023/widgets/transitions_animations.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:app_food_2023/api/google_map/google_maps_place_picker.dart';

// ignore: implementation_imports, unused_import
import 'package:app_food_2023/api/google_map/src/google_map_place_picker.dart'; // do not import this yourself

// Your api key storage.

// Only to control hybrid composition and the renderer in Android
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/map/list_location_widget.dart';
import '../widgets/map/map_widgets.dart';

class AddressPage extends StatefulWidget {
  AddressPage({Key? key}) : super(key: key);

  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  PickResult? selectedPlace;
  TextEditingController _testlocation = new TextEditingController();

  late String searchAddress;
  List<String> myLocation = ['', '', ''];
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
    getLocationList();
    // Lấy danh sách địa chỉ từ Local Storage
  }

  Future<void> getLocationList() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      recentAddresses = prefs.getStringList("recentAddresses") ?? [];
    });
  }

  void addRecentAddress(String address) {
    recentAddresses.insert(0, address); // thêm vào đầu danh sách
    if (recentAddresses.length > 10) {
      // giới hạn danh sách chỉ có tối đa 10 địa chỉ gần đây
      recentAddresses.removeLast(); // xóa phần tử cuối danh sách
    }
  }

  // Future<Map<String, dynamic>?> getLocation(String? address) async {
  //   final apiKey =
  //       'AIzaSyBTnEOKQ0rLBrxd87TTtwDZcNOrzRtN-UQ'; // Replace with your Google Maps API key
  //   final apiUrl =
  //       'https://maps.googleapis.com/maps/api/geocode/json?address=${address}&key=$apiKey';

  //   final response = await http.get(Uri.parse(apiUrl));

  //   if (response.statusCode == 200) {
  //     final result = json.decode(response.body);
  //     if (result['status'] == 'OK') {
  //       final location = result['results'][0]['geometry']['location'];
  //       CustomSuccessMessage.showMessage('$location');
  //       return location;
  //     }
  //   }
  //   return Future.value(null);
  // }

  // Future<double?> getLatitudeFromAddress(String address) async {
  //   try {
  //     List<Location> locations = await locationFromAddress(address);
  //     CustomSuccessMessage.showMessage(
  //         locations.first.latitude.toStringAsFixed(2) +
  //             "/" +
  //             locations.first.longitude.toStringAsFixed(2));

  //     if (locations.isNotEmpty) {
  //       return locations.first.latitude;
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Error getting latitude: $e');
  //     return null;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showLeading: true,
        title: "Địa chỉ",
        onPressed: () {
          fadeinTransition(context, AppHomeScreen());
        },
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
                            // await getLatitudeFromAddress(_testlocation.text);
                          },
                        ),
                      ),
                      onChanged: (value) {
                        searchAddress = value;
                      },
                    ),
                  ),
                  PlacePickerIconButton(
                    onPlacePicked: (PickResult result) async {
                      setState(() {
                        selectedPlace = result;

                        // Thêm địa chỉ mới vào đầu danh sách recentAddresses
                        recentAddresses.insert(0, result.formattedAddress!);
                        print(result.formattedAddress!);
                        // Lưu danh sách địa chỉ vào Local Storage
                        SharedPreferences.getInstance().then((prefs) {
                          prefs.setStringList(
                              "recentAddresses", recentAddresses);
                        });
                      });
                      await SharedPreferences.getInstance().then((prefs) async {
                        await prefs
                            .setString(
                                "diachiHienTai", result.formattedAddress!)
                            .then((value) {
                          Navigator.of(context).pop();
                        });
                      });
                    },
                  ),
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
                  HomeLocationDropdown(),
                  SizedBox(height: 8),
                  LocationDropdown(),
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
