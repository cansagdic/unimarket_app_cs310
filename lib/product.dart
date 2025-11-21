class Product {
  final String imagePath;
  final String title;
  final String seller;
  final String price;
  final String condition;
  final String description;
  bool isFavorite;   // NEW FIELD

  Product({
    required this.imagePath,
    required this.title,
    required this.seller,
    required this.price,
    required this.condition,
    required this.description,
    this.isFavorite = false,   // DEFAULT FALSE
  });
}
