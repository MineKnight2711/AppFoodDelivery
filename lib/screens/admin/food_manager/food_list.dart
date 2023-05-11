import 'package:app_food_2023/screens/admin/food_manager/add_food.dart';
import 'package:app_food_2023/screens/admin/food_manager/food_details.dart';
import 'package:app_food_2023/widgets/food_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_food_2023/util/normalize_vietnamese_string.dart';
import '../admin_screen.dart';

class FoodListScreen extends StatefulWidget {
  const FoodListScreen({Key? key}) : super(key: key);

  @override
  State<FoodListScreen> createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen> {
  TextEditingController _foodNameInput = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _foodNameInput.addListener(() {
      setState(() {});
    });
  }

  String foodName = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 43, 39, 39),
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Món ăn"),
        centerTitle: false,
        backgroundColor: Color.fromARGB(255, 38, 34, 34),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdminScreen(),
              ),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Danh sách tất cả món ăn",
                style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 26),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              width: 300,
              child: TextField(
                controller: _foodNameInput,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      _foodNameInput.clear();
                      _foodNameInput.text = "";
                      foodName = "";
                    },
                    child: Icon(
                      _foodNameInput.text.isEmpty ? null : Icons.clear,
                    ),
                  ),
                  hintText: 'Tìm món',
                  filled: true,
                  fillColor: Colors.grey[200],
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 69, 65, 65)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    foodName = value;
                  });
                },
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("dishes")
                    .orderBy("Price", descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  //check the connection state, if we still load the data we can display a progress bar
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    if (foodName.isEmpty || foodName == "") {
                      return GridView(
                        physics: AlwaysScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20, //Khoảng cách ngang
                          mainAxisSpacing: 10, //Khoảng cách dọc
                          mainAxisExtent: 230,
                        ),
                        children: snapshot.data!.docs
                            .map((dish) => foodCard(() {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            FoodDetailScreen(dish),
                                      ));
                                }, dish))
                            .toList(),
                      );
                    } else {
                      final searchList = snapshot.data!.docs
                          .where((element)
                              // => element['DishName']
                              //         .toString()
                              //         .toLowerCase()
                              //         .contains(foodName.toLowerCase())
                              {
                            String dishName = element['DishName'].toString();
                            String normalizedDishName =
                                removeDiacritics(dishName.toLowerCase());
                            String normalizedFoodName =
                                removeDiacritics(foodName.toLowerCase());
                            return normalizedDishName
                                .contains(normalizedFoodName);
                          })
                          .map((dish) => foodCard(() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          FoodDetailScreen(dish),
                                    ));
                              }, dish))
                          .toList();
                      if (searchList.length == 0) {
                        return Center(
                          child: Text("Không tìm thấy",
                              style: GoogleFonts.nunito(
                                  color: Colors.white, fontSize: 30)),
                        );
                      }
                      return GridView(
                        physics: AlwaysScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20, //Khoảng cách ngang
                          mainAxisSpacing: 10, //Khoảng cách dọc
                          mainAxisExtent: 230,
                        ),
                        children: searchList,
                      );
                    }
                  }
                  return Text("Không có món",
                      style: GoogleFonts.nunito(color: Colors.white));
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddFoodScreen()));
        },
        label: Text("Thêm mới"),
        icon: Icon(Icons.add),
      ),
    );
  }

  //Chuyển đổi chuỗi thành định dạng unicode utf 16
  // List<int> toUtf16(String str) {
  //   final units = <int>[];
  //   final strUnits = str.codeUnits;
  //   for (var i = 0; i < strUnits.length; i++) {
  //     units.add(strUnits[i] & 0xff);
  //     units.add(strUnits[i] >> 8);
  //   }
  //   return units;
  // }
}
