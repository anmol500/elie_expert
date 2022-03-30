class Order {
  Order(
    this.id,
    this.orderId,
    this.productId,
    this.serviceId,
    this.location,
    this.latlong,
    this.date,
    this.time,
    this.expertId,
    this.totAmount,
    this.status,
    this.paymentForm,
    this.paid,
    this.quantity,
    this.completeDate,
  );

//service & product
  final id;
  final orderId;
  final productId;
  final serviceId;
//Location
  final location;
  final latlong;
// date & time
  final date;
  final time;
//expert
  final expertId;
  final status;
  final paymentForm;
  final paid;
  final quantity;
  final completeDate;

//Cart Total Amount
  double totAmount = 0;

  Map<String, dynamic> toJson() {
    // return a map literal with all the non-null key-value pairs
    return {
      'id': id,
      'orderId': orderId,
      'productId': productId,
      'serviceId': serviceId,
      "location": location.toString(),
      "latlong": latlong,
      "date": date.toString(),
      "time": time.toString(),
      "expertId": expertId,
      "totAmount": totAmount,
      "status": status,
      "paymentForm": paymentForm,
      "paid": paid,
      "quantity": quantity,
      "completeDate": completeDate,
    };
  }

  factory Order.fromJson(data) {
    final id = data['id'];
    final orderId = data['orderId'];
    final productId = data['productId'];
    final serviceId = data['serviceId'];
    final location = data["location"];
    final latlong = data["latlong"];
    final date = data["date"];
    final time = data["time"];
    final expertId = data['expertId'];
    final totAmount = data['totAmount'];
    final status = data['status'];
    final paymentForm = data['paymentForm'];
    final paid = data['paid'];
    final quantity = data['quantity'];
    final completeDate = data['completeDate'];

    return Order(
        id, orderId, productId, serviceId, location, latlong, date, time, expertId, totAmount, status, paymentForm, paid, quantity, completeDate);
  }
}
