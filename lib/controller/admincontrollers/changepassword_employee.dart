import 'package:app_food_2023/controller/admincontrollers/edit_employee.dart';
import 'package:app_food_2023/widgets/custom_widgets/message.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../appstyle/succes_messages/success_style.dart';

bool validatePass = false, validatePassConfirm = false;
String phoneNumber = '';
String email = '', oldPass = '', passInput = '', confirmPassInput = '';
final user = FirebaseAuth.instance.currentUser;
bool checkUserAuthencation() {
  if (user != null) {
    for (final userInfo in user!.providerData) {
      if (userInfo.providerId == "google.com") {
        print("Đây là người dùng google");
        return true;
      }
    }
  }
  return false;
}

bool checkImage() {
  if (loggedInEmployee?.Avatar == null) {
    return true;
  } else {
    return false;
  }
}

String? validatePassword(String passInput) {
  RegExp regex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  if (passInput.isEmpty) {
    return 'Mật khẩu không được trống';
  } else {
    if (!regex.hasMatch(passInput)) {
      return 'Mật khẩu phải chứa 1 chữ hoa, 1 chữ thường,ký tự đặc biệt ,ký tự số và độ dài trên 8 ký tự';
    } else {
      validatePass = true;
      return "Mật khẩu hợp lệ";
    }
  }
}

String? checkMatchPassword() {
  if (!checkUserAuthencation()) {
    if (passInput != confirmPassInput) {
      return "Mật khẩu không khớp";
    } else if (oldPass == "" || confirmPassInput == "" || passInput == "")
      return "Vui lòng nhập đầy đủ thông tin!!";
    else {
      validatePassConfirm = true;
      return "Mật khẩu hợp lệ";
    }
  }
  return "";
}

Future<bool> changePasswordNormalUser(
    String email, String oldPassword, String newPassword) async {
  AuthCredential credential =
      EmailAuthProvider.credential(email: email, password: oldPassword);

  Map<String, String?> codeResponses = {
    // Re-auth responses
    "user-mismatch": "1",
    "user-not-found": "2",
    "invalid-credential": "3",
    "invalid-email": "4",
    "wrong-password": "5",
    "invalid-verification-code": "6",
    "invalid-verification-id": "7",
    // Update password error codes
    "weak-password": "8",
    "requires-recent-login": "9"
  };

  try {
    await user?.reauthenticateWithCredential(credential);
    await user?.updatePassword(newPassword);
    updateSucceed();
    return true;
  } on FirebaseAuthException catch (error) {
    CustomErrorMessage.showMessage(
        codeResponses[error.code] ?? "Chưa xác định");
    return false;
  }
}

Future<void> resetPasswordForGoogleAuthencation(String Email) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: Email);
    print("Password changed successfully!");
  } catch (e) {
    print("Failed to change password: $e");
    return;
  }
}
// void changePassWord(String Email,String oldPassword, String newPassword)
