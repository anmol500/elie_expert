class Experts {
  Experts(
    this.name,
    this.sex,
    this.phone,
    this.email,
    this.password,
    this.age,
    this.dob,
    this.averageRating,
    this.reviewId,
    this.availability,
    this.lastLocation,
  );
  final name;
  final sex;
  final phone;
  final email;
  final password;
  final age;
  final dob;
  final averageRating;
  final reviewId;
  final availability;
  final lastLocation;

  Map<String, dynamic> toJson() {
    // return a map literal with all the non-null key-value pairs
    return {
      'name': name,
      "sex": sex,
      "phone": phone,
      "email": email,
      "password": password,
      "age": age,
      "dob": dob,
      "averageRating": averageRating,
      "reviewId": reviewId,
      "availability": availability,
      "lastLocation": lastLocation,
    };
  }

  factory Experts.fromJson(data) {
    final name = data['name'];
    final sex = data['sex'];
    final phone = data["phone"];
    final email = data["email"];
    final password = data["password"];
    final age = data['age'];
    final dob = data['dob'];
    final averageRating = data['averageRating'];
    final reviewId = data['reviewId'];
    final availability = data['availability'];
    final lastLocation = data['lastLocation'];

    return Experts(name, sex, phone, email, password, age, dob, averageRating, reviewId, availability, lastLocation);
  }
}
