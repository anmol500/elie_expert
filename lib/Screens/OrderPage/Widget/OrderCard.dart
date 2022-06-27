import 'package:elie_expert/Database/API.dart';
import 'package:elie_expert/Database/Order.dart';
import 'package:elie_expert/Database/Service.dart';
import 'package:elie_expert/Screens/OrderDetailPage/OrderDetailPage.dart';
import 'package:elie_expert/Utils/Colors.dart';
import 'package:elie_expert/Utils/CustomButtons.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';

//ignore: must_be_immutable
class OrderCard extends StatefulWidget {
  OrderCard({
    Key? key,
    required this.data,
  });
  Order data;

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  late Services service;
  bool loading = false;
  getService() async {
    service = await API().getServiceByID(widget.data.serviceId);
    loading = true;
    setState(() {});
  }

  @override
  void initState() {
    getService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(6),
      padding: EdgeInsets.all(8),
      height: 180,
      decoration: BoxDecoration(
        color: Color(0xff0F0F0F),
        borderRadius: BorderRadius.all(Radius.circular(16)),
        border: Border.all(
          color: highLcolorLight,
        ),
      ),
      child: loading
          ? Row(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    child: Image.network(
                      '$baseUrl/getServiceImageByID/${widget.data.serviceId}',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Service: ',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                            ),
                            Text(
                              service.name,
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'At: ',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                            ),
                            Text(
                              widget.data.location,
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'On: ',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                            ),
                            Text(
                              widget.data.date,
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'From: ',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                            ),
                            Text(
                              widget.data.time,
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Duration: ',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                            ),
                            Text(
                              '${service.duration.toString()} Minutes',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: BackgroundImageButton(
                                onPress: () {
                                  print(widget.data.latlong['latitude']);
                                  MapsLauncher.launchCoordinates(double.parse(widget.data.latlong['latitude']),
                                      double.parse(widget.data.latlong['longitude']));
                                },
                                title: 'Get Location',
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Flexible(
                              child: BorderRadiusButton(
                                onPress: () {
                                  Navigator.push(
                                    (context),
                                    MaterialPageRoute(
                                      builder: (context) => OrderDetailPage(
                                        order: widget.data,
                                        service: service,
                                      ),
                                    ),
                                  );
                                },
                                title: 'View Details',
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            )
          : Center(
              child: CircularProgressIndicator(
              color: Colors.deepOrange,
            )),
    );
  }
}
