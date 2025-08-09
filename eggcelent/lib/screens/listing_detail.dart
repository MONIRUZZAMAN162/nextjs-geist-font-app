import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/listing.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/error_handling.dart';

class ListingDetailScreen extends StatefulWidget {
  final Listing listing;

  const ListingDetailScreen({
    super.key,
    required this.listing,
  });

  @override
  State<ListingDetailScreen> createState() => _ListingDetailScreenState();
}

class _ListingDetailScreenState extends State<ListingDetailScreen> {
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.listing.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareListing,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Gallery
            _buildImageGallery(),
            
            // Listing Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Price
                  _buildTitleAndPrice(),
                  
                  const SizedBox(height: 16),
                  
                  // Product Information
                  _buildProductInformation(),
                  
                  const SizedBox(height: 16),
                  
                  // Description
                  _buildDescription(),
                  
                  const SizedBox(height: 16),
                  
                  // Seller Information
                  _buildSellerInformation(),
                  
                  const SizedBox(height: 24),
                  
                  // Contact Actions
                  _buildContactActions(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGallery() {
    final images = widget.listing.imageUrls.isNotEmpty 
        ? widget.listing.imageUrls 
        : [widget.listing.primaryImageUrl];

    return Container(
      height: 300,
      color: AppColors.background,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _showFullScreenImage(images, index),
                child: CachedNetworkImage(
                  imageUrl: images[index],
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
                          size: 64,
                          color: AppColors.textHint,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Image not available',
                          style: AppTextStyles.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Image indicators
          if (images.length > 1)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: images.asMap().entries.map((entry) {
                  return Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentImageIndex == entry.key
                          ? Colors.white
                          : Colors.white.withOpacity(0.4),
                    ),
                  );
                }).toList(),
              ),
            ),
          
          // Image counter
          if (images.length > 1)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_currentImageIndex + 1}/${images.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTitleAndPrice() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.listing.title,
                style: AppTextStyles.heading2,
              ),
              const SizedBox(height: 4),
              Text(
                'Posted ${_getTimeAgo(widget.listing.createdAt)}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.3),
            ),
          ),
          child: Text(
            widget.listing.formattedPrice,
            style: AppTextStyles.heading3.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductInformation() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Product Information',
              style: AppTextStyles.heading4,
            ),
            const SizedBox(height: 12),
            
            _buildInfoRow('Category', widget.listing.productCategory),
            _buildInfoRow('Chicken Type', widget.listing.chickenType),
            
            if (widget.listing.isMeat && widget.listing.meatType != null)
              _buildInfoRow('Meat Type', widget.listing.meatType!),
            
            _buildInfoRow('Quantity', '${widget.listing.quantity} ${widget.listing.quantityUnit}'),
            
            if (widget.listing.isLiveChicken && widget.listing.age != null)
              _buildInfoRow('Age', widget.listing.ageDisplay),
            
            if (widget.listing.location.isNotEmpty)
              _buildInfoRow('Location', widget.listing.location),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const Text(': ', style: AppTextStyles.bodyMedium),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    if (widget.listing.description.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Description',
              style: AppTextStyles.heading4,
            ),
            const SizedBox(height: 12),
            Text(
              widget.listing.description,
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSellerInformation() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Seller Information',
              style: AppTextStyles.heading4,
            ),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.listing.sellerName,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Preferred contact: ${widget.listing.contactMethod}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactActions() {
    return Column(
      children: [
        // Primary contact button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _contactSeller,
            icon: Icon(_getContactIcon()),
            label: Text('Contact via ${widget.listing.contactMethod}'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Alternative contact methods
        Row(
          children: [
            // Phone button
            if (widget.listing.contactMethod != 'Phone')
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _makePhoneCall(widget.listing.sellerPhone),
                  icon: const Icon(Icons.phone),
                  label: const Text('Call'),
                ),
              ),
            
            if (widget.listing.contactMethod != 'Phone' && 
                widget.listing.sellerWhatsApp != null)
              const SizedBox(width: 8),
            
            // WhatsApp button
            if (widget.listing.sellerWhatsApp != null && 
                widget.listing.contactMethod != 'WhatsApp')
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _openWhatsApp(widget.listing.sellerWhatsApp!),
                  icon: const Icon(Icons.chat),
                  label: const Text('WhatsApp'),
                ),
              ),
          ],
        ),
        
        const SizedBox(height: 8),
        
        // Copy contact info
        TextButton.icon(
          onPressed: _copyContactInfo,
          icon: const Icon(Icons.copy),
          label: const Text('Copy Contact Info'),
        ),
      ],
    );
  }

  IconData _getContactIcon() {
    switch (widget.listing.contactMethod) {
      case 'WhatsApp':
        return Icons.chat;
      case 'Email':
        return Icons.email;
      default:
        return Icons.phone;
    }
  }

  void _contactSeller() {
    switch (widget.listing.contactMethod) {
      case 'WhatsApp':
        if (widget.listing.sellerWhatsApp != null) {
          _openWhatsApp(widget.listing.sellerWhatsApp!);
        } else {
          _makePhoneCall(widget.listing.sellerPhone);
        }
        break;
      case 'Email':
        if (widget.listing.sellerEmail != null) {
          _sendEmail(widget.listing.sellerEmail!);
        } else {
          _makePhoneCall(widget.listing.sellerPhone);
        }
        break;
      default:
        _makePhoneCall(widget.listing.sellerPhone);
        break;
    }
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        if (mounted) {
          ErrorHandler.showErrorSnackBar(context, 'Cannot make phone calls on this device');
        }
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.showErrorSnackBar(context, 'Failed to make phone call');
      }
    }
  }

  void _openWhatsApp(String phoneNumber) async {
    final String message = 'Hi, I\'m interested in your listing: ${widget.listing.title}';
    final Uri whatsappUri = Uri.parse('https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}');
    
    try {
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ErrorHandler.showErrorSnackBar(context, 'WhatsApp is not installed');
        }
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.showErrorSnackBar(context, 'Failed to open WhatsApp');
      }
    }
  }

  void _sendEmail(String email) async {
    final String subject = 'Inquiry about: ${widget.listing.title}';
    final String body = 'Hi ${widget.listing.sellerName},\n\nI\'m interested in your listing: ${widget.listing.title}\n\nPlease let me know if it\'s still available.\n\nThanks!';
    
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
    );
    
    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        if (mounted) {
          ErrorHandler.showErrorSnackBar(context, 'No email app found');
        }
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.showErrorSnackBar(context, 'Failed to open email app');
      }
    }
  }

  void _copyContactInfo() {
    final String contactInfo = '''
Seller: ${widget.listing.sellerName}
Phone: ${widget.listing.sellerPhone}
${widget.listing.sellerWhatsApp != null ? 'WhatsApp: ${widget.listing.sellerWhatsApp}' : ''}
${widget.listing.sellerEmail != null ? 'Email: ${widget.listing.sellerEmail}' : ''}
Listing: ${widget.listing.title}
''';

    Clipboard.setData(ClipboardData(text: contactInfo.trim()));
    
    if (mounted) {
      ErrorHandler.showSuccessSnackBar(context, 'Contact info copied to clipboard');
    }
  }

  void _shareListing() {
    final String shareText = '''
Check out this listing on Eggcelent:

${widget.listing.title}
${widget.listing.formattedPrice}
${widget.listing.chickenType} • ${widget.listing.productCategory}

Contact: ${widget.listing.sellerName}
Phone: ${widget.listing.sellerPhone}
''';

    // Note: In a real app, you would use the share_plus package
    Clipboard.setData(ClipboardData(text: shareText.trim()));
    
    if (mounted) {
      ErrorHandler.showSuccessSnackBar(context, 'Listing details copied to clipboard');
    }
  }

  void _showFullScreenImage(List<String> images, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImageGallery(
          images: images,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return 'on ${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}

class FullScreenImageGallery extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const FullScreenImageGallery({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  State<FullScreenImageGallery> createState() => _FullScreenImageGalleryState();
}

class _FullScreenImageGalleryState extends State<FullScreenImageGallery> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text('${_currentIndex + 1} of ${widget.images.length}'),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.images.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return InteractiveViewer(
            child: Center(
              child: CachedNetworkImage(
                imageUrl: widget.images[index],
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
                errorWidget: (context, url, error) => const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error,
                        color: Colors.white,
                        size: 64,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Failed to load image',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
