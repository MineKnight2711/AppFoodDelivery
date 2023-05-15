import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import '../../api/google_map/keys.dart';
import '../../api/google_map/src/models/pick_result.dart';
import '../../api/google_map/src/place_picker.dart';
import '../message.dart';

class PlacePickerIconButton extends StatefulWidget {
  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  final void Function(PickResult) onPlacePicked;

  PlacePickerIconButton({required this.onPlacePicked});
  @override
  _PlacePickerIconButtonState createState() => _PlacePickerIconButtonState();
}

class _PlacePickerIconButtonState extends State<PlacePickerIconButton> {
  PickResult? selectedPlace;
  List<String> recentAddresses = [];
  bool _mapsInitialized = false;
  String _mapsRenderer = "latest";
  String? mapId = '';
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initRenderer() {
    if (_mapsInitialized) {
      print('Bản đồ đã được khởi tạo');
      return;
    }
    if (widget.mapsImplementation is GoogleMapsFlutterAndroid) {
      switch (_mapsRenderer) {
        case "legacy":
          (widget.mapsImplementation as GoogleMapsFlutterAndroid)
              .initializeWithRenderer(AndroidMapRenderer.legacy);
          break;
        case "latest":
          try {
            (widget.mapsImplementation as GoogleMapsFlutterAndroid)
                .initializeWithRenderer(AndroidMapRenderer.latest);
          } on PlatformException catch (e) {
            if (e.code == "rendererAlreadyInitialized") {
              print("Google Maps renderer already initialized");
            }
          }
          break;
      }
    }
    setState(() {
      _mapsInitialized = true;
    });
  }

  Future<void> _onPressed() async {
    final status = await Geolocator.requestPermission();
    if (status == LocationPermission.denied) {
      CustomErrorMessage.showMessage(
          "Bạn phải bật vị trí để chọn vị trí giao hàng!");
      await Geolocator.requestPermission();
      return;
    } else if (status == LocationPermission.whileInUse ||
        status == LocationPermission.always) {
      CustomSuccessMessage.showMessage(
          'Đã bật vị trí, đang lấy vị trí hiện tại của bạn..');
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      );
      final currentPosition = LatLng(position.latitude, position.longitude);
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
              hintText: "Tìm vị trí ...",
              searchingText: "Vui lòng chờ ...",
              selectText: "Chọn địa điểm",
              outsideOfPickAreaText: "Khu vực chưa hỗ trợ giao hàng",
              initialPosition: currentPosition,
              useCurrentLocation: true,
              selectInitialPosition: true,
              usePinPointingSearch: true,
              usePlaceDetailSearch: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              onMapCreated: (controller) async {
                try {
                  await widget.mapsImplementation.init(controller.mapId);
                } on PlatformException catch (e) {
                  if (e.code == "rendererAlreadyInitialized") {
                    setState(() {
                      widget.mapsImplementation
                          .dispose(mapId: controller.mapId);
                    });
                    print("Google Maps renderer already initialized");
                  }
                }
              },
              onPlacePicked: widget.onPlacePicked,

              onMapTypeChanged: (MapType mapType) {
                print("Map type changed to ${mapType.toString()}");
              },
            );
          },
        ),
      );
    } else if (status == LocationPermission.deniedForever) {
      CustomErrorMessage.showMessage(
          'Bạn đã tắt quyền truy cập vị trí của ứng dụng vui lòng bật lại trong cài đặt!');
      await Geolocator.openLocationSettings();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.map_outlined,
        color: Colors.green,
      ),
      onPressed: _onPressed,
    );
  }
}
