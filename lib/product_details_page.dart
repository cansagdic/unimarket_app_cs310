import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/product_model.dart';
import 'providers/auth_provider.dart';
import 'services/chat_service.dart';
import 'services/favourite_service.dart';
import 'chat_screen.dart';
import 'seller_profile_page.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;

  const ProductDetailsPage({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  bool detailsExpanded = true;
  final FavouriteService _favouriteService = FavouriteService();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final userId = authProvider.user?.uid;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        actions: [
          if (userId != null)
            StreamBuilder<bool>(
              stream: _favouriteService.isFavourite(userId, widget.product.id),
              builder: (context, snapshot) {
                final isFav = snapshot.data ?? false;
                return IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.red : null,
                  ),
                  onPressed: () => _favouriteService.toggleFavourite(userId, widget.product.id),
                );
              },
            ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ===================== IMAGE =====================
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.network(
                  widget.product.imageUrl,
                  height: 260,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Container(
                    height: 260,
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.image, size: 100, color: Colors.grey),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),

            // ===================== PRODUCT TITLE =====================
            Text(
              widget.product.title,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // ===================== PRICE =====================
            Text(
              widget.product.price,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // ===================== SELLER =====================
            GestureDetector(
              onTap: () {
                // Don't navigate if it's your own product
                if (authProvider.user?.uid == widget.product.sellerId) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('This is your own listing')),
                  );
                  return;
                }
                
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SellerProfileScreen(
                      sellerId: widget.product.sellerId,
                      sellerName: widget.product.sellerName,
                    ),
                  ),
                );
              },
              child: Row(
                children: [
                  Text(
                    "Posted by: ",
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                  Text(
                    widget.product.sellerName,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ===================== CONTACT BUTTON =====================
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  final authProvider = context.read<AuthProvider>();
                  if (authProvider.user == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please log in to contact seller')),
                    );
                    return;
                  }
                  
                  // Don't allow messaging yourself
                  if (authProvider.user!.uid == widget.product.sellerId) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('This is your own listing')),
                    );
                    return;
                  }
                  
                  try {
                    final chatService = ChatService();
                    final chatId = await chatService.getOrCreateChat(
                      userId1: authProvider.user!.uid,
                      userName1: authProvider.user!.displayName ?? 'User',
                      userId2: widget.product.sellerId,
                      userName2: widget.product.sellerName,
                    );
                    
                    if (!context.mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          chatId: chatId,
                          receiverName: widget.product.sellerName,
                          receiverId: widget.product.sellerId,
                        ),
                      ),
                    );
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Connection Error: $e')),
                    );
                  }
                },
                child: Text(
                  "Contact Seller",
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 22),

            // ===================== PRODUCT DETAILS DROPDOWN =====================
            GestureDetector(
              onTap: () {
                setState(() {
                  detailsExpanded = !detailsExpanded;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Product Details",
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                    Icon(
                      detailsExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                    ),
                  ],
                ),
              ),
            ),

            if (detailsExpanded)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(12),
                  ),
                ),
                child: Text(
                  widget.product.description,
                  style: TextStyle(fontSize: 15, color: Theme.of(context).textTheme.bodyMedium?.color),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
