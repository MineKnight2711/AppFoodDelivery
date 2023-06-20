import 'package:app_food_2023/controller/user.dart';
import 'package:app_food_2023/screens/loading_screen/login_loading.dart';
import 'package:app_food_2023/screens/login_register/register_screen.dart';
import 'package:app_food_2023/util/upload_default_image.dart';
import 'package:app_food_2023/widgets/custom_widgets/message.dart';
import 'package:app_food_2023/widgets/custom_widgets/transitions_animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/UserModel.dart';
import '../home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? email = "";
  String fullName = "";
  String? firstName = "";
  String? lastName = "";
  // form key
  final _formKey = GlobalKey<FormState>();

  // editing controller
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  // firebase
  final _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  // string for displaying the error Message
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    //email field
    final emailField = TextFormField(
        autofocus: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Email trống!!");
          }
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Email không đúng (1)");
          }
          return null;
        },
        onSaved: (value) {
          emailController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //password field
    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordController,
        obscureText: true,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Mật khẩu trống!!");
          }
          if (!regex.hasMatch(value)) {
            return ("Pass không đúng (1)");
          }
          return null;
        },
        onSaved: (value) {
          passwordController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Mật khẩu",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () async {
            signIn(emailController.text, passwordController.text);
          },
          child: Text(
            "Đăng nhập",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );
    final registerButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RegistrationScreen()));
          },
          child: Text(
            "Tạo tài khoản",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );
    final signUpWithGoogleButton = Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        gradient: LinearGradient(
          begin: Alignment(-0.95, 0.0),
          end: Alignment(1.0, 0.0),
          colors: [const Color(0xff667eea), const Color(0xff64b6ff)],
          stops: [0.0, 1.0],
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          disabledForegroundColor: Colors.transparent.withOpacity(0.38),
          disabledBackgroundColor: Colors.transparent.withOpacity(0.12),
          shadowColor: Colors.transparent,
        ),
        onPressed: () {
          signInWithGoogle();
        },
        child: Row(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: CircleAvatar(
                radius: 12,
                backgroundImage: AssetImage("images/Google.png"),
              ),
            ),
            SizedBox(
              width: 45,
            ),
            Text(
              'Đăng nhập với Google',
              style: TextStyle(
                fontSize: 20,
                color: const Color(0xffffffff),
                letterSpacing: -0.3858822937011719,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        height: 150,
                        child: Image.asset(
                          "images/login.png",
                          fit: BoxFit.contain,
                        )),
                    SizedBox(height: 45),
                    emailField,
                    SizedBox(height: 25),
                    passwordField,
                    SizedBox(height: 35),
                    loginButton,
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Bạn chưa có tài khoản? ",
                          style: GoogleFonts.roboto(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    registerButton,
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        "hoặc",
                        style: GoogleFonts.roboto(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 20),
                    signUpWithGoogleButton,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // login function
  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((userCredential) async {
          user = userCredential.user;
          await FirebaseAuth.instance.authStateChanges();
          await FirebaseAuth.instance.userChanges();
          Fluttertoast.showToast(msg: "Đăng nhập thành công");
          refreshTransition(context, LoginLoadingScreen());
          await getCurrentUser();
          await convertToUserModel();
        });
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('email', email);
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Email không hợp lệ!.";
            break;
          case "wrong-password":
            errorMessage = "Sai mật khẩu.";
            break;
          case "user-not-found":
            errorMessage = "Tài khoản không tồn tại.";
            break;
          case "user-disabled":
            errorMessage = "Tài khoản bị khoá.";
            break;
          case "too-many-requests":
            errorMessage = "Sai mật khẩu quá nhiều lần vui lòng đợi 30 giây";
            break;
          case "operation-not-allowed":
            errorMessage =
                "Không thể đăng nhập vui lòng liên hệ người phát triển.";
            break;
          default:
            errorMessage = "Lỗi chưa xác định.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }

  get_first_name(String firstName) {
    var names = fullName.split(' ');
    String first_name = "";

    for (int i = 0; i != names.length; i++) {
      if (i != names.length - 1) {
        if (i == 0) {
          first_name = first_name + names[i];
        } else {
          first_name = first_name + " " + names[i];
        }
      }
    }
    return first_name; // Ví dụ :Huỳnh Phước
  }

  get_last_name(String lastName) {
    var names = fullName.split(' ');
    return names[names.length - 1].toString(); // Đạt
  }

  signInWithGoogle() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    GoogleSignInAccount? googleUser =
        await GoogleSignIn().signIn().onError((error, stackTrace) {
      CustomErrorMessage.showMessage('$error');
      return null;
    });
    if (googleUser == null) {
      CustomErrorMessage.showMessage('Đã huỷ đăng nhập!');
      return;
    }

    GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    var newUserId = userCredential.user?.uid;
    fullName = userCredential.user?.displayName! ?? "";

    firstName = get_first_name(fullName);
    lastName = get_last_name(fullName);

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    UserModel userModel = UserModel();

    // writing all the values
    userModel.Email = userCredential.user?.email;

    userModel.FirstName = firstName;
    userModel.LastName = lastName;
    userModel.Role = "Customer";
    await firebaseFirestore
        .collection("users")
        .doc(userCredential.user?.uid)
        .get()
        .then((value) async {
      if (!value.exists) {
        //Upload hình mặc định

        userModel.Avatar = await uploadAvatar(newUserId ?? "");
        firebaseFirestore
            .collection("users")
            .doc(newUserId)
            .set(userModel.toMap());
        preferences.setString('email', userCredential.user!.email.toString());
        Fluttertoast.showToast(msg: "Đăng nhập thành công ");
        slideupTransition(context, AppHomeScreen());
        await getCurrentUser();
        await convertToUserModel();
      } else {
        preferences.setString('email', userCredential.user!.email.toString());
        Fluttertoast.showToast(msg: "Đăng nhập thành công ");
        zoominTransition(context, AppHomeScreen());
        await getCurrentUser();
        await convertToUserModel();
      }
    });
  }
}
