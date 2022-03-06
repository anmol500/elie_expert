class Product {
  Product(
    this.id,
    this.productTitle,
    this.productImage,
    this.productDesc,
    this.regularPrice,
    this.salePrice,
    this.reviewId,
    this.tax,
    this.stock,
    this.lowStockThreshold,
    this.status,
    this.size,
    this.weight,
  );
  final id;
  final productTitle;
  final productImage;
  final productDesc;
  final regularPrice;
  final salePrice;
  final reviewId;
  final tax;
  final stock;
  final lowStockThreshold;
  final status;
  final size;
  final weight;

  factory Product.fromJson(data) {
    final id = data["id"];
    final productTitle = data["productTitle"];
    final productImage = data["productImage"];
    final productDesc = data["productDesc"];
    final regularPrice = data["regularPrice"];
    final salePrice = int.parse(data["salePrice"].toString()).toDouble();
    final reviewId = data["reviewId"];
    final tax = data["tax"];
    final stock = data["stock"];
    final status = data["status"];
    final lowStockThreshold = data["lowStockThreshold"];
    final size = data["size"];
    final weight = data["weight"];

    return Product(
        id, productTitle, productImage, productDesc, regularPrice, salePrice, reviewId, tax, stock, lowStockThreshold, status, size, weight);
  }
}
