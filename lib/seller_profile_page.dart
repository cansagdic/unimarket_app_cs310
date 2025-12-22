import 'package:flutter/material.dart';
import 'models/product_model.dart';
import 'services/database_service.dart';
import 'product_details_page.dart';

class SellerProfileScreen extends StatelessWidget {
  final String sellerId;
  final String sellerName;

  const SellerProfileScreen({
    super.key,
    required this.sellerId,
    required this.sellerName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(sellerName),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),

              // Profile photo
              CircleAvatar(
                radius: 55,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Text(
                  sellerName.isNotEmpty ? sellerName[0].toUpperCase() : '?',
                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 12),

              // Name
              Text(
                sellerName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // Divider
              Divider(color: Theme.of(context).dividerColor),

              const SizedBox(height: 16),

              // Section title
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Products of the Seller",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Product list from Firestore
              Expanded(
                child: StreamBuilder<List<Product>>(
                  stream: DatabaseService().getUserProducts(sellerId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final products = snapshot.data ?? [];

                    if (products.isEmpty) {
                      return const Center(
                        child: Text(
                          'No products yet',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: products.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return _productCard(
                          context: context,
                          product: product,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Product card widget
  static Widget _productCard({
    required BuildContext context,
    required Product product,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailsPage(product: product),
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              product.imageUrl,
              width: 110,
              height: 110,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 110,
                height: 110,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: const Icon(Icons.image, size: 40),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  product.price,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

