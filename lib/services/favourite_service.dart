import 'package:cloud_firestore/cloud_firestore.dart';

class FavouriteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference _userFavouritesRef(String userId) => 
      _firestore.collection('users').doc(userId).collection('favourites');

  Future<void> toggleFavourite(String userId, String productId) async {
    final docRef = _userFavouritesRef(userId).doc(productId);
    final doc = await docRef.get();

    if (doc.exists) {
      await docRef.delete();
    } else {
      await docRef.set({
        'productId': productId,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  Stream<bool> isFavourite(String userId, String productId) {
    return _userFavouritesRef(userId).doc(productId).snapshots().map((doc) => doc.exists);
  }

  Stream<List<String>> getFavouriteProductIds(String userId) {
    return _userFavouritesRef(userId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.id).toList();
    });
  }
}
