import 'package:flutter/material.dart';
import 'products.dart';
import 'product.dart';
import 'product_details_page.dart';
import 'product_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_performSearch);
  }

  @override
  void dispose() {
    _searchController.removeListener(_performSearch);
    _searchController.dispose();
    super.dispose();
  }

  // Search and Filtering Logic
  void _performSearch() {
    final query = _searchController.text.toLowerCase();

    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    final results = products.where((product) {
      //Filter with item or seller name
      return product.title.toLowerCase().contains(query) ||
          product.seller.toLowerCase().contains(query);
    }).toList();

    setState(() {
      _searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search UniMarket...',
            border: InputBorder.none,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                _performSearch();
              },
            )
                : null,
          ),
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                TextButton.icon(
                  onPressed: () {  },
                  icon: const Icon(Icons.filter_list),
                  label: const Text('Filter'),
                ),
                TextButton.icon(
                  onPressed: () {  },
                  icon: const Icon(Icons.sort),
                  label: const Text('Sort'),
                ),
                const Spacer(),
                Text('${_searchResults.length} results'),
              ],
            ),
          ),

          // Result List
          Expanded(
            child: _searchResults.isEmpty && _searchController.text.isNotEmpty
                ? const Center(child: Text("No items found matching your search."))
                : ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final Product product = _searchResults[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ProductCard(
                    product: product,
                    onTap: () {
                      // For sending to detail page when clicked
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsPage(
                            imagePath: product.imagePath,
                            title: product.title,
                            seller: product.seller,
                            price: product.price,
                            condition: product.condition,
                            description: product.description,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}