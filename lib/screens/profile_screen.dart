import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shamssgazaa/api/controllers/api_controller.dart';
import 'package:shamssgazaa/pref/shared_pref_controller.dart';
import 'package:shamssgazaa/screens/aboutscreen.dart';
import 'package:shamssgazaa/screens/auth_screens/login_screen.dart';
import 'package:shamssgazaa/screens/privacy_screen.dart';
import 'package:shamssgazaa/screens/termsandconditions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shamssgazaa/widget/supportItem.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.topRight,
          child: Text(
            "الصفحة الشخصية",
            style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold, fontSize: 10, color: Colors.teal),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey, width: 0.3),
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    SupportItem(
                      icon: Icons.info_outline,
                      title: 'حول التطبيق',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AboutScreen()));
                      },
                    ),
                    SupportItem(
                      icon: Icons.help_outline,
                      title: 'الأسئلة الأكثر شيوعاً',
                      onTap: () {
                        print("Hello");
                      },
                    ),

                    // SupportItem(
                    //   icon: Icons.share_outlined,
                    //   title: 'Share this App',
                    // ),
                    SupportItem(
                      icon: Icons.format_list_numbered_rtl_rounded,
                      title: 'سياسة الخصوصية',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PrivacyScreen()));
                      },
                    ),
                    SupportItem(
                      icon: Icons.support,
                      title: 'الشروط والأحكام',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TermsAndConditions()));
                      },
                    ),
                    SupportItem(
                      icon: Icons.person_remove,
                      title: 'إغلاق الحساب',
                      onTap: () {
                        _showConfirmationDialog(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
            TextButton(
              onPressed: () {

                SharedPrefController().logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false,
                );
              },
              child: Text(
                'تسجيل الخروج',
                style: GoogleFonts.cairo(
                  color: Colors.teal,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          textAlign: TextAlign.center,
          'إغلاق الحساب',
          style: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.bold),
        ),
        content: Text(
          textAlign: TextAlign.center,
          'هل أنت متأكد أنك تريد إغلاق الحساب نهائياً ؟',
          style: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.w600),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // close Dialog
            },
            child: Text(
              'لا',
              style: GoogleFonts.cairo(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () async {
              await _deleteAccount(context);
            },
            child: Text(
              'نعم',
              style: GoogleFonts.cairo(
                  fontSize: 10, fontWeight: FontWeight.w700, color: Colors.red),
            ),
          ),
        ],
      );
    },
  );
}

Future<void> _deleteAccount(BuildContext context) async {
  var id = SharedPrefController().getByKey(key: PrefKeys.id.name);
  var statusOfDeleted = await ApiController().deleteAccount(id: id);
  if (statusOfDeleted) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }
}
