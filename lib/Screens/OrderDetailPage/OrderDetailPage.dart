import 'package:dio/dio.dart';
import 'package:elie_expert/Database/Order.dart';
import 'package:elie_expert/Database/Service.dart';
import 'package:elie_expert/Screens/OrderDetailPage/OrderMap.dart';
import 'package:elie_expert/Screens/OrderDetailPage/Widgets/TimerApp.dart';
import 'package:elie_expert/Utils/Colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  bool done = false;

  @override
  Widget build(BuildContext context) {
    try {
      lat = double.parse(widget.order.latlong['latitude'] ?? 18.552238);
      long = double.parse(widget.order.latlong['longitude'] ?? 73.8881713);
    } catch (e) {
      print(e);
    }
    return Scaffold(
      backgroundColor: whiteSmoke,
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
              padding: const EdgeInsets.only(top: 20, bottom: 5),
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Booking Details',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      'Order #${widget.order.orderId}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Container(
                      height: 100,
                      color: Colors.white,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: ListTile(
                                    title: Text(widget.service.name),
                                    subtitle: Text("At ${widget.order.time}"),
                                  ),
                                ),
                              ],
                            ),
                            flex: 8,
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Image.network("http://142.93.212.17:8001/getServiceImageByID/${widget.service.id}"),
                            ),
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
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: spAppOrange,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Back to Orders',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                )
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
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(primary: Colors.pink),
                                    onPressed: isActive
                                        ? null
                                        : () async {
                                            await Dio().put('http://142.93.212.17:8001/button_startTime/${widget.order.orderId}');
                                            setState(() {
                                              isActive = !isActive;
                                            });
                                          },
                                    child: Text(isActive ? 'Service Started' : 'Start Service'),
                                  ),
                                ),
                              )),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(primary: spAppOrange),
                                    onPressed: !isActive
                                        ? null
                                        : () async {
                                            await Dio().put('http://142.93.212.17:8001/button_endTime/${widget.order.orderId}');
                                            setState(() {
                                              isActive = !isActive;
                                              done = true;
                                            });
                                          },
                                    child: Text('End Service'),
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
