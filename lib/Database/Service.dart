class Services {
  Services(
    this.id,
    this.name,
    this.image,
    this.desc,
    this.duration,
    this.cost,
    this.saleCost,
    this.reviewId,
    this.tax,
    this.status,
    this.serviceProviderId,
  );
  final id;
  final name;
  final image;
  final desc;
  final duration;
  final cost;
  final saleCost;
  final reviewId;
  final tax;
  final status;
  final serviceProviderId;

  factory Services.fromJson(data) {
    final id = data["id"];
    final name = data["name"];
    final image = data["image"];
    final desc = data["desc"];
    final duration = data["duration"];
    final cost = data["cost"];
    final saleCost = data["saleCost"];
    final reviewId = data["reviewId"];
    final tax = data["tax"];
    final status = data["status"];
    final serviceProviderId = data["serviceProviderId"];

    return Services(id, name, image, desc, duration, cost, saleCost, reviewId, tax, status, serviceProviderId);
  }
}
