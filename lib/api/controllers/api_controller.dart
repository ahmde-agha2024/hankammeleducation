import 'dart:convert';
import 'dart:io';

import 'package:shamssgazaa/api/api_helper.dart';
import 'package:shamssgazaa/api/api_settings.dart';
import 'package:shamssgazaa/model/about.dart';
import 'package:shamssgazaa/model/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:shamssgazaa/model/book_list.dart';
import 'package:shamssgazaa/model/home.dart';
import 'package:shamssgazaa/model/privacypolicy.dart';
import 'package:shamssgazaa/model/subcategory.dart';
import 'package:shamssgazaa/pref/shared_pref_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiController with ApiHelper {
  Future<DataResponse> getPrivacyPolicy() async {
    Uri uri = Uri.parse(ApiSettings.privacyPolicy);
    var response = await http.get(uri, headers: headres);
    var jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var data = jsonResponse['data'];
      return DataResponse.fromJson(data);
    } else {
      return throw Exception('حدث خطأ ما , حاول مرة أخرى ');
    }
  }

  Future<DataResponse> getTermsAndConditions() async {
    Uri uri = Uri.parse(ApiSettings.termsAndConditions);
    var response = await http.get(uri, headers: headres);
    var jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var data = jsonResponse['data'];
      return DataResponse.fromJson(data);
    } else {
      return throw Exception('حدث خطأ ما , حاول مرة أخرى ');
    }
  }

  Future<DataResponseAbout> getAbout() async {
    Uri uri = Uri.parse(ApiSettings.about);
    var response = await http.get(uri);
    var jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      var data = jsonResponse['data'];
      return DataResponseAbout.fromJson(data);
    } else {
      return throw Exception('حدث خطأ ما , حاول مرة أخرى ');
    }
  }

  Future<bool> deleteAccount({required int id}) async {
    Uri uri = Uri.parse(
        ApiSettings.deleteAccount.replaceFirst('{id}', id.toString()));
    var response = await http.delete(uri, headers: headres);
    if (response.statusCode == 200) {
      SharedPrefController().clear();
      return true;
    } else {
      return false;
    }
  }

  Future<List<HomeModel>> getHome() async {
    Uri uri = Uri.parse(ApiSettings.home);
    var response = await http.get(uri);
    var jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      var data = jsonResponse['data'] as List;
      return data.map((jsonObject) => HomeModel.fromJson(jsonObject)).toList();
    } else {
      return [];
    }
  }

  Future<List<SubCategoryModel>> getSubCategory(
      {required String categoryEqual, required populate}) async {
    Uri uri = Uri.parse(ApiSettings.subCategory
        .replaceFirst('{filters[category][\$eq]=}',
            'filters[category][\$eq]=${categoryEqual.toString()}')
        .replaceFirst('{populate=}', 'populate=${populate.toString()}'));
    var response = await http.get(uri);
    var jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      var data = jsonResponse['data'] as List;
      return data
          .map((jsonObject) => SubCategoryModel.fromJson(jsonObject))
          .toList();
    } else {
      return [];
    }
  }

  Future<List<BookListModel>> getBookList(
      {required String subCategoryEqual, required populate}) async {
    Uri uri = Uri.parse(ApiSettings.bookList
        .replaceFirst('{filters[sub_category][\$eq]=}',
            'filters[sub_category][\$eq]=${subCategoryEqual.toString()}')
        .replaceFirst('{populate=}', 'populate=${populate.toString()}'));
    var response = await http.get(uri, headers: headres);
    var jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      var data = jsonResponse['data'] as List;

      return data
          .map((jsonObject) => BookListModel.fromJson(jsonObject))
          .toList();
    } else {
      return [];
    }
  }

  Future<List<BookListModel>> getAllCourses() async {
    Uri uri = Uri.parse(ApiSettings.bookList
        .replaceFirst('{populate=}', 'populate=*'));
    var response = await http.get(uri, headers: headres);
    var jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      var data = jsonResponse['data'] as List;

      return data
          .map((jsonObject) => BookListModel.fromJson(jsonObject))
          .toList();
    } else {
      return [];
    }
  }

  Future<BookListModel> getCourseDetails({required String documentId}) async {
    Uri uri = Uri.parse(
        ApiSettings.courseDetails.replaceFirst(':documentId', documentId));
    var response = await http.get(uri, headers: headres);
    var jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      var data = jsonResponse['data'];
      print(data);
      return BookListModel.fromJson(data);
    } else {
      return throw Exception('حدث خطأ ما , حاول مرة أخرى ');
    }
  }
}
