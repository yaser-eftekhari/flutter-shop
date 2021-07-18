class Product {
  final String id;
  final String imageUrl;
  final String description;
  final String title;
  final double price;
  final bool isFavorite;

  Product({
    required this.imageUrl,
    required this.description,
    required this.title,
    required this.price,
    required this.id,
    this.isFavorite = false,
  });
}
