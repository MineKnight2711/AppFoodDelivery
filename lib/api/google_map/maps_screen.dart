import 'package:flutter/material.dart';
import 'package:app_food_2023/api/google_map/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: implementation_imports, unused_import
import 'package:app_food_2023/api/google_map/src/google_map_place_picker.dart'; // do not import this yourself
import 'dart:io' show Platform;

// Your api key storage.
import 'keys.dart';

// Only to control hybrid composition and the renderer in Android
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

class MyApp extends StatelessWidget {
  // Light Theme
  final ThemeData lightTheme = ThemeData.light().copyWith(
    // Background color of the FloatingCard
    cardColor: Colors.white,
  );

  // Dark Theme
  final ThemeData darkTheme = ThemeData.dark().copyWith(
    // Background color of the FloatingCard
    cardColor: Colors.grey,
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Map Place Picker Demo',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      home: MapScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MapScreen extends StatefulWidget {
  MapScreen({Key? key}) : super(key: key);

  static final kInitialPosition = LatLng(10.8231, 106.6297);

  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  PickResult? selectedPlace;
  bool _showPlacePickerInContainer = false;
  // bool _showGoogleMapInContainer = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          !_showPlacePickerInContainer
              ? ElevatedButton(
                  child: Text("Load Place Picker"),
                  onPressed: () {
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
                            outsideOfPickAreaText: "Place not in area",
                            initialPosition: MapScreen.kInitialPosition,
                            useCurrentLocation: true,
                            selectInitialPosition: true,
                            usePinPointingSearch: true,
                            usePlaceDetailSearch: true,
                            zoomGesturesEnabled: true,
                            zoomControlsEnabled: true,
                            onMapCreated: (GoogleMapController controller) {
                              print("Map created");
                            },
                            onPlacePicked: (PickResult result) {
                              print("Place picked: ${result.formattedAddress}");
                              setState(() {
                                selectedPlace = result;
                                Navigator.of(context).pop();
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
                )
              : Container(),
          if (selectedPlace != null) ...[
            Text(selectedPlace!.formattedAddress!),
            Text("(lat: " +
                selectedPlace!.geometry!.location.lat.toString() +
                ", lng: " +
                selectedPlace!.geometry!.location.lng.toString() +
                ")"),
          ],
          // #region Google Map Example without provider
        ],
      ),
    ));
  }
}

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Distance Calculator',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: DistanceScreen(),
//     );
//   }
// }

// class DistanceScreen extends StatefulWidget {
//   @override
//   _DistanceScreenState createState() => _DistanceScreenState();
// }

// class _DistanceScreenState extends State<DistanceScreen> {
//   String origin = "10.7757,106.7004";
//   String destination = "10.8428,106.8287";
//   String? distance;
//   String? duration;

//   Future<void> getDistance() async {
//     final apiKey = 'AIzaSyCBcxn9oeKVCcYSHauc5QZN7_AInvZs0yQ';
//     final url = Uri.parse(
//         'https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=$origin&destinations=$destination&key=$apiKey&language=vi&region=VN&query');
//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       final rows = data['rows'] as List<dynamic>;
//       final elements = rows.first['elements'] as List<dynamic>;
//       final distanceElement =
//           elements.first['distance'] as Map<String, dynamic>;
//       final durationElement =
//           elements.first['duration'] as Map<String, dynamic>;

//       setState(() {
//         distance = distanceElement['text'];
//         duration = durationElement['text'];
//       });
//     } else {
//       setState(() {
//         distance = null;
//         duration = null;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Distance Calculator'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             const Text(
//               'Enter origin and destination below:',
//               style: TextStyle(fontSize: 18),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               decoration: InputDecoration(
//                 hintText: 'Origin (lat,lng)',
//                 border: OutlineInputBorder(),
//               ),
//               onChanged: (value) {
//                 origin = value;
//               },
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               decoration: InputDecoration(
//                 hintText: 'Destination (lat,lng)',
//                 border: OutlineInputBorder(),
//               ),
//               onChanged: (value) {
//                 destination = value;
//               },
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: getDistance,
//               child: const Text('Get Distance'),
//             ),
//             const SizedBox(height: 16),
//             if (distance != null && duration != null)
//               Column(
//                 children: [
//                   Text('Distance: $distance'),
//                   Text('Duration: $duration'),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
