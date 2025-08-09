import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String id;
  final String listingId;
  final String listingTitle;
  final String buyerId;
  final String buyerName;
  final String buyerPhone;
  final String? buyerEmail;
  final String sellerId;
  final String sellerName;
  final String sellerPhone;
  final double unitPrice;
  final int quantity;
  final String quantityUnit;
  final double totalAmount;
  final String status; // Processed, Shipped, Delivered, Cancelled
  final String? trackingCode;
  final DateTime? estimatedDelivery;
  final DateTime? actualDelivery;
  final String deliveryAddress;
  final String? deliveryInstructions;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OrderStatusUpdate> statusHistory;
  final Map<String, dynamic>? additionalInfo;

  Order({
    required this.id,
    required this.listingId,
    required this.listingTitle,
    required this.buyerId,
    required this.buyerName,
    required this.buyerPhone,
    this.buyerEmail,
    required this.sellerId,
    required this.sellerName,
    required this.sellerPhone,
    required this.unitPrice,
    required this.quantity,
    required this.quantityUnit,
    required this.totalAmount,
    required this.status,
    this.trackingCode,
    this.estimatedDelivery,
    this.actualDelivery,
    required this.deliveryAddress,
    this.deliveryInstructions,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.statusHistory,
    this.additionalInfo,
  });

  // Factory constructor to create Order from Firestore document
  factory Order.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return Order(
      id: doc.id,
      listingId: data['listingId'] ?? '',
      listingTitle: data['listingTitle'] ?? '',
      buyerId: data['buyerId'] ?? '',
      buyerName: data['buyerName'] ?? '',
      buyerPhone: data['buyerPhone'] ?? '',
      buyerEmail: data['buyerEmail'],
      sellerId: data['sellerId'] ?? '',
      sellerName: data['sellerName'] ?? '',
      sellerPhone: data['sellerPhone'] ?? '',
      unitPrice: (data['unitPrice'] ?? 0).toDouble(),
      quantity: data['quantity'] ?? 0,
      quantityUnit: data['quantityUnit'] ?? 'pieces',
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      status: data['status'] ?? 'Processed',
      trackingCode: data['trackingCode'],
      estimatedDelivery: (data['estimatedDelivery'] as Timestamp?)?.toDate(),
      actualDelivery: (data['actualDelivery'] as Timestamp?)?.toDate(),
      deliveryAddress: data['deliveryAddress'] ?? '',
      deliveryInstructions: data['deliveryInstructions'],
      imageUrl: data['imageUrl'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      statusHistory: (data['statusHistory'] as List<dynamic>?)
          ?.map((item) => OrderStatusUpdate.fromMap(item as Map<String, dynamic>))
          .toList() ?? [],
      additionalInfo: data['additionalInfo'],
    );
  }

  // Factory constructor to create Order from JSON
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? '',
      listingId: json['listingId'] ?? '',
      listingTitle: json['listingTitle'] ?? '',
      buyerId: json['buyerId'] ?? '',
      buyerName: json['buyerName'] ?? '',
      buyerPhone: json['buyerPhone'] ?? '',
      buyerEmail: json['buyerEmail'],
      sellerId: json['sellerId'] ?? '',
      sellerName: json['sellerName'] ?? '',
      sellerPhone: json['sellerPhone'] ?? '',
      unitPrice: (json['unitPrice'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
      quantityUnit: json['quantityUnit'] ?? 'pieces',
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      status: json['status'] ?? 'Processed',
      trackingCode: json['trackingCode'],
      estimatedDelivery: json['estimatedDelivery'] != null 
          ? DateTime.parse(json['estimatedDelivery']) 
          : null,
      actualDelivery: json['actualDelivery'] != null 
          ? DateTime.parse(json['actualDelivery']) 
          : null,
      deliveryAddress: json['deliveryAddress'] ?? '',
      deliveryInstructions: json['deliveryInstructions'],
      imageUrl: json['imageUrl'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      statusHistory: (json['statusHistory'] as List<dynamic>?)
          ?.map((item) => OrderStatusUpdate.fromMap(item as Map<String, dynamic>))
          .toList() ?? [],
      additionalInfo: json['additionalInfo'],
    );
  }

  // Convert Order to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'listingId': listingId,
      'listingTitle': listingTitle,
      'buyerId': buyerId,
      'buyerName': buyerName,
      'buyerPhone': buyerPhone,
      'buyerEmail': buyerEmail,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'sellerPhone': sellerPhone,
      'unitPrice': unitPrice,
      'quantity': quantity,
      'quantityUnit': quantityUnit,
      'totalAmount': totalAmount,
      'status': status,
      'trackingCode': trackingCode,
      'estimatedDelivery': estimatedDelivery != null 
          ? Timestamp.fromDate(estimatedDelivery!) 
          : null,
      'actualDelivery': actualDelivery != null 
          ? Timestamp.fromDate(actualDelivery!) 
          : null,
      'deliveryAddress': deliveryAddress,
      'deliveryInstructions': deliveryInstructions,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'statusHistory': statusHistory.map((update) => update.toMap()).toList(),
      'additionalInfo': additionalInfo,
    };
  }

  // Convert Order to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'listingId': listingId,
      'listingTitle': listingTitle,
      'buyerId': buyerId,
      'buyerName': buyerName,
      'buyerPhone': buyerPhone,
      'buyerEmail': buyerEmail,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'sellerPhone': sellerPhone,
      'unitPrice': unitPrice,
      'quantity': quantity,
      'quantityUnit': quantityUnit,
      'totalAmount': totalAmount,
      'status': status,
      'trackingCode': trackingCode,
      'estimatedDelivery': estimatedDelivery?.toIso8601String(),
      'actualDelivery': actualDelivery?.toIso8601String(),
      'deliveryAddress': deliveryAddress,
      'deliveryInstructions': deliveryInstructions,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'statusHistory': statusHistory.map((update) => update.toMap()).toList(),
      'additionalInfo': additionalInfo,
    };
  }

  // Create a copy of the order with updated fields
  Order copyWith({
    String? id,
    String? listingId,
    String? listingTitle,
    String? buyerId,
    String? buyerName,
    String? buyerPhone,
    String? buyerEmail,
    String? sellerId,
    String? sellerName,
    String? sellerPhone,
    double? unitPrice,
    int? quantity,
    String? quantityUnit,
    double? totalAmount,
    String? status,
    String? trackingCode,
    DateTime? estimatedDelivery,
    DateTime? actualDelivery,
    String? deliveryAddress,
    String? deliveryInstructions,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<OrderStatusUpdate>? statusHistory,
    Map<String, dynamic>? additionalInfo,
  }) {
    return Order(
      id: id ?? this.id,
      listingId: listingId ?? this.listingId,
      listingTitle: listingTitle ?? this.listingTitle,
      buyerId: buyerId ?? this.buyerId,
      buyerName: buyerName ?? this.buyerName,
      buyerPhone: buyerPhone ?? this.buyerPhone,
      buyerEmail: buyerEmail ?? this.buyerEmail,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      sellerPhone: sellerPhone ?? this.sellerPhone,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
      quantityUnit: quantityUnit ?? this.quantityUnit,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      trackingCode: trackingCode ?? this.trackingCode,
      estimatedDelivery: estimatedDelivery ?? this.estimatedDelivery,
      actualDelivery: actualDelivery ?? this.actualDelivery,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveryInstructions: deliveryInstructions ?? this.deliveryInstructions,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      statusHistory: statusHistory ?? this.statusHistory,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }

  // Get formatted total amount string
  String get formattedTotalAmount => '৳${totalAmount.toStringAsFixed(2)}';

  // Get formatted unit price string
  String get formattedUnitPrice => '৳${unitPrice.toStringAsFixed(2)}';

  // Get order image URL
  String get orderImageUrl {
    return imageUrl ?? 'https://placehold.co/400x300?text=Order+Image';
  }

  // Check if order is completed
  bool get isCompleted => status == 'Delivered';

  // Check if order is cancelled
  bool get isCancelled => status == 'Cancelled';

  // Check if order is in progress
  bool get isInProgress => status == 'Processed' || status == 'Shipped';

  // Get estimated delivery display text
  String get estimatedDeliveryDisplay {
    if (estimatedDelivery == null) return 'Not specified';
    final now = DateTime.now();
    final difference = estimatedDelivery!.difference(now).inDays;
    
    if (difference < 0) {
      return 'Overdue';
    } else if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else {
      return 'In $difference days';
    }
  }

  // Get latest status update
  OrderStatusUpdate? get latestStatusUpdate {
    if (statusHistory.isEmpty) return null;
    return statusHistory.last;
  }

  @override
  String toString() {
    return 'Order(id: $id, listingTitle: $listingTitle, status: $status, totalAmount: $totalAmount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Order && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class OrderStatusUpdate {
  final String status;
  final DateTime timestamp;
  final String? note;
  final String? updatedBy;

  OrderStatusUpdate({
    required this.status,
    required this.timestamp,
    this.note,
    this.updatedBy,
  });

  factory OrderStatusUpdate.fromMap(Map<String, dynamic> map) {
    return OrderStatusUpdate(
      status: map['status'] ?? '',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      note: map['note'],
      updatedBy: map['updatedBy'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'timestamp': Timestamp.fromDate(timestamp),
      'note': note,
      'updatedBy': updatedBy,
    };
  }

  @override
  String toString() {
    return 'OrderStatusUpdate(status: $status, timestamp: $timestamp)';
  }
}
