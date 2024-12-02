import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shamssgazaa/api/controllers/api_controller.dart';
import 'package:shamssgazaa/shimmer/shimmer_book_list.dart';
import 'package:shimmer/shimmer.dart';

import '../model/privacypolicy.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({super.key});

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 40),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: FutureBuilder<DataResponse>(
                future: ApiController().getTermsAndConditions(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          height: 800,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            children: [
                              // أيقونة القفل
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Icon(Icons.lock,
                                    color: Colors.grey[400], size: 30),
                              ),
                              // النصوص (العنوان والتفاصيل)
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 150,
                                    height: 16,
                                    color: Colors.grey[300],
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                    width: 100,
                                    height: 12,
                                    color: Colors.grey[300],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    return HtmlWidget(
                      snapshot.data!.content
                      // onErrorBuilder: (context, element, error) =>
                      //     Text('$element error: $error'),
                      ,
                      onLoadingBuilder: (context, element, loadingProgress) =>
                          Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            height: 800,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              children: [
                                // أيقونة القفل
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Icon(Icons.lock,
                                      color: Colors.grey[400], size: 30),
                                ),
                                // النصوص (العنوان والتفاصيل)
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 150,
                                      height: 16,
                                      color: Colors.grey[300],
                                    ),
                                    SizedBox(height: 8),
                                    Container(
                                      width: 100,
                                      height: 12,
                                      color: Colors.grey[300],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      renderMode: RenderMode.column,
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
          ),
        ),
      ),
    );
  }
}
