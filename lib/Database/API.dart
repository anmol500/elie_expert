import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:elie_expert/Utils/Colors.dart';
import 'Cart.dart';
import 'Expert.dart';
import 'Locator.dart';
import 'Order.dart';
import 'Customers.dart';
import 'Product.dart';
import 'Service.dart';
import 'Tracking.dart';

class API {
  late Response response;
  var dio = Dio();

  addCustomer(json) async {
    response = await dio.post('http://$baseUrl:8001/registerCustomer', data: jsonEncode(json));
  }

  addLocationTrack(json) async {
    response = await dio.post('http://$baseUrl:8001/add_track', data: jsonEncode(json));
  }

  addCart(json) async {
    response = await dio.post('http://$baseUrl:8001/addCart', data: jsonEncode(json));
  }

  deleteCart(id) async {
    response = await dio.delete('http://$baseUrl:8001/deleteCartById/$id');
  }

  deleteCartId(cartId, id) async {
    response = await dio.delete(
      'http://$baseUrl:8001/deleteCartByCartId/$cartId?id=$id',
    );
  }

  updateQuantity(id, cartId, quantity) async {
    response = await dio.post(
      'http://$baseUrl:8001/updateQuantity/$id?cartId=$cartId&quantity=$quantity',
    );
  }

  addOrder(json) async {
    print(json.toString());
    response = await dio.post('http://$baseUrl:8001/addOrder', data: jsonEncode(json));
  }

  Future<List<Customers>> getCustomer() async {
    response = await dio.get('http://$baseUrl:8001/getCustomer');

    if (response.statusCode == 200 && response.data != 0000) {
      List user = response.data;

      List<Customers> cards = user.map((e) => Customers.fromJson(e)).toList();
      return cards;
    } else {
      print('Error!!');
      throw Exception('Failed to Load Post');
    }
  }

  Future<List<Experts>> getExperts() async {
    response = await dio.get('http://$baseUrl:8001/get_all_expert');

    if (response.statusCode == 200 && response.data != 0000) {
      List user = response.data;

      List<Experts> cards = user.map((e) => Experts.fromJson(e)).toList();
      return cards;
    } else {
      print('Error!!');
      throw Exception('Failed to Load Post');
    }
  }

  Future<Customers?> getCustomerByPhone(phone) async {
    response = await dio.get('http://$baseUrl:8001/getCustomerByPhone/$phone');

    if (response.statusCode == 200 && response.data != 0000) {
      var user = response.data;

      if (user != null) {
        var cards = Customers.fromJson(user);
        return cards;
      } else {
        return null;
      }
    } else {
      print('Error!!');
      return null;
    }
  }

  Future<Experts?> getExpertByPhone(phone) async {
    response = await dio.get('http://$baseUrl:8001/get_expert_phone/$phone');

    if (response.statusCode == 200 && response.data != 0000) {
      var user = response.data;

      if (user != null) {
        var cards = Experts.fromJson(user);
        return cards;
      } else {
        return null;
      }
    } else {
      print('Error!!');
      return null;
    }
  }

  Future<List<Tracking>?> getExpertLocationById(id) async {
    response = await dio.get('http://$baseUrl:8001/total_tracking/$id');

    if (response.statusCode == 200) {
      List loc = response.data;
      List<Tracking> cards = loc.map((e) => Tracking.fromJson(e)).toList();
      return cards;
    } else {
      print('Error!!');
      return null;
    }
  }

  Future<List<Product>> getProducts() async {
    response = await dio.get('http://$baseUrl:8001/getProduct');

    if (response.statusCode == 200) {
      List productList = response.data;
      List<Product> cards = productList.map((e) => Product.fromJson(e)).toList();
      return cards;
    } else {
      print('Error!!');
      throw Exception('Failed to Load Post');
    }
  }

  Future<Product> getProductsByID(id) async {
    response = await dio.get('http://$baseUrl:8001/getProductByID/$id');

    if (response.statusCode == 200) {
      return Product.fromJson(response.data);
    } else {
      print('Error!!');
      throw Exception('Failed to Load Post');
    }
  }

  Future<List<Services>> getServices() async {
    response = await dio.get('http://$baseUrl:8001/getService');

    if (response.statusCode == 200) {
      List serviceList = response.data;
      List<Services> cards = serviceList.map((e) => Services.fromJson(e)).toList();
      return cards;
    } else {
      print('Error!!');
      throw Exception('Failed to Load Post');
    }
  }

  Future<Services> getServiceByID(id) async {
    response = await dio.get('http://$baseUrl:8001/getServiceByID/$id');

    if (response.statusCode == 200) {
      return Services.fromJson(response.data);
    } else {
      print('Error!!');
      throw Exception('Failed to Load Post');
    }
  }

  Future<List<Cart>> getCartById(id) async {
    response = await dio.get('http://$baseUrl:8001/getCartById/${getItUserIn.userPhone}');

    if (response.statusCode == 200) {
      List cartList = response.data;

      List<Cart> cards = cartList.map((e) => Cart.fromJson(e)).toList();

      return cards;
    } else {
      print('Error!!');
      throw Exception('Failed to Load Post');
    }
  }

  Future<List<Order>> getOrderById(id) async {
    response = await dio.get('http://$baseUrl:8001/getOrderById/${getItUserIn.userPhone}');

    if (response.statusCode == 200) {
      List orderList = response.data;
      List<Order> cards = orderList.map((e) => Order.fromJson(e)).toList();

      return cards;
    } else {
      print('Error!!');
      throw Exception('Failed to Load Post');
    }
  }

  Future<List<Order>> getOrder() async {
    response = await dio.get('http://$baseUrl:8001/getOrder');

    if (response.statusCode == 200) {
      List serviceList = response.data;
      List<Order> cards = serviceList.map((e) => Order.fromJson(e)).toList();
      return cards;
    } else {
      print('Error!!');
      throw Exception('Failed to Load Post');
    }
  }

  Future<List<Order>> getOrderByExpert(phone) async {
    response = await dio.get('http://$baseUrl:8001/get_bookings_expertId/$phone');

    if (response.statusCode == 200) {
      List serviceList = response.data;
      List<Order> cards = serviceList.map((e) => Order.fromJson(e)).toList();
      return cards;
    } else {
      print('Error!!');
      throw Exception('Failed to Load Post');
    }
  }

  Future<Order> getOrderByOrderId(orderId) async {
    response = await dio.get('http://$baseUrl:8001/getOrderByOrderId/$orderId');

    if (response.statusCode == 200) {
      return Order.fromJson(response.data);
    } else {
      print('Error!!');
      throw Exception('Failed to Load Post');
    }
  }

  updateOrderById(id, of, to) async {
    response = await dio.post(
      'http://$baseUrl:8001/updateOrderById/$id?of=$of&to=$to',
    );
  }
}
