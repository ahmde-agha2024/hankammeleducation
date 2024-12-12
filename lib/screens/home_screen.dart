import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hankammeleducation/api/controllers/api_controller.dart';
import 'package:hankammeleducation/model/home.dart';
import 'package:hankammeleducation/pref/shared_pref_controller.dart';
import 'package:hankammeleducation/search/search.dart';
import 'package:hankammeleducation/service/firebase_notification_service.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'primary_stages.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller_page = PageController(viewportFraction: 1.2, keepPage: true);
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  bool _isLoading = false;
  bool _statusSearch = false;
  bool isConnected = false;
  late Future<List<HomeModel>> _future;
  int notificationCount = 0;
  bool isPopupOpened = false; // حالة التحقق من فتح الـ popup

  void _performSearch() async {
    final grade = _gradeController.text.trim();
    final searchText = _searchController.text.trim();

    setState(() {
      _isLoading = true;
    });

    try {
      final results = await ApiController().searchCourses(grade, searchText);
      setState(() {
        _isLoading = false;
        _statusSearch = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsPage(results: results),
        ),
      );
    } catch (error) {
      setState(() {
        _isLoading = false;
        _statusSearch = false;
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "خطأ",
            style: GoogleFonts.cairo(),
          ),
          content: Text(
            "خطأ في جلب البيانات $error",
            style: GoogleFonts.cairo(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "حسناً",
                style: GoogleFonts.cairo(),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    checkInternetConnection();
    super.initState();
    updateNotificationCount();
    _future = ApiController().getHome();
    _loadNotificationCount();
  }
  Future<void> _loadNotificationCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      notificationCount = prefs.getInt('notificationCount') ?? 0;
    });
  }

  Future<void> _saveNotificationCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('notificationCount', notificationCount);
  }

  void updateNotificationCount() {
    setState(() {
      notificationCount = FirebaseNotificationService.getNotificationCount();
    });
  }

  void refreshNotifications() {
    setState(() {
      notificationCount = FirebaseNotificationService.getNotificationCount();
    });
  }

  Future<void> showNotificationsPopup(BuildContext context) async {
    final box = await Hive.openBox('notifications');
    final notifications = box.values.toList();
    // تأكد من إخفاء العلامة فقط عند عرض الـ popup
    if (!isPopupOpened && notificationCount > 0) {
      setState(() {
        isPopupOpened = true; // تغيير الحالة إلى مفتوحة
        notificationCount = 0; // إخفاء العلامة مؤقتيًا
      });
      await _saveNotificationCount();
    }
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14), // تحكم في الزوايا
          ),
          child: SizedBox(
            height: 500, // تحديد الارتفاع المناسب للـ popup
            child: notifications.isEmpty
                ? Center(
                    child: Text(
                      'لا توجد إشعارات',
                      style: GoogleFonts.cairo(),
                    ),
                  )
                : Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'الإشعارات',
                        style: GoogleFonts.cairo(fontSize: 10),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                color: Colors.white,
                                child: ListTile(
                                  title: Text(
                                    notifications.elementAt(index)['title'] ??
                                        '',
                                    style: GoogleFonts.cairo(fontSize: 10),
                                  ),
                                  subtitle: Text(
                                    notifications.elementAt(index)['body'] ??
                                        '',
                                    style: GoogleFonts.cairo(fontSize: 9),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
          ),
        );
      },
    ).then((_) {
      // بعد إغلاق الـ popup
      setState(() {
        isPopupOpened = false; // إعادة الحالة عند إغلاق الـ popup
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          color: Colors.white,
          height: 40,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14),
          color: Colors.white,
          child: Row(
            children: [
              IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => showNotificationsPopup(context),
                  icon: Image.asset(
                    width: 35,
                    height: 35,
                    notificationCount > 0
                        ? 'images/notificationcomplete 1.png'
                        : 'images/notificationcomplete.png',
                  )),
              IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    setState(() {
                      _statusSearch = !_statusSearch;
                    });
                  },
                  icon: Image.asset(
                    width: 35,
                    height: 35,
                    'images/searchComplete.png',
                  )),
              Spacer(),
              SharedPrefController().getByKey(key: PrefKeys.isLoggedIn.name) ==
                      null
                  ? SizedBox()
                  : Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        " أهلاً وسهلاً بك : ${SharedPrefController().getByKey(key: PrefKeys.firstname.name)}",
                        style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold, fontSize: 8),
                      ),
                    ),
            ],
          ),
        ),
        Visibility(visible: _statusSearch, child: SizedBox(height: 16)),
        Visibility(
          visible: _statusSearch,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: SizedBox(
              width: double.infinity,
              height: 40,
              child: TextField(
                controller: _gradeController,
                onChanged: (value) {},
                keyboardType: TextInputType.number,
                style: GoogleFonts.cairo(fontSize: 8),
                decoration: InputDecoration(
                    labelText: 'الصف (على سبيل المثال، 2)',
                    hintText: "أدخل الصف الدراسي",
                    hintStyle: GoogleFonts.cairo(fontSize: 8),
                    labelStyle:
                        GoogleFonts.cairo(fontSize: 8, color: Colors.black54),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            BorderSide(width: 1, color: Color(0xffef476f))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            BorderSide(width: 1, color: Color(0xffef476f)))),
              ),
            ),
          ),
        ),
        Visibility(visible: _statusSearch, child: SizedBox(height: 16)),
        Visibility(
          visible: _statusSearch,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: SizedBox(
              width: double.infinity,
              height: 40,
              child: TextField(
                controller: _searchController,
                onChanged: (value) {},
                keyboardType: TextInputType.text,
                style: GoogleFonts.cairo(fontSize: 8),
                decoration: InputDecoration(
                    labelText: 'المادة (على سبيل المثال، الرياضيات)',
                    hintText: "أدخل إسم المادة",
                    hintStyle: GoogleFonts.cairo(fontSize: 8),
                    labelStyle:
                        GoogleFonts.cairo(fontSize: 8, color: Colors.black54),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            BorderSide(width: 1, color: Color(0xffef476f))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            BorderSide(width: 1, color: Color(0xffef476f)))),
              ),
            ),
          ),
        ),
        Visibility(visible: _statusSearch, child: SizedBox(height: 16)),
        _isLoading
            ? Visibility(
                visible: _statusSearch,
                child: const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.0,
                    color: Color(0xff073b4c),
                  ),
                ),
              )
            : Visibility(
                visible: _statusSearch,
                child: ElevatedButton(
                  onPressed: _performSearch,
                  child: Text(
                    'بحث',
                    style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10),
                  ),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(80, 35),
                      elevation: 0,
                      textStyle: GoogleFonts.cairo(),
                      backgroundColor: Color(0xff073b4c)),
                ),
              ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14),
          child: Container(
            clipBehavior: Clip.antiAlias,
            width: 398,
            height: 166,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey.shade300,
            ),
            child: PageView.builder(
              controller: controller_page,
              itemCount: 3,
              onPageChanged: (page) {
                print(page);
              },
              itemBuilder: (_, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Image.asset(
                    'images/thanawy.jpg',
                    width: 398,
                    height: 166,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(
          height: 14,
        ),
        SmoothPageIndicator(
          controller: controller_page,
          count: 3,
          effect: const ExpandingDotsEffect(
              dotColor: Color(0xfff58da6),
              activeDotColor: Color(0xffef476f),
              dotWidth: 8,
              dotHeight: 8),
          // your preferred effect
          onDotClicked: (index) {},
        ),
        SizedBox(
          height: 20,
        ),
        FutureBuilder<List<HomeModel>>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Expanded(
                  child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: ListView.builder(
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 10),
                              child: Container(
                                width: double.infinity,
                                height: 150.0,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                              ),
                            );
                          })),
                );
              } else if (isConnected &&
                  snapshot.data!.isNotEmpty &&
                  snapshot.hasData) {
                return Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    //shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'images/primary.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                        contentPadding: EdgeInsets.zero,
                        subtitle: Align(
                          child: Text(snapshot.data![index].title!,
                              style: GoogleFonts.cairo(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Color(0xff073b4c),
                              )),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PrimaryStages(
                                      id: snapshot.data![index].id.toString(),
                                      title: snapshot.data![index].title!,
                                    )),
                          );
                        },
                      );
                    },
                  ),
                );
              } else {
                return Center(
                  child: Text(
                    'لا يوجد بيانات',
                    style: GoogleFonts.cairo(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                );
              }
            }),
      ],
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
