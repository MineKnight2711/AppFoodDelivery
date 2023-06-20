import 'package:app_food_2023/appstyle/screensize_aspectratio/mediaquery.dart';
import 'package:app_food_2023/controller/customercontrollers/cart.dart';
import 'package:app_food_2023/screens/home_screen.dart';
import 'package:app_food_2023/widgets/custom_widgets/transitions_animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../util/normalize_vietnamese_string.dart';
import 'food_details.dart';

//enum theo sau là một tập hợp các giá trị hằng số được đặt trong dấu ngoặc nhọn {}
enum SortBy { priceLowToHigh, priceHighToLow }

// ignore: must_be_immutable
class DishByCategory extends StatefulWidget {
  DishByCategory(this.doc, {Key? key}) : super(key: key);
  @override
  _DishByCategoryState createState() => _DishByCategoryState();
  QueryDocumentSnapshot? doc;
}

class _DishByCategoryState extends State<DishByCategory> {
  int check = 0;
  int rateCount = 0;
  double tongDiem = 0.0;
  TextEditingController _foodNameInput = new TextEditingController();
  String foodName = "";
  SortBy _sortBy = SortBy.priceLowToHigh;
  late Stream<QuerySnapshot<Map<String, dynamic>>> stream;
  final currentcy = new NumberFormat('#,##0', 'ID');
  @override
  void initState() {
    super.initState();
    _foodNameInput.addListener(() {
      setState(() {});
    });
  }

  Future<void> _refresh() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Các món ${widget.doc?['name']}',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('Xếp theo'),
              PopupMenuButton<SortBy>(
                icon: Image.asset(
                  'assets/icon/menu_icon.png',
                  color: Colors.black,
                  scale: 4,
                ),
                onSelected: (SortBy value) {
                  setState(() {
                    _sortBy = value;
                    // sortDishes();
                  });
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<SortBy>>[
                  const PopupMenuItem<SortBy>(
                    value: SortBy.priceLowToHigh,
                    child: Text('Giá: Thấp đến cao'),
                  ),
                  const PopupMenuItem<SortBy>(
                    value: SortBy.priceHighToLow,
                    child: Text('Giá: Cao đến thấp'),
                  ),
                ],
              )
            ],
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AppHomeScreen(),
              ),
            );
          },
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("dishes")
              .where('CategoryID', isEqualTo: widget.doc?.id)
              .orderBy('Price', descending: _sortBy == SortBy.priceLowToHigh)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              if (foodName.isEmpty || foodName == "") {
                final listDish = snapshot.data!.docs.toList();
                return StaggeredGridView.countBuilder(
                  crossAxisCount: 2,
                  itemCount: listDish.length,
                  itemBuilder: (context, index) {
                    final item = listDish[index];
                    return DishBycategoryGrid(item: item);
                  },
                  staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                );
              } else {
                final searchList = snapshot.data!.docs.where((element) {
                  String dishName = element['DishName'].toString();
                  String normalizedDishName =
                      removeDiacritics(dishName.toLowerCase());
                  String normalizedFoodName =
                      removeDiacritics(foodName.toLowerCase());
                  return normalizedDishName.contains(normalizedFoodName);
                }).toList();
                if (searchList.length == 0) {
                  return Center(
                    child: Text("Không tìm thấy",
                        style: GoogleFonts.nunito(
                            color: Colors.white, fontSize: 30)),
                  );
                }
                return StaggeredGridView.countBuilder(
                  crossAxisCount: 2,
                  itemCount: searchList.length,
                  itemBuilder: (context, index) {
                    final item = searchList[index];
                    return DishBycategoryGrid(item: item);
                  },
                  staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                );
              }
            }
            return Text("Không có món",
                style: GoogleFonts.nunito(color: Colors.white));
          },
        ),
      ),
    );
  }
}

class DishBycategoryGrid extends StatelessWidget {
  final QueryDocumentSnapshot item;

  const DishBycategoryGrid({super.key, required this.item});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        slideupTransition(context, FoodViewDetails(item));
      },
      child: Card(
        shadowColor: const Color.fromARGB(66, 52, 50, 50).withOpacity(1),
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: ScreenRotate(context)
                        ? MediaHeight(context, 5.5)
                        : MediaHeight(context, 2.5),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          "${item['Image']}",
                        ),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(
                          16.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 11.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Flexible(
                            flex: 9,
                            child: Text("${item['DishName']}",
                                style: GoogleFonts.roboto(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                )),
                          ),
                        ]),
                        SizedBox(
                          height: MediaHeight(context, 50),
                        ),
                        Row(
                          children: [
                            Text('Đánh giá - '),
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('ratings')
                                  .where('DishID', isEqualTo: item.id)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  double trungBinh = 0;
                                  double tongDiem = 0;
                                  int rateCount = 0;
                                  tongDiem = snapshot.data!.docs.fold(
                                      0.0, (sum, doc) => sum + doc["Score"]);

                                  rateCount = snapshot.data!.docs.length;
                                  if (rateCount != 0) {
                                    trungBinh = double.parse(
                                        (tongDiem / rateCount)
                                            .toStringAsFixed(1));
                                  }

                                  return Text("${trungBinh}",
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                      ));
                                }
                                return Spacer();
                              },
                            ),
                            Icon(
                              Icons.star,
                              size: 14.0,
                              color: Colors.orange,
                            ),
                          ],
                        ),
                        Text(
                          "Còn lại: ${item['InStock']}",
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff02A88A),
                          ),
                        ),
                        Text(
                          "Giá: ${formatCurrency(item['Price'])}",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: const Color(0xff02A88A),
                          ),
                        ),
                      ],
                    ),
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
