import 'package:elie_expert/Database/Tracking.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

import 'API.dart';
import 'Cart.dart';
import 'Order.dart';
import 'Product.dart';
import 'Service.dart';

final getIt = GetIt.instance;
var getItCart = getIt<CartData>();
var getItPages = getIt<Pages>();
var getItUserIn = getIt<UserIn>();
var getItSearchBar = getIt<SearchBar>();
var getItOrderPage = getIt<OrderPageLocator>();

void setup() {
  getIt.registerLazySingleton<Pages>(() => Pages());
  getIt.registerLazySingleton<CartData>(() => CartData());
  getIt.registerLazySingleton<UserIn>(() => UserIn());
  getIt.registerLazySingleton<SearchBar>(() => SearchBar());
  getIt.registerLazySingleton<OrderPageLocator>(() => OrderPageLocator());
  getIt.registerLazySingleton(() => NavigationService());
}

class SearchBar {
  late List<Product> listOfProducts;
  late List<Services> listOfServices;
}

class UserIn {
  var userPhone;
  var userPass;
  var userName;
  var email;

  setUserIn(phone, pass, userName, email) {
    this.userPhone = phone;
    this.userPass = pass;
    this.userName = userName;
    this.email = email;
  }
}

class Pages {
  String currentPage = '/';
  var contextOfDatePicker;
  var contextOfLocationPage;
  var contextOfHomeAddress;
  var disableColorTOP;
  var onTapTopBar = [false, false, false, false, false, false, false, false, false, false, false];

  setonTapTopBar(x, bool) {
    this.onTapTopBar[x] = bool;
  }

  getTapColorChange(f) {
    disableColorTOP = f;
  }

  setContextDATE(context) {
    this.contextOfDatePicker = context;
  }

  setContextHomeAddress(context) {
    this.contextOfHomeAddress = context;
  }

  setContextLOCATION(context) {
    this.contextOfLocationPage = context;
  }

  setCurrentPathANDTopColorOFF(page) {
    currentPage = page;
    disableColorTOP();
  }
}

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState!.pushNamed(routeName);
  }
}

class CartData extends ChangeNotifier {
  //service & product
  var productId;
  var productImage;
  var productTitle;
  var productPrice;
  var productDesc;
  Product? productData;
  Services? serviceData;
  //Location
  var location = "At Home";
  var latlong;
  // date % time
  var date;
  var time;
  //expert
  var expertId;

  //Cart Total Amount
  var totAmount;
  //CartList
  List<Map> cartItems = [];

  setLatlong(lat, long) {
    this.latlong = LocationForTracking(lat, long);
  }

  addToCart(isProduct) async {
    List<Cart> list = await API().getCartById(getItUserIn.userPhone);

    var parsedJson;

    if (isProduct) {
      totAmount = productData!.salePrice ?? 0.0;
      parsedJson = Cart(getItUserIn.userPhone, list.length + 1, productData!.id, null, location, latlong,
              DateFormat('dd/MM/yyyy').format(DateTime.now()).toString(), DateFormat('h:m').format(DateTime.now()).toString(), null, totAmount, 1)
          .toJson();
    } else {
      totAmount = serviceData!.saleCost ?? 0.0;
      parsedJson = Cart(getItUserIn.userPhone, list.length + 1, null, serviceData!.id, location, latlong,
              DateFormat('dd/MM/yyyy').format(DateTime.now()).toString(), DateFormat('hh:mm a').format(DateTime.now()).toString(), 1, totAmount, 1)
          .toJson();
    }

    await API().addCart(parsedJson);

    ////////////EMPTYING////////////EMPTYING////////////EMPTYING////////////EMPTYING
    productId = 0;
    location = '';
    expertId = 0;
    date = DateRangePickerSelectionChangedArgs(DateTime.now());
    time = '';
  }

  addToOrder(Cart d) async {
    var parsedJson;
    var count = (await API().getOrder()).length;
    var latL = latlong;
    parsedJson = Order(
      getItUserIn.userPhone,
      count + 1,
      d.productId,
      d.serviceId,
      d.location,
      latL,
      d.date,
      d.time,
      d.expertId,
      d.totAmount,
      "Order Recived",
      'online',
      false,
      d.quantity,
      '',
    ).toJson();
    print('added');
    await API().addOrder(parsedJson);
  }

  removeFromCart(index) {
    totAmount = totAmount - cartItems.elementAt(index)['productPrice'];
    cartItems.removeAt(index);
  }

  setAmt(double a) {
    totAmount = a;
    notifyListeners();
  }

  setDate(d) {
    date = d;
  }

  setLocation(l) {
    location = l;
  }

  setTime(t) {
    time = t;
  }

  setExpertData(e) {
    expertId = e;
  }

  setProductData(d, check) {
    if (check) {
      productData = d;
    } else {
      serviceData = d;
    }
  }
}

class OrderPageLocator extends ChangeNotifier {
  //sideBar index
  List pageList = [1, 2, 3, 4, 5, 6, 7];
  int pageIndex = 1;

  setPageIndex(i) {
    pageIndex = i;
    notifyListeners();
  }
}
