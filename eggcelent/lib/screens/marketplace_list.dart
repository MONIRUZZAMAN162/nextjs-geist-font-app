import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/listing.dart';
import '../services/firebase_service.dart';
import '../widgets/listing_card.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/constants.dart';
import '../utils/error_handling.dart';
import 'listing_detail.dart';
import 'create_listing.dart';

class MarketplaceListScreen extends StatefulWidget {
  const MarketplaceListScreen({super.key});

  @override
  State<MarketplaceListScreen> createState() => _MarketplaceListScreenState();
}

class _MarketplaceListScreenState extends State<MarketplaceListScreen> {
  String? _selectedCategory;
  String? _selectedChickenType;
  double? _maxPrice;
  final TextEditingController _searchController = TextEditingController();
  List<Listing> _searchResults = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String searchTerm) async {
    if (searchTerm.trim().isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults.clear();
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final firebaseService = Provider.of<FirebaseService>(context, listen: false);
      final results = await firebaseService.searchListings(searchTerm);
      
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      if (mounted) {
        ErrorHandler.showErrorSnackBar(
          context, 
          ErrorHandler.handleGeneralException(e as Exception),
        );
      }
    }
  }

  void _clearFilters() {
    setState(() {
      _selectedCategory = null;
      _selectedChickenType = null;
      _maxPrice = null;
      _isSearching = false;
      _searchResults.clear();
    });
    _searchController.clear();
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Filter Listings'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Filter
                    const Text('Product Category', style: AppTextStyles.labelText),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      hint: const Text('Select Category'),
                      items: AppConstants.productCategories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          _selectedCategory = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Chicken Type Filter
                    const Text('Chicken Type', style: AppTextStyles.labelText),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedChickenType,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      hint: const Text('Select Chicken Type'),
                      items: AppConstants.chickenTypes.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          _selectedChickenType = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Max Price Filter
                    const Text('Maximum Price (৳)', style: AppTextStyles.labelText),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        hintText: 'Enter maximum price',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setDialogState(() {
                          _maxPrice = double.tryParse(value);
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setDialogState(() {
                      _selectedCategory = null;
                      _selectedChickenType = null;
                      _maxPrice = null;
                    });
                  },
                  child: const Text('Clear'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // Filters are already set in the dialog state
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final firebaseService = Provider.of<FirebaseService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eggcelent Marketplace'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateListingScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.surface,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for eggs, chicken, meat...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _performSearch('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.background,
              ),
              onChanged: _performSearch,
            ),
          ),

          // Active Filters Display
          if (_selectedCategory != null || _selectedChickenType != null || _maxPrice != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Text('Filters: ', style: AppTextStyles.bodySmall),
                  Expanded(
                    child: Wrap(
                      spacing: 8,
                      children: [
                        if (_selectedCategory != null)
                          Chip(
                            label: Text(_selectedCategory!),
                            onDeleted: () => setState(() => _selectedCategory = null),
                            backgroundColor: AppColors.primaryLight.withOpacity(0.1),
                          ),
                        if (_selectedChickenType != null)
                          Chip(
                            label: Text(_selectedChickenType!),
                            onDeleted: () => setState(() => _selectedChickenType = null),
                            backgroundColor: AppColors.primaryLight.withOpacity(0.1),
                          ),
                        if (_maxPrice != null)
                          Chip(
                            label: Text('Max ৳${_maxPrice!.toStringAsFixed(0)}'),
                            onDeleted: () => setState(() => _maxPrice = null),
                            backgroundColor: AppColors.primaryLight.withOpacity(0.1),
                          ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: _clearFilters,
                    child: const Text('Clear All'),
                  ),
                ],
              ),
            ),

          // Listings List
          Expanded(
            child: _isSearching
                ? _buildSearchResults()
                : _buildListingsStream(firebaseService),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.textHint,
            ),
            SizedBox(height: 16),
            Text(
              'No results found',
              style: AppTextStyles.heading4,
            ),
            SizedBox(height: 8),
            Text(
              'Try different keywords or clear filters',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final listing = _searchResults[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ListingCard(
            listing: listing,
            onTap: () => _navigateToListingDetail(listing),
          ),
        );
      },
    );
  }

  Widget _buildListingsStream(FirebaseService firebaseService) {
    return StreamBuilder<List<Listing>>(
      stream: firebaseService.getListingsStream(
        category: _selectedCategory,
        chickenType: _selectedChickenType,
        maxPrice: _maxPrice,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppColors.error,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Error loading listings',
                  style: AppTextStyles.heading4,
                ),
                const SizedBox(height: 8),
                Text(
                  ErrorHandler.handleFirebaseException(snapshot.error! as Exception),
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => setState(() {}),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading listings...', style: AppTextStyles.bodyMedium),
              ],
            ),
          );
        }

        final listings = snapshot.data ?? [];

        if (listings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.store_outlined,
                  size: 64,
                  color: AppColors.textHint,
                ),
                const SizedBox(height: 16),
                const Text(
                  'No listings available',
                  style: AppTextStyles.heading4,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Be the first to post a listing!',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateListingScreen(),
                      ),
                    );
                  },
                  child: const Text('Create Listing'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: listings.length,
            itemBuilder: (context, index) {
              final listing = listings[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ListingCard(
                  listing: listing,
                  onTap: () => _navigateToListingDetail(listing),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _navigateToListingDetail(Listing listing) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListingDetailScreen(listing: listing),
      ),
    );
  }
}
