import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hankammeleducation/api/controllers/api_controller.dart';
import 'package:hankammeleducation/course/course.dart';
import 'package:hankammeleducation/model/book_list.dart';
import 'package:shimmer/shimmer.dart';

class BookList extends StatefulWidget {
  BookList({required this.title, required this.id});

  String id;
  String title;


  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  bool isConnected = false;

  @override
  void initState() {
    // TODO: implement initState
    checkInternetConnection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          widget.title,
          style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<BookListModel>>(
          future: ApiController()
              .getBookList(subCategoryEqual: widget.id, populate: '*'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 5.0,
                    ),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      );
                    },
                  ),
                ),
              );
            } else if (isConnected &&
                snapshot.data!.isNotEmpty &&
                snapshot.hasData) {
              return GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2 / 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CourseScreen(
                                  documentId: snapshot.data![index].documentId!,
                              title: snapshot.data![index].title!,
                              grade: snapshot.data![index].subCategory!.title!,
                              description: snapshot.data![index].description!,
                              enrolled: snapshot.data![index].enrolled,
                                )),
                      );
                    },
                    child: Card(
                      color: Colors.white,
                      elevation: 0,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        side:
                            BorderSide(width: 0.5, color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            snapshot.data![index].courseImage == null
                                ? Image.network(
                                    'https://tadamon.s3.eu-west-2.amazonaws.com/medium_news_blog_banner_1200x675_feb457f8e1.png',
                                    height: 130,
                                    fit: BoxFit.contain)
                                : Image.network(
                                    snapshot.data![index].courseImage!.formats!
                                        .medium!.url!,
                                    height: 130,
                                    fit: BoxFit.contain),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                children: [
                                  Text(
                                    "المادة : ",
                                    style: GoogleFonts.cairo(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                    child: Text(
                                      snapshot.data![index].title!,
                                      style: GoogleFonts.cairo(
                                        fontSize: 9,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: Row(
                                children: [
                                  // Text("التقييم :",
                                  //     style: GoogleFonts.cairo(
                                  //         //decoration: TextDecoration.lineThrough,
                                  //         fontSize: 12,
                                  //         fontWeight: FontWeight.bold)),
                                  RatingBar.builder(
                                      itemSize: 15,
                                      initialRating: 3,
                                      minRating: 1,
                                      itemCount: 5,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      ignoreGestures: false,
                                      itemBuilder: (context, _) => const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                      onRatingUpdate: (rating) async {
                                        setState(() {});
                                      }),
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 0.5,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: Row(
                                textDirection: TextDirection.ltr,
                                children: [
                                  Spacer(),
                                  Align(
                                      alignment: Alignment.bottomRight,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Text(
                                          'عدد الفصول: ${snapshot.data![index].curriculum.length}',
                                          style: GoogleFonts.cairo(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 8,
                                              color: Colors.grey),
                                        ),
                                      )),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.play_circle_outline_outlined,
                                    color: Colors.black26,
                                    size: 14,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text(
                  "لا يوجد بيانات",
                  style: GoogleFonts.cairo(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
              );
            }
          }),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Color(0xffFF9A00),
      //   child: Icon(Icons.shopping_cart,color: Colors.white,),
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => CartScreen(cartItems: cartItems),
      //       ),
      //     );
      //   },
      // ),
    );
  }

  Future<void> checkInternetConnection() async {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      setState(() {
        isConnected = true;
      });
    } else {
      setState(() {
        isConnected = false;
      });
    }
  }
}
