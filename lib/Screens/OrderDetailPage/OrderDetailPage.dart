import 'package:dio/dio.dart';
import 'package:elie_expert/Database/Order.dart';
import 'package:elie_expert/Database/Service.dart';
import 'package:elie_expert/Screens/OrderDetailPage/OrderMap.dart';
import 'package:elie_expert/Screens/OrderDetailPage/Widgets/TimerApp.dart';
import 'package:elie_expert/Utils/Colors.dart';
import 'package:elie_expert/Utils/CustomButtons.dart';
import 'package:elie_expert/Utils/rating_dialog.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({Key? key, required this.service, required this.order}) : super(key: key);
  final Services service;
  final Order order;

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  var lat;
  var long;
  bool isActive = false;
  bool pressed = false;
  bool done = false;

  @override
  Widget build(BuildContext context) {
    try {
      lat = double.parse(widget.order.latlong['latitude'] ?? 18.552238);
      long = double.parse(widget.order.latlong['longitude'] ?? 73.8881713);
    } catch (e) {
      print(e);
    }
    TextEditingController descCont = TextEditingController();
    var rateDia = RatingDialog(
      commentController: descCont,
      initialRating: 1.0,
      // your app's name?
      title: Text(
        'Rate your Customer',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 25,
          color: highLcolorDark,
          fontWeight: FontWeight.bold,
        ),
      ),
      // encourage your user to leave a high rating?
      message: Text(
        'order #${widget.order.orderId}',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, color: highLcolorLight),
      ),
      // logo
      image: '$baseUrl/getServiceImageByID/${widget.service.id}',
      submitButtonText: 'Submit',
      submitButtonTextStyle: TextStyle(color: highLcolor, fontSize: 18),
      commentHint: 'Tell us about your experience',

      onCancelled: () => print('cancelled'),
      onSubmitted: (response) async {
        print('rating: ${response.rating}, comment: ${response.comment}');

        showTopSnackBar(
          context,
          CustomSnackBar.success(
            backgroundColor: highLcolor,
            message: "Thank you for your feedback",
          ),
        );
      },
    );
    return Scaffold(
      backgroundColor: midBlack,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: OrderMap(
              lat ?? 18.552238,
              long ?? 73.8881713,
            )),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Booking Details',
                        style: TextStyle(fontSize: 25, color: highLcolor),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Order #${widget.order.orderId}',
                        style: TextStyle(fontSize: 16, color: highLcolor),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Color(0xff0F0F0F),
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        border: Border.all(
                          color: highLcolorLight,
                        ),
                      ),
                      child: Row(
                        children: [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Image.network("$baseUrl/getServiceImageByID/${widget.service.id}"),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: ListTile(
                                      title: Text(
                                        widget.service.name,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Time: ${widget.order.time}",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "At ${widget.order.location}",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            flex: 8,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    isActive || done ? TimerApp(isActive) : Container(),
                    done
                        ? Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Center(
                                child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    'Service Ended Successfully',
                                    style: TextStyle(fontSize: 18, color: Colors.white),
                                  ),
                                ),
                                Text(
                                  'Rate Your Customer',
                                  style: TextStyle(fontSize: 18, color: Colors.white70),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                BackgroundImageButton(
                                  onPress: () {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: true, // set to false if you want to force a rating
                                        builder: (context) => rateDia);
                                  },
                                  title: 'Give Review',
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: highLcolor,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Back to Orders',
                                      style: TextStyle(fontSize: 18, color: Colors.black),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                          )
                        : Row(
                            children: [
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 50,
                                  child: BackgroundImageButton(
                                    onPress: isActive
                                        ? null
                                        : () async {
                                            await Dio().put('$baseUrl/button_startTime/${widget.order.orderId}');
                                            setState(() {
                                              isActive = !isActive;
                                            });
                                          },
                                    title: isActive ? 'Service Started' : 'Start Service',
                                  ),
                                ),
                              )),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 50,
                                  child: BorderRadiusButton(
                                    onPress: !isActive
                                        ? null
                                        : () async {
                                            setState(() {
                                              pressed = true;
                                            });
                                            await Dio().put('$baseUrl/button_endTime/${widget.order.orderId}');
                                            setState(() {
                                              isActive = !isActive;
                                              done = true;
                                            });
                                          },
                                    title: pressed ? "Ending..." : 'End Service',
                                  ),
                                ),
                              )),
                            ],
                          )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
