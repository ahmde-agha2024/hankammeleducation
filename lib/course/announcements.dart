import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hankammeleducation/api/controllers/api_controller.dart';
import 'package:hankammeleducation/model/book_list.dart';
import 'package:shimmer/shimmer.dart';

class Announcements extends StatefulWidget {
  Announcements({required this.documentId, super.key});

  String documentId;

  @override
  State<Announcements> createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  bool isConnected = false;

  @override
  void initState() {
    // TODO: implement initState
    checkInternetConnection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          FutureBuilder<BookListModel>(
              future: ApiController().getCourseDetails(
                  documentId: widget.documentId, pop: "populate=*"),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 20,
                        itemBuilder: (context, indexAnnoucement) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Container(
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                } else if (isConnected && snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 18),
                        //shrinkWrap: true,
                        itemCount: snapshot.data!.announcements.length,
                        itemBuilder: (context, index) {
                          return Text(
                            snapshot.data!.announcements[index].title!,
                            style: GoogleFonts.cairo(
                                fontWeight: FontWeight.bold,
                                fontSize: 9,
                                color: Colors.black),
                          );
                        }),
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
        ],
      ),
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
