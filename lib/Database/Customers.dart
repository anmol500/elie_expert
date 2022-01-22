class Customers {
  Customers(
    this.name,
    this.sex,
    this.phone,
    this.email,
    this.password,
    this.lastLogin,
    this.age,
    this.dob,
    this.anniversary,
    this.joinedDate,
    this.addressId,
    this.customerRatingId,
    this.bloodGrp,
    this.cartId,
  );
  final name;
  final sex;
  final phone;
  final email;
  final password;
  final lastLogin;
  final age;
  final dob;
  final anniversary;
  final joinedDate;
  final addressId;
  final customerRatingId;
  final cartId;
  final bloodGrp;

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
      "anniversary": anniversary,
      "joinedDate": joinedDate,
      "lastLogin": lastLogin,
      "addressId": addressId,
      "customerRatingId": customerRatingId,
      "bloodGrp": bloodGrp,
      "cartId": cartId,
    };
  }

  factory Customers.fromJson(data) {
    final name = data['name'];
    final sex = data['sex'];
    final phone = data["phone"];
    final email = data["email"];
    final password = data["password"];
    final age = data['age'];
    final dob = data['dob'];
    final anniversary = data['anniversary'];
    final joinedDate = data['joinedDate'];
    final lastLogin = data['lastLogin'];
    final addressId = data['addressId'];
    final customerRatingId = data['customerRatingId'];
    final bloodGrp = data['bloodGrp'];
    final cartId = data['cartId'];

    return Customers(name, sex, phone, email, password, lastLogin, age, dob, anniversary, joinedDate, addressId, customerRatingId, bloodGrp, cartId);
  }
}
