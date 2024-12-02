import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shamssgazaa/course/viemo.dart';
import 'package:shamssgazaa/pref/shared_pref_controller.dart';
import 'package:shamssgazaa/utils/helpers.dart';

class MyDownloads extends StatefulWidget {
  MyDownloads({super.key});

  @override
  _MyDownloadsState createState() => _MyDownloadsState();
}

class _MyDownloadsState extends State<MyDownloads> with Helpers {
  final Box _downloadsBox = Hive.box('downloads'); // الوصول إلى صندوق التحميلات
  String _selectedCategory = "الكل"; // التصنيف الحالي
  bool status =false;
  void deleteDownload(int index) {
    _downloadsBox.deleteAt(index); // حذف عنصر من Hive
    setState(() {}); // تحديث الواجهة
    showSnackBar(context, message: "تم حذف التنزيل!", error: false);
  }

  void deleteAllDownloads() {
    _downloadsBox.clear(); // حذف كل العناصر
    setState(() {}); // تحديث الواجهة

    showSnackBar(context, message: "تم حذف جميع التنزيلات!", error: false);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    status = SharedPrefController().getByKey(key: PrefKeys.listCategory.name) == null;

    final downloads = _selectedCategory == "الكل"
        ? _downloadsBox.values.toList()
        : _downloadsBox.values
            .where((download) => download['category'] == _selectedCategory)
            .toList();

    return status
        ? Center(
            child: Text(
              "لا يوجد بيانات",
              style:
                  GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          )
        : Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    Text(
                      "إختر المادة : ",
                      style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold, fontSize: 9),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    DropdownButton<String>(
                      value: _selectedCategory,
                      items: SharedPrefController()
                          .listAllCategot
                          .map((category) => DropdownMenuItem(
                                value: category,
                                child: Text(
                                  category,
                                  style: GoogleFonts.cairo(fontSize: 10),
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(
                        Icons.delete_forever,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        setState(() {
                          deleteAllDownloads();
                        });
                      },
                    ),
                  ],
                ),
              ),

              // عرض قائمة التحميلات
              Expanded(
                child: downloads.isEmpty
                    ? Center(
                        child: Text(
                        "لا تتوفر أي تنزيلات",
                        style: GoogleFonts.cairo(
                            fontSize: 10, fontWeight: FontWeight.bold),
                      ))
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        itemCount: downloads.length,
                        itemBuilder: (context, index) {
                          final download = downloads[index];
                          return Card(
                            color: Colors.white,
                            child: ListTile(
                              //leading: Icon(Icons.video_file),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => VideoPlayerScreen(
                                              url: download['filePath'],
                                            )));
                              },
                              title: Text(
                                "${download['sectionname']} - ${download['filePath'].split('/').last} ",
                                // عرض اسم الملف فقط
                                style: GoogleFonts.cairo(
                                    fontWeight: FontWeight.bold, fontSize: 8),
                              ),
                              subtitle: Text(
                                "${download['category']}",
                                style: GoogleFonts.cairo(
                                    fontSize: 8, fontWeight: FontWeight.bold),
                              ),
                              // subtitle: Text(
                              //   "${download['category']} - تاريخ التنزيل : ${download['timestamp']}",
                              //   style: GoogleFonts.cairo(fontSize: 8),
                              // ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  deleteDownload(index); // حذف عنصر معين
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
  }
}
