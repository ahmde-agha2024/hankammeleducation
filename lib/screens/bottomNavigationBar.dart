import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hankammeleducation/mydownloadcourses.dart';
import 'package:hankammeleducation/screens/home_screen.dart';
import 'package:hankammeleducation/screens/muCoursrs.dart';
import 'package:hankammeleducation/widget/btn_screen.dart';

import 'primary_stages.dart';
import 'profile_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  BottomNavigationScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  late List<BtnScreen> _btnScreen = <BtnScreen>[
    BtnScreen(widget: HomeScreen(), title: 'Home'),
    BtnScreen(widget: MyCourses(), title: 'My Course'),
    BtnScreen(widget: MyDownloads(), title: 'Downloads'),
    BtnScreen(widget: ProfileScreen(), title: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: const Color(0xffF6F7FC),
      backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: _btnScreen[_currentIndex].widget,
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadiusDirectional.only(
              topStart: Radius.circular(24), topEnd: Radius.circular(24)),
          child: BottomNavigationBar(
            onTap: (int currentIndex) {
              setState(() => _currentIndex = currentIndex);
            },
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xffef476f),
            selectedIconTheme: const IconThemeData(
              color: Color(0xffef476f),
            ),
            unselectedItemColor: const Color(0xffC2C2C2),
            unselectedIconTheme: const IconThemeData(
              color: Color(0xffC2C2C2),
            ),
            selectedLabelStyle:
                GoogleFonts.cairo(fontWeight: FontWeight.w600, height: 2),
            unselectedLabelStyle:
                GoogleFonts.cairo(fontWeight: FontWeight.w400, height: 2),
            selectedFontSize: 10,
            unselectedFontSize: 10,
            items: const [
              BottomNavigationBarItem(
                activeIcon: ImageIcon(
                  AssetImage('images/home.png'),
                  size: 20,
                ),
                icon: ImageIcon(
                  AssetImage('images/home.png'),
                  size: 18,
                ),
                label: "الرئيسية",
              ),
              BottomNavigationBarItem(
                activeIcon:
                    ImageIcon(AssetImage('images/mycourse.png'), size: 20),
                icon: ImageIcon(
                  AssetImage('images/mycourse.png'),
                  size: 18,
                ),
                label: "موادي",
              ),
              BottomNavigationBarItem(
                activeIcon:
                    ImageIcon(AssetImage('images/download.png'), size: 20),
                icon: ImageIcon(
                  AssetImage('images/download.png'),
                  size: 18,
                ),
                label: "التحميلات",
              ),
              BottomNavigationBarItem(
                activeIcon:
                    ImageIcon(AssetImage('images/ProfileIcon.png'), size: 20),
                icon: ImageIcon(
                  AssetImage('images/ProfileIcon.png'),
                  size: 18,
                ),
                label: "الملف الشخصي",
              ),
            ],
          ),
        ));
  }
}
