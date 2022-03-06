import 'package:elie_expert/Database/Order.dart';
import 'package:elie_expert/Screens/OrderPage/OrderPageModel.dart';
import 'package:elie_expert/Utils/Colors.dart';
import 'package:flutter/material.dart';

import 'Widget/OrderCard.dart';

class OrderPage extends StatefulWidget {
  OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  var orderLenght = 0;
  getInfo() async {
    orderLenght = await OrderPageModel().getOrderLenght();
  }

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: midBlack,
      child: FutureBuilder(
        future: OrderPageModel().getOrderByExpert(),
        builder: (BuildContext context, AsyncSnapshot<List<Order>> snapshot) {
          if (snapshot.hasData) {
            List<Order> orderList = [];
            for (var d in snapshot.data!) {
              if (d.id != 0) {
                orderList.add(d);
              }
            }

            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return OrderCard(
                  data: orderList[index],
                );
              },
              itemCount: orderList.length,
            );
          }
          return Center(
              child: CircularProgressIndicator(
            color: Colors.deepOrange,
          ));
        },
      ),
    );
  }
}
