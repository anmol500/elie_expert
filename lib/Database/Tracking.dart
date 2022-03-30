class Tracking {
  Tracking(this.location, this.timeStamp, this.dayStamp, this.expertId);
  final location;
  final timeStamp;
  final dayStamp;
  final expertId;

  Map<String, dynamic> toJson() {
    // return a map literal with all the non-null key-value pairs
    return {
      'location': location,
      "timeStamp": timeStamp,
      "dayStamp": dayStamp,
      "expertId": expertId,
    };
  }

  factory Tracking.fromJson(data) {
    final location = data['location'];
    final timeStamp = data['timeStamp'];
    final dayStamp = data["dayStamp"];
    final expertId = data["expertId"];
    return Tracking(location, timeStamp, dayStamp, expertId);
  }
}

class LocationForTracking {
  LocationForTracking(this.latitude, this.longitude);
  final latitude;
  final longitude;
  Map<String, dynamic> toJson() {
    // return a map literal with all the non-null key-value pairs
    return {
      'latitude': latitude,
      "longitude": longitude,
    };
  }

  factory LocationForTracking.fromJson(data) {
    final latitude = data['latitude'];
    final longitude = data['longitude'];

    return LocationForTracking(latitude, longitude);
  }
}
