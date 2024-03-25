import 'package:app_food_2023/model/UserModel.dart';
import 'package:app_food_2023/screens/customer/change_password_customer.dart';
import 'package:app_food_2023/screens/customer/customer_profile.dart';
import 'package:app_food_2023/screens/home_screen.dart';

import 'package:app_food_2023/widgets/transitions_animations.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/logout.dart';

class SettingProfileScreen extends StatefulWidget {
  const SettingProfileScreen({super.key});

  @override
  State<SettingProfileScreen> createState() => _SettingProfileScreenState();
}

class _SettingProfileScreenState extends State<SettingProfileScreen> {
  String? email = "";
  User? user = FirebaseAuth.instance.currentUser;
  UserModel? loggedInUser;

  Future getEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      email = preferences.getString('email');
    });
  }

  @override
  void initState() {
    super.initState();

    getEmail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: new Row(
          children: <Widget>[
            new Text('Tài khoản của tôi',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    fontFamily: 'sans-serif-light',
                    color: Colors.black)),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            slideinTransition(context, AppHomeScreen());
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30.0,
            ),
            Center(
              child: Text(
                showCurrentUser(),
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            ListTile(
              title: Text("Cập nhật thông tin"),
              leading: Icon(Icons.settings),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
            ),
            ListTile(
              title: Text("Đổi mật khẩu"),
              leading: Icon(Icons.lock),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangePasswordCustomerScreen()));
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Icon(Icons.shopping_bag),
                      Text('Đơn hàng'),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Icon(Icons.favorite),
                      Text('Quán yêu thích'),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Icon(Icons.location_on),
                      Text('Sổ địa chỉ'),
                    ],
                  ),
                ),
              ],
            ),
            Divider(),
            ListTile(
              title: Text('Ví coupon'),
              leading: Icon(Icons.credit_card),
              onTap: () {
                // Xử lý đi Đạt
              },
            ),
            Divider(),
            ListTile(
              title: Text('Quản lý thanh toán'),
              leading: Icon(Icons.payment),
              onTap: () {
                // Xử lý đi Đạt
              },
            ),
            Divider(),
            ListTile(
              title: Text('Đánh giá'),
              leading: Icon(Icons.star),
              onTap: () {
                // Xử lý đi Đạt
              },
            ),
            Divider(),
            ListTile(
              title: Text('Thông báo'),
              leading: Icon(Icons.notifications),
              onTap: () {
                // Xử lý đi Đạt
              },
            ),
            Divider(),
            ListTile(
              title: Text('Hỗ trợ'),
              leading: Icon(Icons.help),
              onTap: () {
                // Xử lý đi Đạt
              },
            ),
            Divider(),
            ListTile(
              title: Text('Điều khoản và chính sách'),
              leading: Icon(Icons.policy),
              onTap: () {
                // Xử lý đi Đạt
              },
            ),
            Divider(),
            ListTile(
              title: Text('Phiên bản hiện tại'),
              leading: Icon(Icons.info),
              onTap: () {
                // Xử lý đi Đạt
              },
            ),
            Divider(),
            ListTile(
              title: showLogout(),
              leading: Icon(Icons.logout),
              onTap: () {
                logOut(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  showCurrentUser() {
    if (user != null) {
      return email.toString();
    } else {
      return "Đăng nhập";
    }
  }

  showLogout() {
    if (user != null) {
      return Text('Đăng xuất');
    }
  }
}
