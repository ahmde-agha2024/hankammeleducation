import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hankammeleducation/api/controllers/api_controller.dart';
import 'package:hankammeleducation/model/book_list.dart';
import 'package:shimmer/shimmer.dart';

// صفحة البحث
class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  bool _isLoading = false;

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
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("Failed to fetch data: $error"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Courses"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _gradeController,
              decoration: InputDecoration(
                labelText: "Grade (e.g., 2)",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Search by course title",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            _isLoading
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 40),
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 5.0,
                          mainAxisSpacing: 5.0,
                        ),
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : ElevatedButton(
                    onPressed: _performSearch,
                    child: Text(
                      "بحث",
                      style: GoogleFonts.cairo(),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

// صفحة النتائج
class ResultsPage extends StatelessWidget {
  final List<BookListModel> results;

  ResultsPage({required this.results});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'نتيجة البحث',
          style: GoogleFonts.cairo(
              color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ),
      body: results.isEmpty
          ? Center(
              child: Text(
              "عذرًا، لم نجد ما تبحث عنه!",
              style:
                  GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 10),
            ))
          : ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final course = results[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.white,
                    child: ListTile(
                      onTap: () {
                        print(course.documentId);
                      },
                      title: Text(
                        course.title!,
                        style: GoogleFonts.cairo(
                            fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        course.subTitle!,
                        style: GoogleFonts.cairo(
                            fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        course.courseFlag!,
                        style: GoogleFonts.cairo(
                            fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
