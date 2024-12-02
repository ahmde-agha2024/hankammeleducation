import 'dart:io';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hankammeleducation/model/quiz.dart';
import 'package:hankammeleducation/pref/shared_pref_controller.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hankammeleducation/api/controllers/api_controller.dart';
import 'package:hankammeleducation/course/download.dart';
import 'package:hankammeleducation/course/viemo.dart';
import 'package:hankammeleducation/model/book_list.dart';
import 'package:shimmer/shimmer.dart';

import 'pdf_screen.dart';
import 'quiz/quiz_screen.dart';
import 'webview_screen.dart';

class MyCourseDetails extends StatefulWidget {
  MyCourseDetails(
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
  State<MyCourseDetails> createState() => _MyCourseDetailsState();
}

class _MyCourseDetailsState extends State<MyCourseDetails> {
  bool isConnected = false;
  int? userId;
  Future<BookListModel>? _future;
  Future<List<QuizRoot>>? _futureQuiz;

  @override
  void initState() {
    // TODO: implement initState
    checkInternetConnection();

    _future = ApiController()
        .getCourseDetails(documentId: widget.documentId, pop: 'populate=*');
    _futureQuiz = ApiController().getAllQuizzes(docId: widget.documentId);

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
      child: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<BookListModel>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 18),
                        child: ListView.builder(
                            shrinkWrap: true,
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
                    );
                  } else if (isConnected && snapshot.hasData) {
                    return Column(
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: snapshot.data!.curriculum.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 0,
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 0.5, color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ExpansionTile(
                                  tilePadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  leading: Icon(
                                    Icons.lock_open,
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
                                        itemCount: snapshot.data!
                                            .curriculum[index].curricula.length,
                                        shrinkWrap: true,
                                        physics: BouncingScrollPhysics(),
                                        itemBuilder: (context, index1) {
                                          return Row(
                                            children: [
                                              snapshot
                                                              .data!
                                                              .curriculum[index]
                                                              .curricula[index1]
                                                              .type ==
                                                          "video" ||
                                                      snapshot
                                                              .data!
                                                              .curriculum[index]
                                                              .curricula[index1]
                                                              .type ==
                                                          "vimeo"
                                                  ? Icon(
                                                      Icons.play_circle,
                                                      color: Colors.black,
                                                    )
                                                  : SizedBox(),
                                              snapshot
                                                          .data!
                                                          .curriculum[index]
                                                          .curricula[index1]
                                                          .type ==
                                                      "pdf"
                                                  ? Icon(
                                                      Icons.picture_as_pdf,
                                                      color: Colors.black,
                                                    )
                                                  : const SizedBox(),
                                              snapshot
                                                          .data!
                                                          .curriculum[index]
                                                          .curricula[index1]
                                                          .type ==
                                                      "h5p"
                                                  ? const Icon(
                                                      Icons.extension,
                                                      color: Colors.black,
                                                    )
                                                  : SizedBox(),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  if (snapshot
                                                              .data!
                                                              .curriculum[index]
                                                              .curricula[index1]
                                                              .type ==
                                                          "video" ||
                                                      snapshot
                                                              .data!
                                                              .curriculum[index]
                                                              .curricula[index1]
                                                              .type ==
                                                          "vimeo") {
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
                                                    await ApiController()
                                                        .completeLessons(
                                                            snapshot
                                                                .data!
                                                                .curriculum[
                                                                    index]
                                                                .curricula[
                                                                    index1]
                                                                .documentId);
                                                  } else if (snapshot
                                                          .data!
                                                          .curriculum[index]
                                                          .curricula[index1]
                                                          .type ==
                                                      "pdf") {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    PdfView(
                                                                      url: snapshot
                                                                          .data!
                                                                          .curriculum[
                                                                              index]
                                                                          .curricula[
                                                                              index1]
                                                                          .fileLink,
                                                                      title: snapshot
                                                                          .data!
                                                                          .curriculum[
                                                                              index]
                                                                          .curricula[
                                                                              index1]
                                                                          .title,
                                                                    )));

                                                    //Complete Lessons Here
                                                    await ApiController()
                                                        .completeLessons(
                                                            snapshot
                                                                .data!
                                                                .curriculum[
                                                                    index]
                                                                .curricula[
                                                                    index1]
                                                                .documentId);
                                                  } else if (snapshot
                                                          .data!
                                                          .curriculum[index]
                                                          .curricula[index1]
                                                          .type ==
                                                      "h5p") {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                WebViewXPlusScreen(
                                                                  url: snapshot
                                                                      .data!
                                                                      .curriculum[
                                                                          index]
                                                                      .curricula[
                                                                          index1]
                                                                      .videoLink,
                                                                  title: snapshot
                                                                      .data!
                                                                      .curriculum[
                                                                          index]
                                                                      .curricula[
                                                                          index1]
                                                                      .title,
                                                                )));

                                                    //Complete Lessons Here
                                                    await ApiController()
                                                        .completeLessons(
                                                            snapshot
                                                                .data!
                                                                .curriculum[
                                                                    index]
                                                                .curricula[
                                                                    index1]
                                                                .documentId);
                                                  }
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
                                              snapshot
                                                              .data!
                                                              .curriculum[index]
                                                              .curricula[index1]
                                                              .type ==
                                                          "video" ||
                                                      snapshot
                                                              .data!
                                                              .curriculum[index]
                                                              .curricula[index1]
                                                              .type ==
                                                          "vimeo"
                                                  ? Text(
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
                                                    )
                                                  : SizedBox(),
                                              snapshot
                                                              .data!
                                                              .curriculum[index]
                                                              .curricula[index1]
                                                              .type ==
                                                          "video" ||
                                                      snapshot
                                                              .data!
                                                              .curriculum[index]
                                                              .curricula[index1]
                                                              .type ==
                                                          "vimeo"
                                                  ? IconButton(
                                                      tooltip: "تحميل",
                                                      onPressed: () async {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        VideoDownloader(
                                                                          titleCourse: snapshot
                                                                              .data!
                                                                              .title!,
                                                                          allCourses:
                                                                              widget.allCourses,
                                                                          titleVideo: snapshot
                                                                              .data!
                                                                              .curriculum[index]
                                                                              .curricula[index1]
                                                                              .title,
                                                                          semesterNumber: snapshot
                                                                              .data!
                                                                              .curriculum[index]
                                                                              .sectionName!,
                                                                          link: snapshot
                                                                              .data!
                                                                              .curriculum[index]
                                                                              .curricula[index1]
                                                                              .downloadableVideoLink,
                                                                          phoneNumber: snapshot
                                                                              .data!
                                                                              .enrolledusers[index]
                                                                              .phoneNumber,
                                                                        )));
                                                      },
                                                      icon: Icon(
                                                        Icons.cloud_download,
                                                        size: 18,
                                                      ))
                                                  : SizedBox()
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          thickness: 0.5,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        FutureBuilder<List<QuizRoot>>(
                            future: _futureQuiz,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return SizedBox();
                              } else if (isConnected && snapshot.hasData) {
                                return ListView.builder(
                                    shrinkWrap: true,
                                    physics: BouncingScrollPhysics(),
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, quizIndex) {
                                      return Card(
                                        color: Colors.white,
                                        elevation: 0,
                                        clipBehavior: Clip.antiAlias,
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              width: 0.5,
                                              color: Colors.grey.shade300),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: ListTile(
                                          leading: Icon(
                                            Icons.quiz,
                                            size: 18,
                                          ),
                                          title: Text(
                                            snapshot.data![quizIndex].name,
                                            style: GoogleFonts.cairo(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10),
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        QuizScreen(
                                                          docId:
                                                              widget.documentId,
                                                          id: snapshot
                                                              .data![quizIndex]
                                                              .id - 1,
                                                        )));
                                          },
                                        ),
                                      );
                                    });
                              } else {
                                return Center(
                                  child: Text(
                                    "لا يوجد بيانات",
                                    style: GoogleFonts.cairo(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                );
                              }
                            }),
                      ],
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