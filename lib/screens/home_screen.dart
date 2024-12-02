import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shamssgazaa/api/controllers/api_controller.dart';
import 'package:shamssgazaa/model/home.dart';
import 'package:shamssgazaa/pref/shared_pref_controller.dart';
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
  bool isConnected = false;

  @override
  void initState() {
    // TODO: implement initState
    checkInternetConnection();
    super.initState();
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
                  onPressed: () {},
                  icon: Image.asset(
                    width: 35,
                    height: 35,
                    'images/notificationcomplete 1.png',
                  )),
              IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {},
                  icon: Image.asset(
                    width: 35,
                    height: 35,
                    'images/searchComplete.png',
                  )),
              Spacer(),
              Align(
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
            future: ApiController().getHome(),
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
                    snapshot.error.toString(),
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
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty){
      setState(() {
        isConnected = true;

      });
    }else{
      setState(() {
        isConnected = false;

      });
    }
  }
}
