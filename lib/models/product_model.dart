import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String title;
  final String price;
  final String description;
  final String imageUrl;
  final String sellerId;
  final String sellerName;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.sellerId,
    required this.sellerName,
    required this.createdAt,
  });

  // Factory constructor to read data from Firestore
  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      title: data['title'] ?? 'No Title',
      price: data['price'] ?? '0',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? 'https://via.placeholder.com/150',
      sellerId: data['createdBy'] ?? '',
      sellerName: data['sellerName'] ?? 'UniMarket Seller',
      // Safely convert Timestamp to DateTime
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Method to convert Product object to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'createdBy': sellerId,
      'sellerName': sellerName,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
