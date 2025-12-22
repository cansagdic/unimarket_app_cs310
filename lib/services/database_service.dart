import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class DatabaseService {
  // Reference to the 'products' collection in Firestore
  final CollectionReference _productsRef =
  FirebaseFirestore.instance.collection('products');

  // READ: Get real-time updates of products
  Stream<List<Product>> getProducts() {
    return _productsRef
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
    required String sellerName,
  }) async {
    await _productsRef.add({
      'title': title,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'createdBy': sellerId,
      'sellerName': sellerName,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // UPDATE: Update an existing product
  Future<void> updateProduct({
    required String productId,
    required String title,
    required String price,
    required String description,
    required String imageUrl,
  }) async {
    await _productsRef.doc(productId).update({
      'title': title,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
    });
  }

  // DELETE: Remove a product from Firestore
  Future<void> deleteProduct(String productId) async {
    await _productsRef.doc(productId).delete();
  }

  // READ: Get products for a specific user (for "My Listings")
  Stream<List<Product>> getUserProducts(String userId) {
    return _productsRef
        .where('createdBy', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
    });
  }
}