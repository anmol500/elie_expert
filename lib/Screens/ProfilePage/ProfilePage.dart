import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:elie_expert/Database/Locator.dart';
import 'package:elie_expert/LoginRegis/CustomButtons.dart';
import 'package:elie_expert/LoginRegis/Widgets/CustomTextField.dart';
import 'package:elie_expert/LoginRegis/login.dart';
import 'package:elie_expert/Utils/Colors.dart';
import 'package:elie_expert/Utils/Pincode.dart';
import 'package:elie_expert/Utils/TextFieldWidget_BottomLine.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/dialog/mult_select_dialog.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Utils/ExpertiseList.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController name = TextEditingController();
  TextEditingController nickname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController period = TextEditingController();
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

  var image;
  var imageAadhar1;
  var imageAadhar2;
  var imagePan;
  var portfolio;
  final _formKey = GlobalKey<FormState>();
  var expert;
  var periodDate;
  var loading = true;
  var totalTips;
  var totalCommission;
  var rating;

  List listOfImage = [];
  List tempList = [];
  List<Widget> images = [];
  List imagesB = [];
  List<Widget> portfolioImages = [];

  setList(image) {
    this.tempList.add(image);
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
      print(d);
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

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('ppp' + prefs.get("userPhone").toString());
    expert = await (await Dio().get('$baseUrl/get_expert_phone/${prefs.get("userPhone").toString()}')).data;

    for (var d in expert['experience']) {
      Uint8List tt = Uint8List.fromList(
          (await NetworkAssetBundle(Uri.parse('$baseUrl/get_single_expert_photo/$d')).load('$baseUrl/get_single_expert_photo/$d'))
              .buffer
              .asUint8List());

      setList(PortfolioImage(tt));
      addImage();
    }
    print(expert);
    name.text = expert['name'].toString();
    nickname.text = expert['nickname'].toString();
    email.text = expert['email'].toString();
    age.text = expert['age'].toString();
    phone.text = expert['phone'].toString();
    gender = expert['sex'].toString();
    pass.text = expert['password'].toString();
    cpass.text = expert['password'].toString();
    pan.text = expert['panNo'].toString();
    aadhar.text = expert['aadharNo'].toString();
    qualification.text = expert['qualification'].toString();
    bankName.text = expert['bankAccountName'].toString();
    accountNumber.text = expert['bankAccountNumber'].toString();
    ifsc.text = expert['bankAccountIfsc'].toString();
    experienceYear.text = expert['yearsOfExperience'].toInt().toString();
    expertise.text = expert['serviceList'].toString().substring(1, expert['serviceList'].toString().length - 1);
    address.text = expert['address'].toString();
    // qualification.text = expert['qualification'].toString();
    employee = expert['isEmployee'] ? 'Employee' : 'Freelance';
    serviceablePin.text = expert['serviceablePins'].toString().substring(1, expert['serviceablePins'].toString().length - 1);
    vehicle = expert['vehicle'];
    totalTips = expert['totalTips'];
    totalCommission = expert['totalCommission'];
    rating = expert['averageRating'];

    setState(() {
      loading = false;
    });
  }

  var visible = false;
  passwordShow() {
    setState(() {
      visible = !visible;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: midBlack,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: loading
              ? Center(
                  child: CircularProgressIndicator(
                  color: highLcolorLight,
                ))
              : Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () async {
                                FilePickerResult? result = await FilePicker.platform.pickFiles(withData: true, type: FileType.image);

                                if (result != null) {
                                  image = result.files.single;
                                  setState(() {});
                                } else {
                                  // User canceled the picker
                                }
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100.0),
                                child: Image.network('$baseUrl/getExpertProfilePic/${phone.text}', height: 150, width: 150, fit: BoxFit.fill,
                                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  );
                                }, errorBuilder: (a, b, c) {
                                  print('imagesss' + image.toString());
                                  return image != null
                                      ? Image.memory(
                                          image.bytes,
                                          height: 150,
                                          width: 150,
                                          fit: BoxFit.fill,
                                        )
                                      : CircleAvatar(
                                          child: Text('DP'),
                                          radius: 60,
                                          backgroundColor: dimGrey,
                                        );
                                }),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            employee == 'Freelance'
                                ? Column(
                                    children: [
                                      Text(
                                        'Total Earning',
                                        style: TextStyle(color: highLcolorDark),
                                      ),
                                      Text(
                                        'Rs. $totalCommission',
                                        style: TextStyle(fontSize: 35, color: highLcolor),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  )
                                : Container(),
                            Text(
                              'Total Tips Received',
                              style: TextStyle(color: highLcolorDark),
                            ),
                            Text(
                              'Rs. $totalTips',
                              style: TextStyle(fontSize: 25, color: highLcolor),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Average Rating',
                              style: TextStyle(color: highLcolor),
                            ),
                            Text(
                              '$rating stars',
                              style: TextStyle(color: highLcolorLight),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            customTextField('Expert\'s Name', TextInputType.name, name, mandate: true),
                            customTextField('Nickname', TextInputType.name, nickname),
                            customTextField('Email', TextInputType.emailAddress, email, mandate: true),
                            customTextField('Password', TextInputType.visiblePassword, pass,
                                mandate: true, onSuffixPress: passwordShow, visible: visible),
                            customTextField('Experts Aadhar Number', TextInputType.number, aadhar, mandate: true),
                            customTextField('Experts Pan', TextInputType.name, pan, mandate: true),
                            customTextField('Expert\'s Address', TextInputType.streetAddress, address, line: 3, mandate: true),
                            customTextField('Expert\'s Bank Name', TextInputType.name, bankName, mandate: true),
                            customTextField('Expert\'s Account Number', TextInputType.number, accountNumber, mandate: true),
                            customTextField('Expert\'s Bank IFSC', TextInputType.name, ifsc, ifsc: true, mandate: true),
                            customTextField('Expert\'s Latest Qualification', TextInputType.name, qualification),
                            customTextField('How Many Years Of Experience Do You Have?', TextInputType.number, experienceYear),
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
                            gender == 'Female'
                                ? Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: TextFieldWidgetBottomLine(
                                      mandatory: false,
                                      controller: period,
                                      textColor: Colors.white,
                                      inputType: TextInputType.none,
                                      labelText: 'Last Period Date',
                                      hintText: 'Click to pick a date',
                                      enableBorderColor: Color(0xffFFA075),
                                      focusBorderColor: Color(0xffFFA075),
                                      onPress: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            backgroundColor: Color(0xff141414),
                                            title: Text(
                                              'Choose Estimated Date',
                                              style: TextStyle(
                                                color: highLcolor,
                                                fontSize: 20.0,
                                                fontFamily: 'tex',
                                              ),
                                            ),
                                            content: Container(
                                              height: screenSize.height / 2.0,
                                              width: 400.0,
                                              child: Theme(
                                                data: ThemeData(brightness: Brightness.dark),
                                                child: SfDateRangePicker(
                                                  backgroundColor: Colors.black,
                                                  selectionTextStyle: TextStyle(fontSize: 15.0, color: Colors.white),
                                                  selectionColor: highLcolor,
                                                  todayHighlightColor: highLcolorLight,
                                                  selectionRadius: 90.0,
                                                  selectionShape: DateRangePickerSelectionShape.rectangle,
                                                  headerHeight: 100.0,
                                                  headerStyle: DateRangePickerHeaderStyle(
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  showNavigationArrow: true,
                                                  monthCellStyle: DateRangePickerMonthCellStyle(
                                                    textStyle: TextStyle(fontFamily: "tex", color: Colors.white, fontSize: 16.0),
                                                    disabledDatesTextStyle: TextStyle(fontStyle: FontStyle.normal, color: Colors.white),
                                                  ),
                                                  allowViewNavigation: true,
                                                  onSelectionChanged: (value) {
                                                    periodDate = value.value;
                                                    period.text = DateFormat('dd, MMMM yyyy').format(value.value).toString();
                                                  },
                                                ),
                                              ),
                                            ),
                                            actions: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: OutlinedButton(
                                                      style: OutlinedButton.styleFrom(
                                                        backgroundColor: Color(0xff141414),
                                                        side: BorderSide(
                                                          color: highLcolor,
                                                          width: 1.0,
                                                        ),
                                                        primary: highLcolor,
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10.0),
                                                        child: Text(
                                                          'Cancel',
                                                          style: TextStyle(color: Colors.white, fontSize: 14.0, fontFamily: 'tex'),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: OutlinedButton(
                                                      style: OutlinedButton.styleFrom(
                                                        backgroundColor: Color(0xff141414),
                                                        side: BorderSide(
                                                          color: highLcolor,
                                                          width: 1.0,
                                                        ),
                                                        primary: highLcolor,
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 10.0),
                                                        child: Text(
                                                          'Confirm',
                                                          style: TextStyle(color: Colors.white, fontSize: 14.0, fontFamily: 'tex'),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : Container(),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: BorderRadiusButton(
                                title: imageAadhar1 == null ? 'Update Your Aadhar Front' : 'Aadhar Front:' + imageAadhar1.name,
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
                                title: imageAadhar2 == null ? 'Update Your Aadhar Back' : 'Aadhar Back:' + imageAadhar2.name,
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
                                title: imagePan == null ? 'Update Your PAN' : imagePan.name,
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
                                title: portfolio == null ? 'Update Your Resume in PDF' : portfolio.name,
                                onPress: () async {
                                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: ['pdf'],
                                  );

                                  if (result != null) {
                                    portfolio = result.files.single;
                                    setState(() {});
                                  } else {
                                    // User canceled the picker
                                  }
                                },
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    FilePickerResult? result =
                                        await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: true, withData: true);

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
                                title: 'Update',
                                onPress: () async {
                                  btnLoad = true;
                                  setState(() {});
                                  print(_formKey.currentState!.validate());
                                  if (_formKey.currentState!.validate()) {
                                    var ref = (await Dio().get('$baseUrl/get_expert_phone/${int.parse(phone.text)}')).data;
                                    if (ref != null) {
                                      await Dio().put('$baseUrl/update_expert', data: {
                                        "name": name.text,
                                        "nickname": nickname.text,
                                        "sex": gender,
                                        "age": int.parse(age.text.isEmpty ? '0' : age.text),
                                        "isEmployee": employee == "Freelance" ? false : true,
                                        "phone": int.parse(phone.text.isEmpty ? '0' : phone.text),
                                        "email": email.text,
                                        "password": pass.text,
                                        "yearsOfExperience": int.parse(experienceYear.text),
                                        'qualification': qualification.text,
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
                                      });

                                      if (gender == 'Female' && period.text.isNotEmpty) {
                                        await Dio().put('$baseUrl/add_period/${phone.text}',
                                            queryParameters: {'thedatetime': DateFormat('dd, MMMM yyyy').parse(period.text)});
                                      }

                                      if (image != null) {
                                        await Dio().post('$baseUrl/addExpertProfilePic/${phone.text}', data: image.bytes);
                                      }
                                      if (imagePan != null) {
                                        await Dio().post('$baseUrl/add_expert_pan/${phone.text}', data: imagePan.bytes);
                                      }
                                      if (imageAadhar1 != null && imageAadhar2 != null) {
                                        await Dio().post('$baseUrl/add_expert_aadhar/${phone.text}', data: [imageAadhar1.bytes, imageAadhar2.bytes]);
                                      }

                                      if (portfolio != null) {
                                        await Dio().post('$baseUrl/add_expert_resume/${phone.text}', data: portfolio.bytes);
                                      }
                                      if (imagesB.isNotEmpty) {
                                        await Dio().post('$baseUrl/add_expert_experience/${phone.text}', data: imagesB);
                                      }
                                      getData();
                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                      int userPhone = int.parse(phone.text);
                                      prefs.setInt("userPhone", userPhone);
                                      prefs.setString("userPass", pass.text);

                                      prefs.setString("userName", '');
                                      prefs.setString("userEmail", '');
                                      getItUserIn.setUserIn(
                                          prefs.get("userPhone"), prefs.get("userPass"), prefs.get("userName"), prefs.get('userEmail'));

                                      print(prefs.get("userName"));
                                      showTopSnackBar(
                                          context,
                                          CustomSnackBar.success(
                                            backgroundColor: Colors.green,
                                            message: "Updated",
                                          ),
                                          displayDuration: Duration(milliseconds: 500));
                                      btnLoad = false;
                                      setState(() {});
                                    } else {
                                      showTopSnackBar(
                                        context,
                                        CustomSnackBar.info(
                                          backgroundColor: highLcolor,
                                          message: "${int.parse(phone.text)} is not already registered",
                                        ),
                                      );
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
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: BorderRadiusButton(
                                title: 'LogOut',
                                onPress: () async {
                                  showTopSnackBar(
                                      context,
                                      CustomSnackBar.info(
                                        backgroundColor: highLcolorDark,
                                        message: "You are logged out",
                                      ),
                                      displayDuration: Duration(milliseconds: 500));
                                  SharedPreferences preferences = await SharedPreferences.getInstance();
                                  await preferences.clear();
                                  Navigator.pop(context);
                                  Navigator.push((context), MaterialPageRoute(builder: (context) => LoginPage()));
                                },
                              ),
                            ),
                            SizedBox(
                              height: 5,
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

class PortfolioImage {
  PortfolioImage(this.bytes);

  final bytes;
}
