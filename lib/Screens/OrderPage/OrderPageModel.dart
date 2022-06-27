import 'package:dio/dio.dart';
import 'package:elie_expert/Database/API.dart';
import 'package:elie_expert/Database/Locator.dart';
import 'package:elie_expert/Database/Order.dart';
import 'package:elie_expert/Utils/Colors.dart';

class OrderPageModel {
  Future<int> getOrderLenght() async {
    var orders = await API().getOrder();
    return orders.length;
  }

  Future<List<Order>> getOrderByExpert() async {
    var booking = await Dio().get('$baseUrl/get_bookings_expertId/${getItUserIn.userPhone}');
    List<Order> orderList = [];
    for (var d in booking.data) {
      print(d['isDone']);
      if (d['orderId'].toString() != '000' && d['isDone'] == false) {
        var order = await API().getOrderByOrderId(d['orderId']);
        orderList.add(order);
      } else {
        orderList.add(Order(0, 0, 0, 0, 0, 0, d['startTime'], 0, 0, 0, 0, 0, 0, 0, 0));
      }
    }

    return orderList;
  }
}
