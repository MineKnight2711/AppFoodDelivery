import 'package:app_food_2023/controller/user.dart';
import 'package:app_food_2023/screens/customer/setting_profile/babstrap_settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../controller/logout.dart';

class CustomerSetting extends StatelessWidget {
  const CustomerSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(.94),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          "Thông Tin Tài Khoản",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            size: 24.0,
            color: Colors.black,
          ),
        ),
        actions: [
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
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            // User card
            BigUserCard(
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              userName: "${loggedInUser?.LastName} ${loggedInUser?.FirstName}",
              email: "${loggedInUser?.Email}",
              userProfilePic: loggedInUser != null
                  ? Image.network(loggedInUser!.Avatar.toString()).image
                  : AssetImage("assets/images/profile.png"),
              cardActionWidget: SettingsItem(
                icons: Icons.edit,
                iconStyle: IconStyle(
                  withBackground: true,
                  borderRadius: 50,
                  backgroundColor: Colors.yellow[600],
                ),
                title: "Cập nhật thông tin",
                subtitle: "Nhấn vào để chỉnh sửa thông tin",
                onTap: () {
                  print("OK");
                },
              ),
            ),
            SettingsGroup(
              items: [
                SettingsItem(
                  onTap: () {},
                  icons: Icons.lock_person_outlined,
                  iconStyle: IconStyle(
                    backgroundColor: Color.fromARGB(255, 215, 34, 34),
                  ),
                  title: 'Đổi mật khẩu',
                  subtitle: "Thay đổi mật khẩu người dùng",
                ),
                SettingsItem(
                  onTap: () {},
                  icons: CupertinoIcons.cart,
                  iconStyle: IconStyle(),
                  title: 'Đơn hàng',
                  subtitle: "Xem chi tiết danh sách các đơn hàng",
                ),
                SettingsItem(
                  onTap: () {},
                  icons: CupertinoIcons.ticket_fill,
                  iconStyle: IconStyle(
                    backgroundColor: Color.fromARGB(255, 76, 176, 39),
                  ),
                  title: 'Voucher',
                  subtitle: "Danh sách mã giảm giá",
                ),
                SettingsItem(
                  onTap: () {},
                  icons: CupertinoIcons.heart_circle_fill,
                  iconStyle: IconStyle(
                    backgroundColor: Color.fromARGB(255, 190, 35, 229),
                  ),
                  title: 'Món yêu thích',
                  subtitle: "Danh sách món ăn yêu thích",
                ),
                SettingsItem(
                  onTap: () {},
                  icons: Icons.dark_mode_rounded,
                  iconStyle: IconStyle(
                    iconsColor: Colors.white,
                    withBackground: true,
                    backgroundColor: Color.fromARGB(255, 48, 48, 48),
                  ),
                  title: 'Dark mode',
                  subtitle: "Automatic",
                  trailing: Switch.adaptive(
                    value: false,
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),

            SettingsGroup(
              settingsGroupTitle: "Riêng tư",
              items: [
                SettingsItem(
                  onTap: () {},
                  icons: Icons.format_list_numbered_sharp,
                  iconStyle: IconStyle(),
                  title: "Chính sách bảo mật",
                  subtitle: "Thông tin chính sách bảo mật",
                ),
                SettingsItem(
                  onTap: () {},
                  icons: Icons.security_outlined,
                  iconStyle: IconStyle(
                    backgroundColor: Color.fromARGB(255, 225, 31, 31),
                  ),
                  title: "Bảo vệ",
                  subtitle: "Thông tin bảo vệ người dùng",
                ),
                SettingsItem(
                  onTap: () {},
                  icons: Icons.line_style_outlined,
                  iconStyle: IconStyle(
                    backgroundColor: Color.fromARGB(255, 87, 14, 176),
                  ),
                  title: "Điều khoản & điều kiện",
                  subtitle: "Chính sách điều khoản & điều kiện",
                ),
                SettingsItem(
                  icons: Icons.support_agent_outlined,
                  iconStyle: IconStyle(
                    backgroundColor: Color.fromARGB(255, 14, 176, 98),
                  ),
                  title: "Hỗ trợ & giải đáp",
                  titleStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  subtitle: "Hỗ trợ & giải đáp 24/7 người dùng",
                ),
              ],
            ),
            SettingsGroup(
              items: [
                SettingsItem(
                  onTap: () {},
                  icons: Icons.info_rounded,
                  iconStyle: IconStyle(
                    backgroundColor: Colors.purple,
                  ),
                  title: 'Thông tin',
                  subtitle: "Phiên bản hiện tại v2.5.9",
                ),
              ],
            ),
            SettingsGroup(
              settingsGroupTitle: "Tài khoản",
              items: [
                SettingsItem(
                  onTap: () {
                    logOut(context);
                  },
                  icons: Icons.exit_to_app_rounded,
                  iconStyle: IconStyle(),
                  title: "Đăng xuất",
                ),
                SettingsItem(
                  icons: Icons.cancel_outlined,
                  iconStyle: IconStyle(
                    backgroundColor: Color.fromARGB(255, 211, 39, 39),
                  ),
                  title: "Xoá tài khoản",
                  titleStyle: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
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
