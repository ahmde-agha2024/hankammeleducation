import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shamssgazaa/api/controllers/api_controller.dart';
import 'package:shamssgazaa/model/subcategory.dart';
import 'package:shamssgazaa/screens/book_list.dart';
import 'package:shimmer/shimmer.dart';

class PrimaryStages extends StatefulWidget {
  PrimaryStages({required this.id, required this.title, super.key});

  String id;
  String title;

  @override
  State<PrimaryStages> createState() => _PrimaryStagesState();
}

class _PrimaryStagesState extends State<PrimaryStages> {
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
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title,
            style: GoogleFonts.cairo(
                color: Color(0xff073b4c),
                fontSize: 12,
                fontWeight: FontWeight.bold)),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
          child: FutureBuilder<List<SubCategoryModel>>(
              future: ApiController()
                  .getSubCategory(categoryEqual: widget.id, populate: '*'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: GridView(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5.0,
                          mainAxisSpacing: 5.0,
                        ),
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (isConnected &&
                    snapshot.data!.isNotEmpty &&
                    snapshot.hasData) {
                  return GridView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Color(0xff073b4c),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Align(
                            child: Text(snapshot.data![index].title,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.cairo(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 10)),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookList(
                                  title: snapshot.data![index].title.toString(),
                                  id: snapshot.data![index].id.toString(),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 1.0,
                      mainAxisSpacing: 2.0,
                    ),
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
              })),
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