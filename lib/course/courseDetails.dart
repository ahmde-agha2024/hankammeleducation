import 'dart:io';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shamssgazaa/api/controllers/api_controller.dart';
import 'package:shamssgazaa/course/download.dart';
import 'package:shamssgazaa/course/viemo.dart';
import 'package:shamssgazaa/model/book_list.dart';
import 'package:shimmer/shimmer.dart';

class CourseDetails extends StatefulWidget {
  CourseDetails(
      {required this.documentId,
      required this.title,
      required this.grade,
      required this.description,
      required this.enrolled,
      required this.allCourses,
      super.key});

  String documentId;
  String title;
  String grade;
  String description;
  bool enrolled;
  List<String> allCourses;

  @override
  State<CourseDetails> createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> {
  bool isConnected = false;

  Future<BookListModel>? _future;

  @override
  void initState() {
    // TODO: implement initState
    checkInternetConnection();
    _future = ApiController().getCourseDetails(documentId: widget.documentId);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          FutureBuilder<BookListModel>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Expanded(
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 18),
                        child: ListView.builder(
                            //shrinkWrap: true,
                            itemCount: 20,
                            itemBuilder: (context, indexCourseDetails) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Container(
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                  );
                } else if (isConnected && snapshot.hasData) {
                  return widget.enrolled
                      ? Expanded(
                          child: ListView.builder(
                              //shrinkWrap: true,
                              itemCount: snapshot.data!.curriculum.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  elevation: 0,
                                  clipBehavior: Clip.antiAlias,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 0.5,
                                        color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ExpansionTile(
                                    tilePadding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    leading: Icon(
                                      Icons.lock,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                    // subtitle: Align(
                                    //   alignment: Alignment.topRight,
                                    //   child: Text(
                                    //       ' عدد الدروس : 20 | المدة  05:25:15',
                                    //       style: GoogleFonts.cairo(
                                    //           fontWeight: FontWeight.w700,
                                    //           fontSize: 8,
                                    //           color: Colors.grey)),
                                    // ),
                                    backgroundColor: Colors.white,
                                    collapsedIconColor: Color(0xffef476f),
                                    iconColor: const Color(0xffef476f),
                                    collapsedBackgroundColor: Colors.white,
                                    collapsedTextColor: Colors.white,
                                    title: Text(
                                      snapshot
                                          .data!.curriculum[index].sectionName!,
                                      style: GoogleFonts.cairo(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 9,
                                          color: Colors.black),
                                    ),
                                    expandedAlignment: Alignment.topLeft,
                                    childrenPadding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    textColor: Color(0xff073b4c),
                                    initiallyExpanded: false,
                                    trailing: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Color(0xff073b4c),
                                      // size: 14,
                                    ),
                                    children: [
                                      // Align(
                                      //   alignment: Alignment.topRight,
                                      //   child: Text('عدد الدروس : 20',
                                      //   child: Text('عدد الدروس : 20',
                                      //       style: GoogleFonts.cairo(
                                      //           fontWeight: FontWeight.w700,
                                      //           fontSize: 8,
                                      //           color: Colors.grey)),
                                      // ),
                                      // Align(
                                      //   alignment: Alignment.topRight,
                                      //   child: Text("المدة  05:25:15",
                                      //       style: GoogleFonts.cairo(
                                      //           fontWeight: FontWeight.w700,
                                      //           fontSize: 8,
                                      //           color: Colors.red)),
                                      // ),
                                      // SizedBox(
                                      //   height: 10,
                                      // ),
                                      SizedBox(
                                        height: snapshot.data!.curriculum[index]
                                                    .curricula.length >
                                                6
                                            ? 200
                                            : null,
                                        child: ListView.builder(
                                          itemCount: snapshot
                                              .data!
                                              .curriculum[index]
                                              .curricula
                                              .length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index1) {
                                            return Row(
                                              children: [
                                                Icon(
                                                  Icons.play_circle,
                                                  color: Colors.black,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                VideoPlayerScreen(
                                                                  url: snapshot
                                                                      .data!
                                                                      .curriculum[
                                                                          index]
                                                                      .curricula[
                                                                          index1]
                                                                      .videoLink,
                                                                )));
                                                  },
                                                  child: Text(
                                                    snapshot
                                                        .data!
                                                        .curriculum[index]
                                                        .curricula[index1]
                                                        .title,
                                                    style: GoogleFonts.cairo(
                                                        fontSize: 9,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                                Spacer(),
                                                Text(
                                                  snapshot
                                                      .data!
                                                      .curriculum[index]
                                                      .curricula[index1]
                                                      .videoDuration,
                                                  style: GoogleFonts.cairo(
                                                      fontSize: 8,
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                IconButton(
                                                    tooltip: "تحميل",
                                                    onPressed: () async {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  VideoDownloader(
                                                                    titleCourse:
                                                                        snapshot
                                                                            .data!
                                                                            .title!,
                                                                    allCourses:
                                                                        widget
                                                                            .allCourses,
                                                                    titleVideo: snapshot
                                                                        .data!
                                                                        .curriculum[
                                                                            index]
                                                                        .curricula[
                                                                            index1]
                                                                        .title,
                                                                    semesterNumber: snapshot
                                                                        .data!
                                                                        .curriculum[
                                                                            index]
                                                                        .sectionName!,
                                                                    link: snapshot
                                                                        .data!
                                                                        .curriculum[
                                                                    index]
                                                                        .curricula[
                                                                    index1]
                                                                        .downloadableVideoLink,
                                                                    phoneNumber: snapshot.data!.enrolledusers[index].phoneNumber,
                                                                  )));
                                                    },
                                                    icon: Icon(
                                                      Icons.cloud_download,
                                                      size: 18,
                                                    ))
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        )
                      : Expanded(
                          child: ListView.builder(
                              //shrinkWrap: true,
                              itemCount: snapshot.data!.curriculum.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  elevation: 0,
                                  clipBehavior: Clip.antiAlias,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 0.5,
                                        color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ExpansionTile(
                                    tilePadding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    leading: Icon(
                                      Icons.lock,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                    // subtitle: Align(
                                    //   alignment: Alignment.topRight,
                                    //   child: Text(
                                    //       ' عدد الدروس : 20 | المدة  05:25:15',
                                    //       style: GoogleFonts.cairo(
                                    //           fontWeight: FontWeight.w700,
                                    //           fontSize: 8,
                                    //           color: Colors.grey)),
                                    // ),
                                    backgroundColor: Colors.white,
                                    collapsedIconColor: Color(0xffef476f),
                                    iconColor: const Color(0xffef476f),
                                    collapsedBackgroundColor: Colors.white,
                                    collapsedTextColor: Colors.white,
                                    title: Text(
                                      snapshot
                                          .data!.curriculum[index].sectionName!,
                                      style: GoogleFonts.cairo(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 9,
                                          color: Colors.black),
                                    ),
                                    expandedAlignment: Alignment.topLeft,
                                    childrenPadding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    textColor: Color(0xff073b4c),
                                    initiallyExpanded: false,
                                    trailing: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Color(0xff073b4c),
                                      // size: 14,
                                    ),
                                    children: [
                                      // Align(
                                      //   alignment: Alignment.topRight,
                                      //   child: Text('عدد الدروس : 20',
                                      //       style: GoogleFonts.cairo(
                                      //           fontWeight: FontWeight.w700,
                                      //           fontSize: 8,
                                      //           color: Colors.grey)),
                                      // ),
                                      // Align(
                                      //   alignment: Alignment.topRight,
                                      //   child: Text("المدة  05:25:15",
                                      //       style: GoogleFonts.cairo(
                                      //           fontWeight: FontWeight.w700,
                                      //           fontSize: 8,
                                      //           color: Colors.red)),
                                      // ),
                                      // SizedBox(
                                      //   height: 10,
                                      // ),
                                      SizedBox(
                                        height: snapshot.data!.curriculum[index]
                                                    .curricula.length >
                                                6
                                            ? 200
                                            : null,
                                        child: ListView.builder(
                                          itemCount: snapshot
                                              .data!
                                              .curriculum[index]
                                              .curricula
                                              .length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index1) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.play_circle,
                                                    color: Colors.black,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    snapshot
                                                        .data!
                                                        .curriculum[index]
                                                        .curricula![index1]
                                                        .title,
                                                    style: GoogleFonts.cairo(
                                                        fontSize: 9,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    snapshot
                                                        .data!
                                                        .curriculum[index]
                                                        .curricula[index1]
                                                        .videoDuration,
                                                    style: GoogleFonts.cairo(
                                                        fontSize: 8,
                                                        color: Colors.green,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  // IconButton(
                                                  //     tooltip: "تحميل",
                                                  //     onPressed: () {},
                                                  //     icon: Icon(
                                                  //       Icons.cloud_download,
                                                  //       size: 18,
                                                  //     ))
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
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
