import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class DatabaseService {
  // Reference to the 'products' collection in Firestore
  final CollectionReference _productsRef =
  FirebaseFirestore.instance.collection('products');

  // READ: Get real-time updates of products
  Stream<List<Product>> getProducts() {
    return _productsRef
        .orderBy('createdAt', descending: true) // Newest first
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
    });
  }

  // CREATE: Add a new product to Firestore
  Future<void> addProduct({
    required String title,
    required String price,
    required String description,
    required String imageUrl,
    required String sellerId,
  }) async {
    await _productsRef.add({
      'title': title,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'createdBy': sellerId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}