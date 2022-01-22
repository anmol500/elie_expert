import 'package:dio/dio.dart';
import 'package:elie_expert/Database/API.dart';
import 'package:elie_expert/Database/Locator.dart';
import 'package:elie_expert/Utils/Colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SOSpage extends StatelessWidget {
  const SOSpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    'Are you in an',
                    style: sosHeadingTextStyle(),
                  ),
                  Text(
                    'emergency',
                    style: sosHeadingTextStyle(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 110,
                        backgroundColor: spAppOrange.withOpacity(0.3),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 100,
                        child: TextButton(
                          onPressed: () async {
                            //overlay with SOS options

                            var name = await API().getExpertByPhone(getItUserIn.userPhone);
                            await Dio().post('http://142.93.212.17:8001/add_sos', data: {
                              "orderId": getItUserIn.userPhone,
                              "sosMessage": "${name!.name} need help! Phone Number: ${name.phone}",
                              "date_time": DateTime.now().toString()
                            });
                            showTopSnackBar(
                              context,
                              CustomSnackBar.info(
                                backgroundColor: spAppOrange,
                                message: "${name.name}'s SOS has been sent to the office",
                              ),
                            );

                            // showMaterialModalBottomSheet(
                            //   context: context,
                            //   builder: (context) => SingleChildScrollView(
                            //     child: Column(
                            //       children: [
                            //         Text(
                            //           "What's your emergency",
                            //           style: sosBottomTextStyle(),
                            //         ),
                            //         ListTile(title: Text('Stuck in traffic')),
                            //         ListTile(title: Text('Getting late')),
                            //         ListTile(title: Text('Call admin')),
                            //         ListTile(title: Text('Not able to go')),
                            //       ],
                            //     ),
                            //   ),
                            // );
                          },
                          child: Text(
                            'SOS',
                            style: TextStyle(fontSize: 60, color: Colors.white),
                          ),
                        ),
                        backgroundColor: spAppOrange,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Container(
            //   margin: EdgeInsets.all(8),
            //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
            //   child: ListTile(
            //     leading: CircleAvatar(),
            //     title: Text('Upcoming Order'),
            //     trailing: Text('12.05 PM'),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}

sosHeadingTextStyle() => TextStyle(color: dimGrey, fontSize: 30, fontWeight: FontWeight.bold);
sosBottomTextStyle() => TextStyle(color: dimGrey, fontSize: 18, fontWeight: FontWeight.bold);
sosAppbarTextStyle() => TextStyle(
      color: dimGrey,
      fontSize: 18,
    );
