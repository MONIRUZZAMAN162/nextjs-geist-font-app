import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/listing.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class ListingCard extends StatelessWidget {
  final Listing listing;
  final VoidCallback onTap;
  final bool showSellerInfo;

  const ListingCard({
    super.key,
    required this.listing,
    required this.onTap,
    this.showSellerInfo = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            _buildImageSection(),
            
            // Content Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Price Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          listing.title,
                          style: AppTextStyles.cardTitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        listing.formattedPrice,
                        style: AppTextStyles.cardPrice,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Product Details
                  _buildProductDetails(),
                  
                  const SizedBox(height: 12),
                  
                  // Description
                  if (listing.description.isNotEmpty)
                    Text(
                      listing.description,
                      style: AppTextStyles.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  
                  if (listing.description.isNotEmpty)
                    const SizedBox(height: 12),
                  
                  // Bottom Row - Seller Info and Location
                  if (showSellerInfo)
                    _buildBottomRow(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      child: Container(
        height: 200,
        width: double.infinity,
        color: AppColors.background,
        child: listing.hasImages
            ? CachedNetworkImage(
                imageUrl: listing.primaryImageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColors.background,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.background,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_not_supported,
                        size: 48,
                        color: AppColors.textHint,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Image not available',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
              )
            : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image,
                    size: 48,
                    color: AppColors.textHint,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'No image available',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildProductDetails() {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        // Product Category Chip
        _buildInfoChip(
          listing.productCategory,
          AppColors.primary,
        ),
        
        // Chicken Type Chip
        _buildInfoChip(
          listing.chickenType,
          AppColors.secondary,
        ),
        
        // Meat Type Chip (if applicable)
        if (listing.isMeat && listing.meatType != null)
          _buildInfoChip(
            listing.meatType!,
            AppColors.info,
          ),
        
        // Quantity Chip
        _buildInfoChip(
          '${listing.quantity} ${listing.quantityUnit}',
          AppColors.success,
        ),
        
        // Age Chip (for live chickens)
        if (listing.isLiveChicken && listing.age != null)
          _buildInfoChip(
            listing.ageDisplay,
            AppColors.warning,
          ),
      ],
    );
  }

  Widget _buildInfoChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildBottomRow() {
    return Row(
      children: [
        // Seller Info
        Expanded(
          child: Row(
            children: [
              const Icon(
                Icons.person,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  listing.sellerName,
                  style: AppTextStyles.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(width: 16),
        
        // Location
        if (listing.location.isNotEmpty)
          Row(
            children: [
              const Icon(
                Icons.location_on,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                listing.location,
                style: AppTextStyles.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        
        const SizedBox(width: 16),
        
        // Time ago
        Text(
          _getTimeAgo(listing.createdAt),
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textHint,
          ),
        ),
      ],
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).round();
      return '${weeks}w ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).round();
      return '${months}mo ago';
    } else {
      final years = (difference.inDays / 365).round();
      return '${years}y ago';
    }
  }
}

// Compact version of listing card for smaller spaces
class CompactListingCard extends StatelessWidget {
  final Listing listing;
  final VoidCallback onTap;

  const CompactListingCard({
    super.key,
    required this.listing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 60,
                  height: 60,
                  color: AppColors.background,
                  child: listing.hasImages
                      ? CachedNetworkImage(
                          imageUrl: listing.primaryImageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.image_not_supported,
                            color: AppColors.textHint,
                          ),
                        )
                      : const Icon(
                          Icons.image,
                          color: AppColors.textHint,
                        ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listing.title,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 4),
                    
                    Text(
                      '${listing.chickenType} • ${listing.productCategory}',
                      style: AppTextStyles.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 4),
                    
                    Row(
                      children: [
                        Text(
                          listing.formattedPrice,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${listing.quantity} ${listing.quantityUnit}',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
