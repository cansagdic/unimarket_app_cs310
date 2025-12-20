import 'package:flutter/material.dart';

class SellerProfileScreen extends StatelessWidget {
  const SellerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),

              // Profil fotoğrafı
              const CircleAvatar(
                radius: 55,
                backgroundImage: NetworkImage(
                  "https://i.pravatar.cc/300?img=47", // örnek foto
                ),
              ),

              const SizedBox(height: 12),

              // İsim
              const Text(
                "Sude Nil Varlı",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              // Alt başlık
              const Text(
                "Senior Computer Science and Engineering Student",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              // Ayırıcı çizgi
              Container(
                height: 1,
                color: Colors.black26,
              ),

              const SizedBox(height: 16),

              // Bölüm başlığı
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

              // Ürün listesi
              Expanded(
                child: ListView(
                  children: [
                    _productCard(
                      imageUrl:
                      "https://images.pexels.com/photos/112811/pexels-photo-112811.jpeg",
                      title: "Reading Lamp",
                      price: "\$20",
                    ),
                    const SizedBox(height: 16),
                    _productCard(
                      imageUrl:
                      "https://images.pexels.com/photos/279906/pexels-photo-279906.jpeg",
                      title: "Suitcase",
                      price: "\$90",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // Alt navigation bar (Figma’daki gibi basit ikonlar)
      bottomNavigationBar: Container(
        height: 70,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.black12),
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.search, size: 26),
              Icon(Icons.star_border, size: 26),
              Icon(Icons.mail_outline, size: 26, color: Colors.deepPurple),
              Icon(Icons.person_outline, size: 26),
            ],
          ),
        ),
      ),
    );
  }

  // Ürün kartı widget'ı
  static Widget _productCard({
    required String imageUrl,
    required String title,
    required String price,
  }) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imageUrl,
              width: 110,
              height: 110,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                price,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          )
            ],
                      );
    }
}
