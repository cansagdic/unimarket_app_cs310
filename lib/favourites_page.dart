import 'package:flutter/material.dart';
import 'products.dart';
import 'product.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  @override
  Widget build(BuildContext context) {
    // Get only favorited products
    final List<Product> favouriteProducts =
        products.where((p) => p.isFavorite).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Favorites",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),

      body: favouriteProducts.isEmpty
          ? const Center(
              child: Text(
                "No favorites yet",
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favouriteProducts.length,
              itemBuilder: (context, index) {
                final product = favouriteProducts[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ---------------- IMAGE ----------------
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          product.imagePath,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(width: 16),

                      // ---------------- DETAILS ----------------
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.seller,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black54),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              product.title,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              product.price,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),

                            const SizedBox(height: 10),

                            // -------- Contact Seller --------
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black87,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Contacting seller...")),
                                );
                              },
                              child: const Text(
                                "Contact Seller",
                                style:
                                    TextStyle(fontSize: 14, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ---------------- HEART BUTTON (remove from favorites) ----------------
                      IconButton(
                        icon: const Icon(
                          Icons.favorite,
                          size: 32,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          setState(() {
                            product.isFavorite = false;   // remove favorite
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
