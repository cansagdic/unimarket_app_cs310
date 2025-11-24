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
  String _currentSortOption = 'Default';

  // Price Filtering State Variables
  double _minPrice = 0.0;
  double _maxPrice = 1000.0; // Assuming this is the max value for the RangeSlider

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_performSearch);
    // The search could be triggered once the page opens for an empty search
    // _performSearch();
  }

  @override
  void dispose() {
    _searchController.removeListener(_performSearch);
    _searchController.dispose();
    super.dispose();
  }

  // Helper function to convert price string ("$XX") to a numerical double value
  double _getPriceValue(String price) {
    return double.tryParse(price.replaceAll('\$', '')) ?? 0.0;
  }

  // Sorting Logic
  void _sortResults(String sortOption) {
    if (_searchResults.isEmpty) return;

    if (sortOption == 'Price: Low to High') {
      _searchResults.sort((a, b) =>
          _getPriceValue(a.price).compareTo(_getPriceValue(b.price)));
    } else if (sortOption == 'Title: A-Z') {
      _searchResults.sort((a, b) => a.title.compareTo(b.title));
    }
    // No action needed for Default sorting.
  }

  // Filtering and Search Logic
  void _performSearch() {
    final query = _searchController.text.toLowerCase();

    // Apply both text search and price range filters simultaneously
    final results = products.where((product) {
      // 1. Text Search Criterion (returns true if search box is empty)
      final meetsQuery = query.isEmpty ||
          product.title.toLowerCase().contains(query) ||
          product.seller.toLowerCase().contains(query);

      // 2. Price Range Criterion
      final priceValue = _getPriceValue(product.price);
      final meetsPriceRange = priceValue >= _minPrice && priceValue <= _maxPrice;

      return meetsQuery && meetsPriceRange;
    }).toList();

    setState(() {
      _searchResults = results;
      _sortResults(_currentSortOption); // Apply current sort after filtering
    });
  }

  // Price Range Modal Bottom Sheet Function
  void _showPriceFilterModal(BuildContext context) {
    double tempMin = _minPrice;
    double tempMax = _maxPrice;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter modalSetState) {
              return Container(
                padding: const EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height * 0.45,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Price Range', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const Divider(),
                    const SizedBox(height: 10),

                    // Price Range Display
                    Text(
                      'Selected Price: \$${tempMin.round()} - \$${tempMax.round()}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),

                    // RangeSlider
                    RangeSlider(
                      values: RangeValues(tempMin, tempMax),
                      min: 0,
                      max: 1000,
                      divisions: 100,
                      labels: RangeLabels(
                        '\$${tempMin.round()}',
                        '\$${tempMax.round()}',
                      ),
                      onChanged: (RangeValues newValues) {
                        modalSetState(() { // Update the temporary state inside the Modal
                          tempMin = newValues.start;
                          tempMax = newValues.end;
                        });
                      },
                    ),

                    const Spacer(),

                    // Apply Filter Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Update the main state and re-run search/filter
                          setState(() {
                            _minPrice = tempMin;
                            _maxPrice = tempMax;
                            // Call the performSearch method directly to apply filters.
                            _performSearch();
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('Apply Filter'),
                      ),
                    ),
                  ],
                ),
              );
            }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // Go back to Home Page
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true, // Keyboard pops up when the page opens
          decoration: InputDecoration(
            hintText: 'Search UniMarket...',
            border: InputBorder.none,
            // Clear button functionality
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
          // Filter and Sort Bars
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                // --- FILTER BUTTON (Functional) ---
                TextButton.icon(
                  onPressed: () => _showPriceFilterModal(context), // Opens the filter modal
                  icon: const Icon(Icons.filter_list),
                  label: const Text('Filter'),
                ),

                const SizedBox(width: 10),

                // --- SORT BUTTON (Functional) ---
                PopupMenuButton<String>(
                  onSelected: (String result) {
                    setState(() {
                      _currentSortOption = result; // Update sort state
                      _sortResults(_currentSortOption); // Re-sort the current results
                    });
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'Default',
                      child: Text('Default Order'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Price: Low to High',
                      child: Text('Price: Low to High'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Title: A-Z',
                      child: Text('Title: A-Z'),
                    ),
                  ],
                  child: Row(
                    children: [
                      const Icon(Icons.sort, color: Colors.black54),
                      const SizedBox(width: 4),
                      Text('Sort: $_currentSortOption', style: const TextStyle(color: Colors.black54)),
                    ],
                  ),
                ),

                const Spacer(),
                Text('${_searchResults.length} results'),
              ],
            ),
          ),

          // Search Results List
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
                      // Navigate to detail page
                      // We send fields individually as per the existing ProductDetailsPage constructor
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