import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hankammeleducation/api/controllers/api_controller.dart';
import 'package:hankammeleducation/api/controllers/auth_api_controllers.dart';
import 'package:hankammeleducation/course/announcements.dart';
import 'package:hankammeleducation/course/courseDetails.dart';
import 'package:hankammeleducation/main.dart';
import 'package:hankammeleducation/model/api_response.dart';
import 'package:hankammeleducation/model/book_list.dart';
import 'package:hankammeleducation/pref/shared_pref_controller.dart';
import 'package:hankammeleducation/screens/auth_screens/login_screen.dart';
import 'package:hankammeleducation/screens/mycoursedetails.dart';
import 'package:hankammeleducation/utils/helpers.dart';

class MyCourseScreenTwo extends StatefulWidget {
  MyCourseScreenTwo(
      {required this.documentId,
        required this.title,
        required this.grade,
        required this.description,
        required this.enrolled,
        super.key});

  String documentId;
  String title;
  String grade;
  String description;
  bool enrolled;

  @override
  State<MyCourseScreenTwo> createState() => _MyCourseScreenTwoState();
}

class _MyCourseScreenTwoState extends State<MyCourseScreenTwo>
    with SingleTickerProviderStateMixin, Helpers {
  late TabController _tabController;
  List<String> allCourses = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          '${widget.title} | ${widget.grade}',
          style: GoogleFonts.cairo(
              color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Align(
              alignment: Alignment.topRight,
              child: Text(
                "المحتوى | ${widget.title}",
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                  fontSize: 9,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Align(
              alignment: Alignment.topRight,
              child: Text(
                widget.description,
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                  fontSize: 9,
                ),
              ),
            ),
          ),
          FutureBuilder<List<BookListModel>>(
              future: ApiController().getAllCourses(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox();
                } else if (isConnected && snapshot.hasData) {
                  allCourses.clear();
                  for (BookListModel i in snapshot.data!) {
                    allCourses.add(i.title!.toString());
                  }
                  return SizedBox();
                } else {
                  return SizedBox();
                }
              }),
          SizedBox(
            height: 20,
          ),
          Container(
            //padding: EdgeInsets.only(top: 20),
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                    color: const Color(0xffECECEC),
                    borderRadius: BorderRadius.circular(8)),
                child: TabBar(
                    onTap: (int tabindex) {
                      setState(() {
                        _tabController.index = tabindex;
                      });
                    },
                    labelColor: Color(0xff073b4c),
                    dividerHeight: 0,
                    labelStyle: GoogleFonts.cairo(
                        fontSize: 10, fontWeight: FontWeight.w700),
                    unselectedLabelColor: Colors.black54,
                    controller: _tabController,
                    indicatorColor: const Color(0xff144CDB),
                    tabs: [
                      Tab(
                        text: "الفصول",
                      ),
                      Tab(
                        text: "إعلانات",
                      ),
                    ]),
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Expanded(
            child: TabBarView(controller: _tabController, children: [
              MyCourseDetails(
                title: widget.title,
                description: widget.description,
                grade: widget.grade,
                documentId: widget.documentId,
                enrolled: widget.enrolled,
                allCourses: allCourses,
              ),
              Announcements(
                documentId: widget.documentId,
              ),
            ]),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }


}
