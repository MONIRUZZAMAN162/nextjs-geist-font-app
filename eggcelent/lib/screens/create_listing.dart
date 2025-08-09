import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../models/listing.dart';
import '../services/firebase_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/constants.dart';
import '../utils/error_handling.dart';

class CreateListingScreen extends StatefulWidget {
  final Listing? existingListing; // For editing existing listings

  const CreateListingScreen({
    super.key,
    this.existingListing,
  });

  @override
  State<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends State<CreateListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _ageController = TextEditingController();
  final _sellerNameController = TextEditingController();
  final _sellerPhoneController = TextEditingController();
  final _sellerEmailController = TextEditingController();
  final _sellerWhatsAppController = TextEditingController();
  final _locationController = TextEditingController();

  String _selectedProductCategory = AppConstants.productCategories.first;
  String _selectedChickenType = AppConstants.chickenTypes.first;
  String? _selectedMeatType;
  String _selectedQuantityUnit = AppConstants.quantityUnits.first;
  String _selectedContactMethod = AppConstants.contactMethods.first;

  List<XFile> _selectedImages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingListing != null) {
      _populateFieldsFromExistingListing();
    }
  }

  void _populateFieldsFromExistingListing() {
    final listing = widget.existingListing!;
    _titleController.text = listing.title;
    _descriptionController.text = listing.description;
    _priceController.text = listing.price.toString();
    _quantityController.text = listing.quantity.toString();
    _ageController.text = listing.age?.toString() ?? '';
    _sellerNameController.text = listing.sellerName;
    _sellerPhoneController.text = listing.sellerPhone;
    _sellerEmailController.text = listing.sellerEmail ?? '';
    _sellerWhatsAppController.text = listing.sellerWhatsApp ?? '';
    _locationController.text = listing.location;

    _selectedProductCategory = listing.productCategory;
    _selectedChickenType = listing.chickenType;
    _selectedMeatType = listing.meatType;
    _selectedQuantityUnit = listing.quantityUnit;
    _selectedContactMethod = listing.contactMethod;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _ageController.dispose();
    _sellerNameController.dispose();
    _sellerPhoneController.dispose();
    _sellerEmailController.dispose();
    _sellerWhatsAppController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingListing != null ? 'Edit Listing' : 'Create Listing'),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Images Section
              _buildImagesSection(),
              
              const SizedBox(height: 24),
              
              // Basic Information
              _buildBasicInformationSection(),
              
              const SizedBox(height: 24),
              
              // Product Details
              _buildProductDetailsSection(),
              
              const SizedBox(height: 24),
              
              // Seller Information
              _buildSellerInformationSection(),
              
              const SizedBox(height: 32),
              
              // Submit Button
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Product Images',
              style: AppTextStyles.heading4,
            ),
            const SizedBox(height: 8),
            const Text(
              'Add up to 5 images to showcase your product',
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: 16),
            
            // Image Grid
            if (_selectedImages.isNotEmpty)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _selectedImages.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: FileImage(_selectedImages[index] as dynamic),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _removeImage(index),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            
            const SizedBox(height: 16),
            
            // Add Image Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _selectedImages.length < 5 ? () => _pickImage(ImageSource.camera) : null,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _selectedImages.length < 5 ? () => _pickImage(ImageSource.gallery) : null,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInformationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Basic Information',
              style: AppTextStyles.heading4,
            ),
            const SizedBox(height: 16),
            
            // Title
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title *',
                hintText: 'e.g., Fresh Layer Eggs - Grade A',
                border: OutlineInputBorder(),
              ),
              validator: (value) => ErrorHandler.validateRequired(value, 'Title'),
              maxLength: 100,
            ),
            
            const SizedBox(height: 16),
            
            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Describe your product in detail...',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
              maxLength: 500,
            ),
            
            const SizedBox(height: 16),
            
            // Location
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location *',
                hintText: 'e.g., Dhaka, Chittagong',
                border: OutlineInputBorder(),
              ),
              validator: (value) => ErrorHandler.validateRequired(value, 'Location'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductDetailsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Product Details',
              style: AppTextStyles.heading4,
            ),
            const SizedBox(height: 16),
            
            // Product Category
            DropdownButtonFormField<String>(
              value: _selectedProductCategory,
              decoration: const InputDecoration(
                labelText: 'Product Category *',
                border: OutlineInputBorder(),
              ),
              items: AppConstants.productCategories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedProductCategory = value!;
                  _selectedMeatType = null; // Reset meat type when category changes
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // Chicken Type
            DropdownButtonFormField<String>(
              value: _selectedChickenType,
              decoration: const InputDecoration(
                labelText: 'Chicken Type *',
                border: OutlineInputBorder(),
              ),
              items: AppConstants.chickenTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedChickenType = value!;
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // Meat Type (only for chicken meat)
            if (_selectedProductCategory == 'Chicken Meat')
              Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedMeatType,
                    decoration: const InputDecoration(
                      labelText: 'Meat Type *',
                      border: OutlineInputBorder(),
                    ),
                    items: AppConstants.meatTypes.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedMeatType = value;
                      });
                    },
                    validator: _selectedProductCategory == 'Chicken Meat'
                        ? (value) => ErrorHandler.validateRequired(value, 'Meat Type')
                        : null,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            
            // Price and Quantity Row
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price (৳) *',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: ErrorHandler.validatePrice,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _quantityController,
                    decoration: const InputDecoration(
                      labelText: 'Quantity *',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: ErrorHandler.validateQuantity,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Quantity Unit
            DropdownButtonFormField<String>(
              value: _selectedQuantityUnit,
              decoration: const InputDecoration(
                labelText: 'Unit *',
                border: OutlineInputBorder(),
              ),
              items: AppConstants.quantityUnits.map((unit) {
                return DropdownMenuItem(
                  value: unit,
                  child: Text(unit),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedQuantityUnit = value!;
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // Age (only for live chickens)
            if (_selectedProductCategory == 'Live Chicken')
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'Age (days) *',
                  hintText: 'Enter age in days',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: _selectedProductCategory == 'Live Chicken'
                    ? ErrorHandler.validateAge
                    : null,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSellerInformationSection() {
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
            const SizedBox(height: 16),
            
            // Seller Name
            TextFormField(
              controller: _sellerNameController,
              decoration: const InputDecoration(
                labelText: 'Your Name *',
                border: OutlineInputBorder(),
              ),
              validator: (value) => ErrorHandler.validateRequired(value, 'Name'),
            ),
            
            const SizedBox(height: 16),
            
            // Phone Number
            TextFormField(
              controller: _sellerPhoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number *',
                hintText: '+8801XXXXXXXXX',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              validator: ErrorHandler.validatePhone,
            ),
            
            const SizedBox(height: 16),
            
            // Preferred Contact Method
            DropdownButtonFormField<String>(
              value: _selectedContactMethod,
              decoration: const InputDecoration(
                labelText: 'Preferred Contact Method *',
                border: OutlineInputBorder(),
              ),
              items: AppConstants.contactMethods.map((method) {
                return DropdownMenuItem(
                  value: method,
                  child: Text(method),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedContactMethod = value!;
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // WhatsApp Number (if WhatsApp is selected)
            if (_selectedContactMethod == 'WhatsApp')
              TextFormField(
                controller: _sellerWhatsAppController,
                decoration: const InputDecoration(
                  labelText: 'WhatsApp Number',
                  hintText: '+8801XXXXXXXXX',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: _selectedContactMethod == 'WhatsApp'
                    ? ErrorHandler.validatePhone
                    : null,
              ),
            
            // Email (if Email is selected)
            if (_selectedContactMethod == 'Email')
              TextFormField(
                controller: _sellerEmailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'your.email@example.com',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: _selectedContactMethod == 'Email'
                    ? ErrorHandler.validateEmail
                    : null,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitListing,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: _isLoading
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Text('Publishing...'),
                ],
              )
            : Text(widget.existingListing != null ? 'Update Listing' : 'Publish Listing'),
      ),
    );
  }

  void _pickImage(ImageSource source) async {
    try {
      final firebaseService = Provider.of<FirebaseService>(context, listen: false);
      final XFile? image = await firebaseService.pickImage(source: source);
      
      if (image != null) {
        setState(() {
          _selectedImages.add(image);
        });
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.showErrorSnackBar(
          context,
          'Failed to pick image: ${e.toString()}',
        );
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _submitListing() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedImages.isEmpty && widget.existingListing == null) {
      ErrorHandler.showWarningSnackBar(
        context,
        'Please add at least one image for your listing',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final firebaseService = Provider.of<FirebaseService>(context, listen: false);
      
      // Upload images
      List<String> imageUrls = [];
      for (XFile imageFile in _selectedImages) {
        final imageUrl = await firebaseService.uploadListingImage(imageFile);
        imageUrls.add(imageUrl);
      }

      // Create listing object
      final listing = Listing(
        id: widget.existingListing?.id ?? '',
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        chickenType: _selectedChickenType,
        productCategory: _selectedProductCategory,
        meatType: _selectedMeatType,
        price: double.parse(_priceController.text.trim()),
        quantity: int.parse(_quantityController.text.trim()),
        quantityUnit: _selectedQuantityUnit,
        age: _selectedProductCategory == 'Live Chicken' 
            ? int.tryParse(_ageController.text.trim()) 
            : null,
        sellerId: 'current_user_id', // In a real app, get from auth
        sellerName: _sellerNameController.text.trim(),
        sellerPhone: _sellerPhoneController.text.trim(),
        sellerEmail: _sellerEmailController.text.trim().isEmpty 
            ? null 
            : _sellerEmailController.text.trim(),
        sellerWhatsApp: _sellerWhatsAppController.text.trim().isEmpty 
            ? null 
            : _sellerWhatsAppController.text.trim(),
        contactMethod: _selectedContactMethod,
        imageUrls: imageUrls,
        location: _locationController.text.trim(),
        createdAt: widget.existingListing?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save to Firebase
      if (widget.existingListing != null) {
        await firebaseService.updateListing(widget.existingListing!.id, listing);
        if (mounted) {
          ErrorHandler.showSuccessSnackBar(context, AppConstants.listingUpdatedMessage);
        }
      } else {
        await firebaseService.createListing(listing);
        if (mounted) {
          ErrorHandler.showSuccessSnackBar(context, AppConstants.listingCreatedMessage);
        }
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.showErrorSnackBar(
          context,
          ErrorHandler.handleGeneralException(e as Exception),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
