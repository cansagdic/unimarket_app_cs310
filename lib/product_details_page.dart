import 'package:flutter/material.dart';
import 'products.dart';
import 'product.dart';
import 'chat_screen.dart'; 
import 'package:intl/intl.dart'; 

class ProductDetailsPage extends StatefulWidget {
  final String imagePath;
  final String title;
  final String seller;
  final String price;
  final String condition;
  final String description;

  const ProductDetailsPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.seller,
    required this.price,
    required this.condition,
    required this.description,
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  bool detailsExpanded = true;

  Product get currentProduct {
    return products.firstWhere((p) => p.title == widget.title);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ===================== IMAGE + HEART BUTTON =====================
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.asset(
                      widget.imagePath,
                      height: 260,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // FAVORITE BUTTON
                Positioned(
                  right: 10,
                  top: 10,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentProduct.isFavorite = !currentProduct.isFavorite;
                      });
                    },
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white,
                      child: Icon(
                        currentProduct.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // ===================== PRODUCT TITLE =====================
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // ===================== CONDITION TAG =====================
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.condition,
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ===================== PRICE =====================
            Text(
              widget.price,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // ===================== SELLER =====================
            Text(
              "Posted by: ${widget.seller}",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 20),

            // ===================== CONTACT BUTTON (GÜNCELLENDİ) =====================
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        receiverName: widget.seller,
                        receiverId: widget.seller,
                        avatarPath: null,
                        initialMessages: [
                          {
                            // 🎯 GÜNCELLENDİ: Tarih ve saat formatı eklendi.
                            'text': DateFormat('MMM d, yyyy, h:mm a').format(DateTime.now()),
                            'isMe': false,
                            'isDate': true,
                          }
                        ],
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Contact Seller",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
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
                  color: Colors.grey.shade100,
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
                  color: Colors.grey.shade50,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(12),
                  ),
                ),
                child: Text(
                  widget.description,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                ),
              ),
          ],
        ),
      ),
    );
  }
}