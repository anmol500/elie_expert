import 'package:dio/dio.dart';
import 'package:elie_expert/Database/Locator.dart';
import 'package:elie_expert/Screens/Home/HomePage.dart';
import 'package:elie_expert/Utils/Colors.dart';
import 'package:elie_expert/Utils/Pincode.dart';
import 'package:elie_expert/Utils/TextFieldWidget_BottomLine.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/mult_select_dialog.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Utils/ExpertiseList.dart';
import 'CustomButtons.dart';
import 'Widgets/CustomTextField.dart';
import 'login.dart';

class Registeration extends StatefulWidget {
  Registeration({Key? key}) : super(key: key);
  @override
  _RegisterationState createState() => _RegisterationState();
}

class _RegisterationState extends State<Registeration> {
  TextEditingController name = TextEditingController();
  TextEditingController nickname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController cpass = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController pan = TextEditingController();
  TextEditingController aadhar = TextEditingController();
  TextEditingController bankName = TextEditingController();
  TextEditingController accountNumber = TextEditingController();
  TextEditingController ifsc = TextEditingController();
  TextEditingController experienceYear = TextEditingController();
  TextEditingController expertise = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController qualification = TextEditingController();
  TextEditingController serviceablePin = TextEditingController();
  TextEditingController vehicleNo = TextEditingController();
  bool btnLoad = false;

  String? gender;
  List listItems = ['Male', 'Female', 'Rather Not Say'];
  String? employee;
  List listsItems = ['Employee', 'Freelance'];
  String? vehicle;
  List vehicleList = ['2-Wheeler', '4-Wheeler', 'No'];
  var visible = false;
  var visible2 = false;
  var image;
  var imageAadhar1;
  var imageAadhar2;
  var imagePan;
  var resume;

  List listOfImage = [];
  List tempList = [];
  List<Widget> images = [];
  List imagesB = [];

  setList(image) {
    this.tempList = image;
  }

  passwordShow() {
    setState(() {
      visible = !visible;
    });
  }

  passwordShow2() {
    setState(() {
      visible2 = !visible2;
    });
  }

  addImage() {
    images = [];
    imagesB = [];
    List list = [];
    list = listOfImage;
    listOfImage = [];

    list = list + tempList;
    print(list.length);
    var value = 0;
    for (var d in list) {
      int i = value;
      images.add(InkWell(
        onTap: () {
          print(i);
          listOfImage.removeAt(i);

          addImage();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.memory(
            d.bytes,
            fit: BoxFit.cover,
          ),
        ),
      ));
      imagesB.add(d.bytes);
      value = value + 1;
    }

    listOfImage = list;
    tempList = [];
    list = [];
    setState(() {});
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: midBlack,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/logo.jpg',
                height: 60,
                width: 104,
              ),
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.black,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  customTextField('Expert\'s Name', TextInputType.name, name, mandate: true),
                  customTextField('Nickname', TextInputType.name, nickname),
                  customTextField('Expert\'s Phone Number', TextInputType.number, phone, mandate: true),
                  customTextField('Email', TextInputType.emailAddress, email, mandate: true),
                  customTextField('Password', TextInputType.visiblePassword, pass, onSuffixPress: passwordShow, visible: visible, mandate: true),
                  customTextField('Confirm Password', TextInputType.visiblePassword, cpass,
                      onSuffixPress: passwordShow2, visible: visible2, mandate: true),
                  customTextField('Experts Aadhar Number', TextInputType.number, aadhar, mandate: true),
                  customTextField('Experts Pan', TextInputType.name, pan, mandate: true),
                  customTextField('Expert\'s Address', TextInputType.streetAddress, address, line: 3, mandate: true),
                  customTextField('Expert\'s Bank Name', TextInputType.name, bankName, mandate: true),
                  customTextField('Expert\'s Account Number', TextInputType.number, accountNumber, mandate: true),
                  customTextField('Expert\'s Bank IFSC', TextInputType.name, ifsc, ifsc: true, mandate: true),
                  customTextField('Expert\'s Latest Qualification', TextInputType.name, qualification),
                  customTextField('How Many Years Of Experience Do You Have?', TextInputType.number, experienceYear),
                  // Padding(
                  //   padding: const EdgeInsets.all(10.0),
                  //   child: TextFieldWidgetBottomLine(
                  //     controller: dob,
                  //     textColor: Colors.white,
                  //     inputType: TextInputType.none,
                  //     labelText: 'Your Birth Date',
                  //     hintText: 'Click to pick a date',
                  //     enableBorderColor: Color(0xffFFA075),
                  //     focusBorderColor: Color(0xffFFA075),
                  //     onPress: () {
                  //       showDialog(
                  //         context: context,
                  //         builder: (context) => AlertDialog(
                  //           backgroundColor: Color(0xff141414),
                  //           title: Text(
                  //             'Choose Your Birth Date',
                  //             style: TextStyle(
                  //               color: highLcolor,
                  //               fontSize: 20.0,
                  //               fontFamily: 'tex',
                  //             ),
                  //           ),
                  //           content: Container(
                  //             height: screenSize.height / 2.0,
                  //             width: 400.0,
                  //             child: Theme(
                  //               data: ThemeData(brightness: Brightness.dark),
                  //               child: SfDateRangePicker(
                  //                 backgroundColor: Colors.black,
                  //                 selectionTextStyle: TextStyle(fontSize: 15.0, color: Colors.white),
                  //                 selectionColor: highLcolor,
                  //                 todayHighlightColor: highLcolorLight,
                  //                 selectionRadius: 90.0,
                  //                 selectionShape: DateRangePickerSelectionShape.rectangle,
                  //                 headerHeight: 100.0,
                  //                 headerStyle: DateRangePickerHeaderStyle(
                  //                   textAlign: TextAlign.center,
                  //                 ),
                  //                 showNavigationArrow: true,
                  //                 monthCellStyle: DateRangePickerMonthCellStyle(
                  //                   textStyle: TextStyle(fontFamily: "tex", color: Colors.white, fontSize: 16.0),
                  //                   disabledDatesTextStyle: TextStyle(fontStyle: FontStyle.normal, color: Colors.white),
                  //                 ),
                  //                 allowViewNavigation: true,
                  //                 onSelectionChanged: (value) {
                  //                   dob.text = DateFormat('dd, MMMM yyyy').format(value.value).toString();
                  //                 },
                  //               ),
                  //             ),
                  //           ),
                  //           actions: [
                  //             Row(
                  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //               children: [
                  //                 Expanded(
                  //                   child: OutlinedButton(
                  //                     style: OutlinedButton.styleFrom(
                  //                       backgroundColor: Color(0xff141414),
                  //                       side: BorderSide(
                  //                         color: highLcolor,
                  //                         width: 1.0,
                  //                       ),
                  //                       primary: highLcolor,
                  //                     ),
                  //                     child: Padding(
                  //                       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10.0),
                  //                       child: Text(
                  //                         'Cancel',
                  //                         style: TextStyle(color: Colors.white, fontSize: 14.0, fontFamily: 'tex'),
                  //                       ),
                  //                     ),
                  //                     onPressed: () {
                  //                       Navigator.of(context).pop();
                  //                     },
                  //                   ),
                  //                 ),
                  //                 Expanded(
                  //                   child: OutlinedButton(
                  //                     style: OutlinedButton.styleFrom(
                  //                       backgroundColor: Color(0xff141414),
                  //                       side: BorderSide(
                  //                         color: highLcolor,
                  //                         width: 1.0,
                  //                       ),
                  //                       primary: highLcolor,
                  //                     ),
                  //                     child: Padding(
                  //                       padding: EdgeInsets.symmetric(horizontal: 4, vertical: 10.0),
                  //                       child: Text(
                  //                         'Confirm',
                  //                         style: TextStyle(color: Colors.white, fontSize: 14.0, fontFamily: 'tex'),
                  //                       ),
                  //                     ),
                  //                     onPressed: () {
                  //                       Navigator.pop(context);
                  //                     },
                  //                   ),
                  //                 ),
                  //               ],
                  //             )
                  //           ],
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                  customTextField('Age', TextInputType.number, age, mandate: true),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      height: 60,
                      width: 325,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xDEB6A2).withOpacity(1),
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12, right: 20),
                        child: DropdownButton<String>(
                          hint: Container(
                            child: Text(
                              'Choose your Gender',
                              style: TextStyle(color: Color(0xDEB6A2).withOpacity(1)),
                            ),
                          ),
                          dropdownColor: Colors.black,
                          icon: Container(
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(0xDEB6A2).withOpacity(1),
                            ),
                          ),
                          iconSize: 36,
                          isExpanded: true,
                          underline: SizedBox(),
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xDEB6A2).withOpacity(1),
                          ),
                          value: gender,
                          onChanged: (newValue) {
                            setState(() {
                              gender = newValue!;
                            });
                          },
                          items: listItems.map<DropdownMenuItem<String>>(
                            (valueItem) {
                              return DropdownMenuItem<String>(
                                value: valueItem,
                                child: Text(valueItem),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFieldWidgetBottomLine(
                      controller: serviceablePin,
                      textColor: Color(0xDEB6A2).withOpacity(1),
                      inputType: TextInputType.none,
                      labelText: 'List Your Serviceable Pincodes',
                      hintText: 'List Your Serviceable Pincodes',
                      enableBorderColor: Color(0xffFFA075),
                      focusBorderColor: Color(0xffFFA075),
                      onPress: () {
                        showMultiSelectPincodes(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFieldWidgetBottomLine(
                      controller: expertise,
                      textColor: Color(0xDEB6A2).withOpacity(1),
                      inputType: TextInputType.none,
                      labelText: 'Choose Your Expertise',
                      hintText: 'Choose Your Expertise',
                      enableBorderColor: Color(0xffFFA075),
                      focusBorderColor: Color(0xffFFA075),
                      onPress: () {
                        showMultiSelectExpertise(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      height: 60,
                      width: 325,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xDEB6A2).withOpacity(1),
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12, right: 20),
                        child: DropdownButton<String>(
                          hint: Container(
                            child: Text(
                              'Employment Type',
                              style: TextStyle(color: Color(0xDEB6A2).withOpacity(1)),
                            ),
                          ),
                          dropdownColor: Colors.black,
                          icon: Container(
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(0xDEB6A2).withOpacity(1),
                            ),
                          ),
                          iconSize: 36,
                          isExpanded: true,
                          underline: SizedBox(),
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xDEB6A2).withOpacity(1),
                          ),
                          value: employee,
                          onChanged: (newValue) {
                            setState(() {
                              employee = newValue!;
                            });
                          },
                          items: listsItems.map<DropdownMenuItem<String>>(
                            (valueItem) {
                              return DropdownMenuItem<String>(
                                value: valueItem,
                                child: Text(valueItem),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      height: 60,
                      width: 325,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xDEB6A2).withOpacity(1),
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12, right: 20),
                        child: DropdownButton<String>(
                          hint: Container(
                            child: Text(
                              'Do You Own A Vehicle?',
                              style: TextStyle(color: Color(0xDEB6A2).withOpacity(1)),
                            ),
                          ),
                          dropdownColor: Colors.black,
                          icon: Container(
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(0xDEB6A2).withOpacity(1),
                            ),
                          ),
                          iconSize: 36,
                          isExpanded: true,
                          underline: SizedBox(),
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xDEB6A2).withOpacity(1),
                          ),
                          value: vehicle,
                          onChanged: (newValue) {
                            setState(() {
                              vehicle = newValue!;
                            });
                          },
                          items: vehicleList.map<DropdownMenuItem<String>>(
                            (valueItem) {
                              return DropdownMenuItem<String>(
                                value: valueItem,
                                child: Text(valueItem),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                  ),
                  vehicle == '2-Wheeler' || vehicle == '4-Wheeler'
                      ? customTextField('Vehicle Registration No.', TextInputType.text, vehicleNo, mandate: true)
                      : Container(),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BorderRadiusButton(
                      title: image == null ? 'Upload Your Photo' : 'Photo: ' + image.name,
                      onPress: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          withData: true,
                          type: FileType.image,
                        );

                        if (result != null) {
                          image = result.files.single;
                          setState(() {});
                        } else {
                          // User canceled the picker
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BorderRadiusButton(
                      title: imageAadhar1 == null ? 'Upload Your Aadhar Front' : 'Aadhar Front:' + imageAadhar1.name,
                      onPress: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          withData: true,
                          type: FileType.image,
                        );

                        if (result != null) {
                          imageAadhar1 = result.files.single;
                          setState(() {});
                        } else {
                          // User canceled the picker
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BorderRadiusButton(
                      title: imageAadhar2 == null ? 'Upload Your Aadhar Back' : 'Aadhar Back:' + imageAadhar2.name,
                      onPress: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          withData: true,
                          type: FileType.image,
                        );

                        if (result != null) {
                          imageAadhar2 = result.files.single;
                          setState(() {});
                        } else {
                          // User canceled the picker
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BorderRadiusButton(
                      title: imagePan == null ? 'Upload Your PAN' : 'PAN: ' + imagePan.name,
                      onPress: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          withData: true,
                          type: FileType.image,
                        );

                        if (result != null) {
                          imagePan = result.files.single;

                          setState(() {});
                        } else {
                          // User canceled the picker
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BorderRadiusButton(
                      title: resume == null ? 'Upload Your Resume in PDF' : resume.name,
                      onPress: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          withData: true,
                          type: FileType.custom,
                          allowedExtensions: ['pdf'],
                        );

                        if (result != null) {
                          resume = result.files.single;
                          setState(() {});
                        } else {}
                      },
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: true, withData: true);

                          if (result != null) {
                            setList(result.files);
                            addImage();
                          } else {
                            // User canceled the picker
                          }
                          setState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [BoxShadow(color: Colors.grey)],
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              )),
                          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          height: 45,
                          width: 330,
                          child: Center(
                              child: Text(
                            'Choose Photos For Portfolio',
                            style: TextStyle(fontSize: 18),
                          )),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      listOfImage.isEmpty
                          ? Container()
                          : Container(
                              height: 300,
                              width: 330,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: highLcolorDark, width: 1),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(7),
                                    )),
                                child: GridView.count(
                                  scrollDirection: Axis.horizontal,
                                  crossAxisCount: 2,
                                  children: [...images],
                                ),
                              ),
                            )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BackgroundImageButton(
                      btnLoad: btnLoad,
                      title: 'Register',
                      onPress: () async {
                        btnLoad = true;
                        setState(() {});
                        print(_formKey.currentState!.validate());
                        if (_formKey.currentState!.validate()) {
                          if (pass.text != cpass.text) {
                            showTopSnackBar(
                                context,
                                CustomSnackBar.info(
                                  backgroundColor: highLcolor,
                                  message: "Passwords in both fields are not same",
                                ),
                                displayDuration: Duration(milliseconds: 6000));
                            btnLoad = false;
                            setState(() {});
                          } else {
                            var ref = (await Dio().get('$baseUrl/get_expert_phone/${int.parse(phone.text)}')).data;
                            if (ref == null) {
                              showTopSnackBar(
                                  context,
                                  CustomSnackBar.success(
                                    backgroundColor: Colors.green,
                                    message: "This may take a while",
                                  ),
                                  displayDuration: Duration(milliseconds: 500));
                              await Dio().post('$baseUrl/register_expert', data: {
                                "name": name.text,
                                "nickname": nickname.text,
                                "sex": gender,
                                "age": int.parse(age.text.isEmpty ? '0' : age.text),
                                "isEmployee": employee == "Freelancer" ? false : true,
                                "phone": int.parse(phone.text.isEmpty ? '0' : phone.text),
                                "email": email.text,
                                "yearsOfExperience": int.parse(experienceYear.text),
                                'qualification': qualification.text,
                                "password": pass.text,
                                'availability': true,
                                'bankAccountNumber': int.parse(accountNumber.text.isEmpty ? '0' : accountNumber.text),
                                'bankAccountName': bankName.text,
                                'bankAccountIfsc': ifsc.text,
                                'aadharNo': int.parse(aadhar.text.isEmpty ? '0' : aadhar.text),
                                'panNo': pan.text,
                                'address': address.text,
                                'serviceablePins': serviceablePin.text,
                                'serviceList': expertise.text,
                                'vehicle': vehicle,
                                'vehicleNo': vehicleNo.text,
                                'status': "Pending"
                              });

                              if (image != null) {
                                print(image);
                                await Dio().post('$baseUrl/addExpertProfilePic/${phone.text}', data: image.bytes);
                              }
                              if (imagePan != null) {
                                print(imagePan);
                                await Dio().post('$baseUrl/add_expert_pan/${phone.text}', data: imagePan.bytes);
                              }
                              if (imageAadhar1 != null && imageAadhar2 != null) {
                                await Dio().post('$baseUrl/add_expert_aadhar/${phone.text}', data: [imageAadhar1.bytes, imageAadhar2.bytes]);
                              }

                              if (resume != null) {
                                await Dio().post('$baseUrl/add_expert_resume/${phone.text}', data: resume.bytes);
                              }
                              if (imagesB.isNotEmpty) {
                                await Dio().post('$baseUrl/add_expert_experience/${phone.text}', data: imagesB);
                              }

                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              int userPhone = int.parse(phone.text);
                              prefs.setInt("userPhone", userPhone);
                              prefs.setString("userPass", pass.text);

                              prefs.setString("userName", '');
                              prefs.setString("userEmail", '');
                              getItUserIn.setUserIn(prefs.get("userPhone"), prefs.get("userPass"), prefs.get("userName"), prefs.get('userEmail'));

                              print(prefs.get("userName"));
                              Navigator.pop(context);
                              Navigator.push((context), MaterialPageRoute(builder: (context) => HomePage()));
                            } else {
                              showTopSnackBar(
                                  context,
                                  CustomSnackBar.info(
                                    backgroundColor: highLcolor,
                                    message: "${int.parse(phone.text)} is already registered",
                                  ),
                                  displayDuration: Duration(milliseconds: 500));
                              btnLoad = false;
                              setState(() {});
                            }
                          }
                        } else {
                          showTopSnackBar(
                            context,
                            CustomSnackBar.info(
                              backgroundColor: highLcolor,
                              message: "Please Enter All The Required Fields",
                            ),
                          );
                          btnLoad = false;
                          setState(() {});
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        primary: Color(0xDEB6A2).withOpacity(1),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Already have an account?',
                              style: TextStyle(fontSize: 16, color: Color(0xDEB6A2).withOpacity(1), fontFamily: 'PTSans-Regular'),
                            ),
                            TextSpan(
                              text: ' Log in',
                              style: TextStyle(
                                  color: Color(0xDEB6A2).withOpacity(1), fontSize: 16, fontFamily: 'PTSans-Regular', fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TextButton(
                      child: Text(
                        'Privacy Policy',
                        style: TextStyle(color: highLcolor, fontSize: 16),
                      ),
                      onPressed: () async {
                        await launchUrl(Uri.parse('https://elie.world/Policy'));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void showMultiSelectExpertise(
    BuildContext context,
  ) async {
    final item = expertiseList.map((e) => MultiSelectItem(expertiseList.indexOf(e), e)).toList();
    await showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog(
          height: MediaQuery.of(context).size.height / 2,
          items: item,
          initialValue: [],
          onConfirm: (values) {
            expertise.text = '';
            for (var d = 0; d < values.length; d++) {
              print(values[d].toString());
              expertise.text = expertise.text +
                  (expertise.text.isEmpty ? '' : ", ") +
                  expertiseList.elementAt(int.parse(values[d].toString())).toString().toUpperCase();
            }

            setState(() {
              print(expertise.text);
            });
          },
        );
      },
    );
  }

  void showMultiSelectPincodes(
    BuildContext context,
  ) async {
    final item = pinCodes.map((e) => MultiSelectItem(pinCodes.indexOf(e), e)).toList();
    await showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog(
          height: MediaQuery.of(context).size.height / 2,
          items: item,
          initialValue: [],
          onConfirm: (values) {
            serviceablePin.text = '';
            for (var d = 0; d < values.length; d++) {
              print(values[d].toString());
              serviceablePin.text = serviceablePin.text +
                  (serviceablePin.text.isEmpty ? '' : ", ") +
                  pinCodes.elementAt(int.parse(values[d].toString())).toString().toUpperCase();
            }

            setState(() {
              print(serviceablePin.text);
            });
          },
        );
      },
    );
  }
}
