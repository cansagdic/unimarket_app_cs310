import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/database_service.dart';

class ProductProvider extends ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  
  List<Product> _products = [];
  List<Product> _userProducts = [];
  bool _loading = false;
  String? _error;

  List<Product> get products => _products;
  List<Product> get userProducts => _userProducts;
  bool get loading => _loading;
  String? get error => _error;

  // Listen to all products
  void listenToProducts() {
    _dbService.getProducts().listen(
      (productList) {
        _products = productList;
        _loading = false;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        _loading = false;
        notifyListeners();
      },
    );
  }

  // Listen to user's products
  void listenToUserProducts(String userId) {
    _dbService.getUserProducts(userId).listen(
      (productList) {
        _userProducts = productList;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        notifyListeners();
      },
    );
  }

  // Add product
  Future<void> addProduct({
    required String title,
    required String price,
    required String description,
    required String imageUrl,
    required String sellerId,
    required String sellerName,
  }) async {
    try {
      _loading = true;
      _error = null;
      notifyListeners();

      await _dbService.addProduct(
        title: title,
        price: price,
        description: description,
        imageUrl: imageUrl,
        sellerId: sellerId,
        sellerName: sellerName,
      );

      _loading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _loading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Update product
  Future<void> updateProduct({
    required String productId,
    required String title,
    required String price,
    required String description,
    required String imageUrl,
  }) async {
    try {
      _loading = true;
      _error = null;
      notifyListeners();

      await _dbService.updateProduct(
        productId: productId,
        title: title,
        price: price,
        description: description,
        imageUrl: imageUrl,
      );

      _loading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _loading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Delete product
  Future<void> deleteProduct(String productId) async {
    try {
      _loading = true;
      _error = null;
      notifyListeners();

      await _dbService.deleteProduct(productId);

      _loading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _loading = false;
      notifyListeners();
      rethrow;
    }
  }
}
