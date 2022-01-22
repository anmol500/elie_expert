import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:dio/dio.dart';
import 'package:elie_expert/Database/API.dart';
import 'package:elie_expert/Database/Locator.dart';
import 'package:elie_expert/Database/Order.dart';
import 'package:elie_expert/Database/Service.dart';
import 'package:elie_expert/Screens/OrderDetailPage/OrderDetailPage.dart';
import 'package:elie_expert/Screens/OrderPage/OrderPageModel.dart';
import 'package:intl/intl.dart';
import 'package:elie_expert/Utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:time_range/time_range.dart';

class AvailabilityPage extends StatefulWidget {
  AvailabilityPage({Key? key}) : super(key: key);

  @override
  State<AvailabilityPage> createState() => _AvailabilityPageState();
}

class _AvailabilityPageState extends State<AvailabilityPage> {
  DateTime selectedDate = DateTime.now();
  DateTime fromTime = DateTime.now();
  DateTime toTime = DateTime.now();
  var loading = true;

  List<Appointment> meetings = [];

  getData() async {
    meetings = [];
    var orders = await OrderPageModel().getOrderByExpert();
    var booking;
    for (Order order in orders) {
      Services service;

      if (order.id != 0) {
        service = await API().getServiceByID(order.serviceId);
        var dateTime = DateFormat("dd/MM/yyyy hh:mm a").parse(order.date + " " + order.time);

        print(order.orderId.toString());
        meetings.add(Appointment(
            startTime: dateTime,
            endTime: dateTime.add(Duration(minutes: service.duration)),
            color: spAppOrange,
            subject: 'Booking',
            id: service.id,
            notes: order.orderId.toString()));
      } else {
        booking = await Dio().get('http://142.93.212.17:8001/get_bookings_expertId/${getItUserIn.userPhone}');
      }
    }
    if (booking != null) {
      for (var d in booking.data) {
        meetings.add(Appointment(
            startTime: DateFormat('yyyy-MM-ddTHH:mm:ss').parse(d['startTime']),
            endTime: DateFormat('yyyy-MM-ddTHH:mm:ss').parse(d['endTime']),
            color: Colors.green,
            subject: 'Leave',
            notes: "Not Available"));
      }
    }
    loading = false;
    print(meetings);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: loading
          ? Center(
              child: CircularProgressIndicator(
                color: spAppOrange,
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: SfCalendar(
                    view: CalendarView.week,
                    onTap: (value) async {
                      Services service = value.appointments![0].id != null
                          ? await API().getServiceByID(value.appointments![0].id)
                          : Services(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

                      Order order = await API().getOrderByOrderId(value.appointments![0].notes);

                      showMaterialModalBottomSheet(
                          context: context,
                          builder: (context) => SingleChildScrollView(
                                child: Container(
                                  color: whiteSmoke,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Booking Detail',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ),
                                        Card(
                                          child: Container(
                                            height: 100,
                                            color: Colors.white,
                                            child: Row(
                                              children: [
                                                Center(
                                                  child: Padding(
                                                    padding: EdgeInsets.all(10),
                                                    child: Image.network("http://142.93.212.17:8001/getServiceImageByID/${service.id}"),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    alignment: Alignment.topLeft,
                                                    child: Column(
                                                      children: [
                                                        Expanded(
                                                          flex: 5,
                                                          child: ListTile(
                                                            title: Text(service.name),
                                                            subtitle: Text("At ${DateFormat("hh:mm a").format(value.appointments![0]?.startTime)}"),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 5,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                            children: [
                                                              SizedBox(
                                                                width: 8,
                                                              ),
                                                              TextButton(
                                                                child: Text("View Details"),
                                                                onPressed: () {
                                                                  Navigator.push(
                                                                      (context),
                                                                      MaterialPageRoute(
                                                                          builder: (context) => OrderDetailPage(service: service, order: order)));
                                                                },
                                                              ),
                                                              SizedBox(
                                                                width: 8,
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  flex: 8,
                                                ),
                                              ],
                                            ),
                                          ),
                                          elevation: 0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ));
                    },
                    initialDisplayDate: DateTime.now(),
                    firstDayOfWeek: 1,
                    timeSlotViewSettings: TimeSlotViewSettings(
                      startHour: 8,
                      endHour: 22,
                    ),
                    dataSource: MeetingDataSource(meetings),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              AvailabilityBottomSelector(context);
                            },
                            child: Text('Select your Off Time'),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          getData();
                        },
                        icon: Icon(
                          Icons.refresh_outlined,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }

  Future<dynamic> AvailabilityBottomSelector(BuildContext context) {
    return showMaterialModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Select when you will be unavailable',
                style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            DatePicker(
              DateTime.now(),
              initialSelectedDate: DateTime.now(),
              selectionColor: Colors.black,
              selectedTextColor: Colors.white,
              onDateChange: (date) {
                // New date selected
                setState(() {
                  selectedDate = date;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: TimeRange(
                fromTitle: Text(
                  'From',
                  style: TextStyle(fontSize: 18, color: dimGrey),
                ),
                toTitle: Text(
                  'To',
                  style: TextStyle(fontSize: 18, color: dimGrey),
                ),
                titlePadding: 20,
                textStyle: TextStyle(fontWeight: FontWeight.normal, color: Colors.black87),
                activeTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                borderColor: Colors.grey,
                backgroundColor: Colors.transparent,
                activeBackgroundColor: spAppOrange,
                firstTime: TimeOfDay(hour: 08, minute: 00),
                lastTime: TimeOfDay(hour: 22, minute: 00),
                timeStep: 10,
                timeBlock: 30,
                onRangeCompleted: (range) => setState(() {
                  var t = range!.start;
                  var e = range.end;
                  var now = selectedDate;
                  fromTime = DateTime(now.year, now.month, now.day, t.hour, t.minute);
                  toTime = DateTime(now.year, now.month, now.day, e.hour, e.minute);
                }),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    print(selectedDate);
                    print(fromTime);
                    await Dio().post("http://142.93.212.17:8001/add_booking", data: {
                      "orderId": '000',
                      "expertId": getItUserIn.userPhone,
                      "startTime": DateFormat('yyyy-MM-ddTHH:mm:ss').format(fromTime),
                      "endTime": DateFormat('yyyy-MM-ddTHH:mm:ss').format(toTime),
                    });
                    Navigator.pop(context);
                    getData();
                  },
                  child: Text('OK'),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}
