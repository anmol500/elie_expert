import 'package:elie_expert/Database/API.dart';
import 'package:elie_expert/Database/Order.dart';
import 'package:elie_expert/Database/Service.dart';
import 'package:elie_expert/Screens/OrderDetailPage/OrderDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:maps_launcher/maps_launcher.dart';

class OrderCard extends StatefulWidget {
  OrderCard({
    Key? key,
    required this.data,
  }) : super(key: key);
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
        image: DecorationImage(
          image: AssetImage('assets/card_bg.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: loading
          ? Row(
              children: [
                Flexible(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      'http://142.93.212.17:8001/getServiceImageByID/${widget.data.serviceId}',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Service: ',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            service.name,
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'At: ',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            widget.data.location,
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Duration: ',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            '${service.duration.toString()} Minutes',
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              print(widget.data.latlong);
                              MapsLauncher.launchCoordinates(
                                  double.parse(widget.data.latlong['latitude']), double.parse(widget.data.latlong['longitude']));
                            },
                            child: Text('Get Location'),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          ElevatedButton(
                            onPressed: () {
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
                            child: Text('View Details'),
                          ),
                        ],
                      )
                    ],
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
