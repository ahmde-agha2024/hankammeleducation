import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shamssgazaa/api/controllers/auth_api_controllers.dart';
import 'package:shamssgazaa/model/api_response.dart';
import 'package:shamssgazaa/model/register_user.dart';
import 'package:shamssgazaa/pref/shared_pref_controller.dart';
import 'package:shamssgazaa/screens/auth_screens/verifyPhone_screen.dart';
import 'package:shamssgazaa/utils/helpers.dart';
import 'package:shamssgazaa/widget/code_text_field.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with Helpers {
  late TextEditingController _firstnamecontroller;
  late TextEditingController _familycontroller;
  late TextEditingController _mobilecontroller;

  final List<String> items = [
    'ذكر',
    'أنثى',
  ];
  String? selectedValue;
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firstnamecontroller = TextEditingController();
    _familycontroller = TextEditingController();
    _mobilecontroller = TextEditingController();
    print(SharedPrefController().token);
    print("\n");
    print(SharedPrefController().token);
  }

  @override
  void dispose() {
    _firstnamecontroller.dispose();
    _familycontroller.dispose();
    _mobilecontroller.dispose();

    super.dispose();
  }

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(), // التاريخ الافتراضي الحالي
  //     firstDate: DateTime(2000), // أول تاريخ يمكن اختياره
  //     lastDate: DateTime(2100), // آخر تاريخ يمكن اختياره
  //   );
  //   if (picked != null) {
  //     setState(() {
  //       _birthdaycontroller.text = "${picked.toLocal()}"
  //           .split(' ')[0]; // تحويل التاريخ لنص وعرضه في TextField
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            'تسجيل مستخدم جديد',
            style: GoogleFonts.cairo(
                color: Color(0xff073b4c),
                fontSize: 12,
                fontWeight: FontWeight.bold),
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200,
                width: 200,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'images/thumbnail_Logo.png',
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: TextField(
                  controller: _firstnamecontroller,
                  onChanged: (value) {},
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  //maxLength: 14,
                  style: GoogleFonts.cairo(
                      fontSize: 8, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                      labelText: 'الإسم الأول',
                      //hintText: "أدخل رقم الهاتف مسبوقاً ب (00218)",
                      //hintStyle: GoogleFonts.cairo(fontSize: 8),
                      //counterText: "",
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
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: TextField(
                  controller: _familycontroller,
                  onChanged: (value) {},
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,

                  //maxLength: 14,
                  style: GoogleFonts.cairo(
                      fontSize: 8, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                      labelText: 'اللقب',
                      //hintText: "أدخل رقم الهاتف مسبوقاً ب (00218)",
                      //hintStyle: GoogleFonts.cairo(fontSize: 8),
                      //counterText: "",
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
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: TextField(
                  controller: _mobilecontroller,
                  onChanged: (value) {},
                  keyboardType: TextInputType.phone,
                  maxLength: 14,
                  style: GoogleFonts.cairo(fontSize: 8),
                  decoration: InputDecoration(
                      labelText: 'رقم الموبايل',
                      hintText: "أدخل رقم الموبايل",
                      hintStyle: GoogleFonts.cairo(fontSize: 8),
                      counterText: "",
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
              SizedBox(
                height: 20,
              ),

              // SizedBox(
              //   width: double.infinity,
              //   height: 40,
              //   child: TextField(
              //     controller: _birthdaycontroller,
              //     onChanged: (value) {},
              //     keyboardType: TextInputType.datetime,
              //     //maxLength: 14,
              //     readOnly: true,
              //     onTap: () {
              //       _selectDate(context);
              //     },
              //     style: TextStyle(fontSize: 8),
              //     decoration: InputDecoration(
              //         labelText: 'الجنس',
              //         labelStyle:
              //             GoogleFonts.cairo(fontSize: 8, color: Colors.black54),
              //         enabledBorder: OutlineInputBorder(
              //             borderRadius: BorderRadius.circular(8),
              //             borderSide:
              //                 BorderSide(width: 1, color: Color(0xffef476f))),
              //         focusedBorder: OutlineInputBorder(
              //             borderRadius: BorderRadius.circular(8),
              //             borderSide:
              //                 BorderSide(width: 1, color: Color(0xffef476f)))),
              //   ),
              // ),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    hint: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'الجنس ؟',
                            style: GoogleFonts.cairo(
                              fontSize: 9,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                    items: items
                        .map((String item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: GoogleFonts.cairo(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xffef476f),
                                ),
                                //overflow: TextOverflow.ellipsis,
                              ),
                            ))
                        .toList(),
                    value: selectedValue,
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value;
                      });
                    },
                    buttonStyleData: ButtonStyleData(
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Color(0xffef476f),
                        ),
                        color: Colors.white,
                      ),
                      elevation: 2,
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.arrow_forward_ios_outlined,
                      ),
                      iconSize: 14,
                      iconEnabledColor: Colors.black54,
                      iconDisabledColor: Colors.black54,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      //maxHeight: 200,
                      //width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 40,
                      padding: EdgeInsets.only(left: 14, right: 14),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 20,
              ),
              loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.0,
                        color: Color(0xff073b4c),
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () async => await _performRegister(),
                      child: Text(
                        'تسجيل',
                        style: GoogleFonts.cairo(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10),
                      ),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: const Size(double.infinity, 40),
                          elevation: 0,
                          textStyle: GoogleFonts.cairo(),
                          backgroundColor: Color(0xff073b4c)),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _performRegister() async {
    if (_checkData()) {
      return await _register();
    }
  }

  bool _checkData() {
    if (_firstnamecontroller.text.isNotEmpty &&
        _familycontroller.text.isNotEmpty &&
        _mobilecontroller.text.isNotEmpty &&
        selectedValue!.isNotEmpty) {
      return true;
    }
    showSnackBar(context, message: "أدخل البيانات المطلوبة!", error: true);

    return false;
  }

  Future<void> _register() async {
    setState(() {
      loading = true;
    });
    ApiResponse apiResponse = await AuthApiController().register(user);
    if (apiResponse.success) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => VerifyPhone(
                    phoneNumber: _mobilecontroller.text,
                  )));
    } else {
      setState(() {
        showSnackBar(context,
            message: apiResponse.message, error: !apiResponse.success);
      });
    }
    setState(() {
      loading = false;
    });
  }

  RegisterUser get user {
    RegisterUser user = RegisterUser();
    user.firstName = _firstnamecontroller.text;
    user.lastName = _familycontroller.text;
    user.phoneNumber = _mobilecontroller.text;
    user.gender = selectedValue;
    return user;
  }
}
