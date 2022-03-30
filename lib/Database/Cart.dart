class Cart {
  Cart(
    this.id,
    this.cartId,
    this.productId,
    this.serviceId,
    this.location,
    this.latlong,
    this.date,
    this.time,
    this.expertId,
    this.totAmount,
    this.quantity,
  );

//service & product
  final id;
  final cartId;
  final productId;
  final serviceId;
//Location
  final location;
  final latlong;
// date & time
  final date;
  final time;
//expert
  var expertId;
  final quantity;

//Cart Total Amount
  double totAmount = 0.0;

  Map<String, dynamic> toJson() {
    // return a map literal with all the non-null key-value pairs
    return {
      'id': id,
      'cartId': cartId,
      'productId': productId,
      'serviceId': serviceId,
      "location": location.toString(),
      "latlong": {
        'latitude': latlong.latitude.toString(),
        'longitude': latlong.longitude.toString(),
      },
      "date": date.toString(),
      "time": time.toString(),
      "expertId": expertId,
      "totAmount": totAmount,
      "quantity": quantity,
    };
  }

  factory Cart.fromJson(data) {
    final id = data['id'];
    final cartId = data['cartId'];
    final productId = data['productId'];
    final serviceId = data['serviceId'];
    final location = data["location"];
    final latlong = data["latlong"];
    final date = data["date"];
    final time = data["time"];
    final expertId = data['expertId'];
    final totAmount = data['totAmount'];
    final quantity = data['quantity'];

    return Cart(id, cartId, productId, serviceId, location, latlong, date, time, expertId, totAmount, quantity);
  }
}
