import 'package:app_food_2023/model/rating_user.dart';
import 'package:app_food_2023/widgets/show_rating.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//
Widget ratingCard(Function()? onTap, QueryDocumentSnapshot doc) {
  UserRatingModel getRatingUser = UserRatingModel();
  Future<UserRatingModel> getUser() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(doc["UserID"])
        .get()
        .then((value) {
      getRatingUser = UserRatingModel.fromMap(value.data());
    });
    return getRatingUser;
  }

  bool checkImage() {
    if (getRatingUser.Images == null) {
      return true;
    } else {
      return false;
    }
  }

  return SingleChildScrollView(
    child: Column(
      children: [
        Stack(
          children: [
            FutureBuilder(
              future: getUser(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Row(
                    children: [
                      Container(
                        child: checkImage()
                            ? CircularProgressIndicator()
                            : CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(
                                    getRatingUser.Images.toString()),
                              ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Text(
                            "${getRatingUser.firstName} ${getRatingUser.secondName}",
                            style: GoogleFonts.roboto(fontSize: 16)),
                      ),
                    ],
                  );
                }
                return Text(
                  "",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black45,
                  ),
                );
              },
            ),
            Positioned(
              top: 20,
              left: 50,
              child: Row(
                children: [
                  ShowRatingBar(
                    rating: doc["Score"],
                    size: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 3, left: 5),
                    child: Text(
                      doc['Score'].toString(),
                      style: GoogleFonts.nunito(fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Flexible(
                child: Text(doc["Feedback"],
                    style: GoogleFonts.nunito(fontSize: 16))),
          ],
        )
      ],
    ),
  );
  // ListTile(
  //   // leading: CircleAvatar(
  //   //   backgroundImage: NetworkImage(
  //   //     doc['Avatar'],
  //   //   ),
  //   // ),
  //   title: Text(doc['UserID']),
  //   subtitle: Text(
  //     doc['Score'].toString(),
  //   ),
  //   trailing: Row(
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       IconButton(
  //         icon: Icon(Icons.edit),
  //         onPressed: () {},
  //       ),
  //       IconButton(
  //         icon: Icon(Icons.perm_identity),
  //         onPressed: () {},
  //       ),
  //     ],
  //   ),
  // );
}
