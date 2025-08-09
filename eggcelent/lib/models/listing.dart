import 'package:cloud_firestore/cloud_firestore.dart';

class Listing {
  final String id;
  final String title;
  final String description;
  final String chickenType; // Layer, Broiler, Deshi
  final String productCategory; // Eggs, Chicken Meat, Live Chicken
  final String? meatType; // Leg, Thigh, Breast, Wings, Ribs (for meat products)
  final double price;
  final int quantity;
  final String quantityUnit; // pieces, kg, dozen, crates
  final int? age; // in days (for live chickens)
  final String sellerId;
  final String sellerName;
  final String sellerPhone;
  final String? sellerEmail;
  final String? sellerWhatsApp;
  final String contactMethod; // Phone, WhatsApp, Email
  final String? imageUrl;
  final List<String> imageUrls;
  final String location;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? additionalInfo;

  Listing({
    required this.id,
    required this.title,
    required this.description,
    required this.chickenType,
    required this.productCategory,
    this.meatType,
    required this.price,
    required this.quantity,
    required this.quantityUnit,
    this.age,
    required this.sellerId,
    required this.sellerName,
    required this.sellerPhone,
    this.sellerEmail,
    this.sellerWhatsApp,
    required this.contactMethod,
    this.imageUrl,
    required this.imageUrls,
    required this.location,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.additionalInfo,
  });

  // Factory constructor to create Listing from Firestore document
  factory Listing.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return Listing(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      chickenType: data['chickenType'] ?? '',
      productCategory: data['productCategory'] ?? '',
      meatType: data['meatType'],
      price: (data['price'] ?? 0).toDouble(),
      quantity: data['quantity'] ?? 0,
      quantityUnit: data['quantityUnit'] ?? 'pieces',
      age: data['age'],
      sellerId: data['sellerId'] ?? '',
      sellerName: data['sellerName'] ?? '',
      sellerPhone: data['sellerPhone'] ?? '',
      sellerEmail: data['sellerEmail'],
      sellerWhatsApp: data['sellerWhatsApp'],
      contactMethod: data['contactMethod'] ?? 'Phone',
      imageUrl: data['imageUrl'],
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      location: data['location'] ?? '',
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      additionalInfo: data['additionalInfo'],
    );
  }

  // Factory constructor to create Listing from JSON
  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      chickenType: json['chickenType'] ?? '',
      productCategory: json['productCategory'] ?? '',
      meatType: json['meatType'],
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
      quantityUnit: json['quantityUnit'] ?? 'pieces',
      age: json['age'],
      sellerId: json['sellerId'] ?? '',
      sellerName: json['sellerName'] ?? '',
      sellerPhone: json['sellerPhone'] ?? '',
      sellerEmail: json['sellerEmail'],
      sellerWhatsApp: json['sellerWhatsApp'],
      contactMethod: json['contactMethod'] ?? 'Phone',
      imageUrl: json['imageUrl'],
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      location: json['location'] ?? '',
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      additionalInfo: json['additionalInfo'],
    );
  }

  // Convert Listing to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'chickenType': chickenType,
      'productCategory': productCategory,
      'meatType': meatType,
      'price': price,
      'quantity': quantity,
      'quantityUnit': quantityUnit,
      'age': age,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'sellerPhone': sellerPhone,
      'sellerEmail': sellerEmail,
      'sellerWhatsApp': sellerWhatsApp,
      'contactMethod': contactMethod,
      'imageUrl': imageUrl,
      'imageUrls': imageUrls,
      'location': location,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'additionalInfo': additionalInfo,
    };
  }

  // Convert Listing to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'chickenType': chickenType,
      'productCategory': productCategory,
      'meatType': meatType,
      'price': price,
      'quantity': quantity,
      'quantityUnit': quantityUnit,
      'age': age,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'sellerPhone': sellerPhone,
      'sellerEmail': sellerEmail,
      'sellerWhatsApp': sellerWhatsApp,
      'contactMethod': contactMethod,
      'imageUrl': imageUrl,
      'imageUrls': imageUrls,
      'location': location,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'additionalInfo': additionalInfo,
    };
  }

  // Create a copy of the listing with updated fields
  Listing copyWith({
    String? id,
    String? title,
    String? description,
    String? chickenType,
    String? productCategory,
    String? meatType,
    double? price,
    int? quantity,
    String? quantityUnit,
    int? age,
    String? sellerId,
    String? sellerName,
    String? sellerPhone,
    String? sellerEmail,
    String? sellerWhatsApp,
    String? contactMethod,
    String? imageUrl,
    List<String>? imageUrls,
    String? location,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? additionalInfo,
  }) {
    return Listing(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      chickenType: chickenType ?? this.chickenType,
      productCategory: productCategory ?? this.productCategory,
      meatType: meatType ?? this.meatType,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      quantityUnit: quantityUnit ?? this.quantityUnit,
      age: age ?? this.age,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      sellerPhone: sellerPhone ?? this.sellerPhone,
      sellerEmail: sellerEmail ?? this.sellerEmail,
      sellerWhatsApp: sellerWhatsApp ?? this.sellerWhatsApp,
      contactMethod: contactMethod ?? this.contactMethod,
      imageUrl: imageUrl ?? this.imageUrl,
      imageUrls: imageUrls ?? this.imageUrls,
      location: location ?? this.location,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }

  // Get formatted price string
  String get formattedPrice => '৳${price.toStringAsFixed(2)}';

  // Get primary image URL
  String get primaryImageUrl {
    if (imageUrls.isNotEmpty) {
      return imageUrls.first;
    }
    return imageUrl ?? 'https://placehold.co/400x300?text=No+Image+Available';
  }

  // Check if listing has images
  bool get hasImages => imageUrls.isNotEmpty || imageUrl != null;

  // Get contact display text
  String get contactDisplay {
    switch (contactMethod) {
      case 'WhatsApp':
        return sellerWhatsApp ?? sellerPhone;
      case 'Email':
        return sellerEmail ?? sellerPhone;
      default:
        return sellerPhone;
    }
  }

  // Get age display text
  String get ageDisplay {
    if (age == null) return 'N/A';
    if (age! < 30) {
      return '$age days';
    } else if (age! < 365) {
      final weeks = (age! / 7).round();
      return '$weeks weeks';
    } else {
      final years = (age! / 365).round();
      return '$years years';
    }
  }

  // Check if listing is for live chickens
  bool get isLiveChicken => productCategory == 'Live Chicken';

  // Check if listing is for eggs
  bool get isEggs => productCategory == 'Eggs';

  // Check if listing is for meat
  bool get isMeat => productCategory == 'Chicken Meat';

  @override
  String toString() {
    return 'Listing(id: $id, title: $title, chickenType: $chickenType, price: $price, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Listing && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
