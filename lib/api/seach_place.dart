import 'package:app_food_2023/controller/customercontrollers/check_out.dart';
import 'package:app_food_2023/widgets/appbar.dart';

import 'package:flutter/material.dart';

import 'package:app_food_2023/api/google_map/google_maps_place_picker.dart';
import 'package:get/get.dart';

// Only to control hybrid composition and the renderer in Android
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/map/my_location_widget.dart';
import '../widgets/map/map_widgets.dart';
import '../widgets/message.dart';

class AddressPage extends StatefulWidget {
  AddressPage({Key? key}) : super(key: key);

  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  PickResult? selectedPlace;
  TextEditingController _testlocation = new TextEditingController();
  final controller = Get.find<CheckOutController>();

  late String searchAddress;
  List<String> myLocation = ['', '', ''];
  List<String> recentAddresses = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showLeading: true,
        title: "Địa chỉ",
        onPressed: () {
          Navigator.pop(context);
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
                  Builder(builder: (context) {
                    return PlacePickerIconButton(
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
                        await SharedPreferences.getInstance()
                            .then((prefs) async {
                          await prefs
                              .setString(
                                  "diachiHienTai", result.formattedAddress!)
                              .then((value) {
                            Navigator.of(context).pop();
                          });
                        });
                      },
                    );
                  }),
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
                        onTap: () async {
                          print(recentAddresses[index]);
                          await SharedPreferences.getInstance().then((prefs) {
                            prefs.setString(
                                "diachiHienTai", recentAddresses[index]);
                          });
                          await controller.getLocation();
                          CustomSnackBar.showCustomSnackBar(
                              context, 'Đã chọn ${recentAddresses[index]}', 2);
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
}
