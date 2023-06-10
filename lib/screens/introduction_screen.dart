import 'package:app_food_2023/controller/customercontrollers/check_out.dart';
import 'package:app_food_2023/screens/home_screen.dart';
import 'package:app_food_2023/screens/loading_screen/home_loading.dart';
import 'package:app_food_2023/widgets/custom_widgets/transitions_animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:introduction_screen/introduction_screen.dart';

List<PageViewModel> pages = [
  PageViewModel(
    title: "Xin chào",
    body: "Cám ơn đã sử dụng ứng dụng của chúng tôi!",
    decoration: const PageDecoration(
      pageColor: Colors.blue,
    ),
  ),
  PageViewModel(
    title: "Features",
    body: "Our app has many cool features.",
    decoration: const PageDecoration(
      pageColor: Colors.green,
    ),
  ),
  PageViewModel(
    title: "Bắt đầu thôi",
    body: "Nhấn nút bên dưới để trải nghiệm ngay nào!.",
    decoration: const PageDecoration(
      pageColor: Colors.orange,
    ),
  ),
];
Future<bool> isFirstTime() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
  if (isFirstTime) {
    await prefs.setBool('isFirstTime', false);
  }
  Get.put(HomeScreenController());
  Get.put(CheckOutController({}));
  return isFirstTime;
}

class IntroductionScreenFirstTime extends StatefulWidget {
  @override
  State<IntroductionScreenFirstTime> createState() =>
      _IntroductionScreenFirstTimeState();
}

class _IntroductionScreenFirstTimeState
    extends State<IntroductionScreenFirstTime> {
  bool _showIntroductionScreen = false;

  @override
  void initState() {
    super.initState();
    _checkIfFirstTime();
  }

  void _checkIfFirstTime() async {
    bool isFirstTimeLoad = await isFirstTime();
    setState(() {
      _showIntroductionScreen = isFirstTimeLoad;
    });
  }

  void loadHomeScreen() async {
    Get.put(HomeScreenController());
    Get.put(CheckOutController({}));
    slideinTransitionNoBack(
      context,
      AppHomeScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Introduction Screen Example',
      home: _showIntroductionScreen
          ? IntroductionScreen(
              pages: pages,
              onDone: () {
                loadHomeScreen();
              },
              showSkipButton: true,
              skip: const Text("Bỏ qua"),
              done: const Text("Bắt đầu!"),
              showNextButton: false,
            )
          : LoadingHomeScreen(),
    );
  }
}
