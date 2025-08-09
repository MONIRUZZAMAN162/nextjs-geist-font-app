import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryItem {
  final String id;
  final String name;
  final String category; // Feed, Water, Medicine, Maintenance Supplies, Eggs, Live Chickens
  final String description;
  final int currentQuantity;
  final int thresholdQuantity; // Minimum quantity before low stock alert
  final String unit; // kg, liters, pieces, bags, etc.
  final double? unitPrice;
  final String? supplier;
  final String? supplierContact;
  final DateTime? lastRestocked;
  final DateTime? expiryDate;
  final String? batchNumber;
  final String? location; // Storage location
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<InventoryTransaction> transactions;
  final Map<String, dynamic>? additionalInfo;

  InventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.currentQuantity,
    required this.thresholdQuantity,
    required this.unit,
    this.unitPrice,
    this.supplier,
    this.supplierContact,
    this.lastRestocked,
    this.expiryDate,
    this.batchNumber,
    this.location,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    required this.transactions,
    this.additionalInfo,
  });

  // Factory constructor to create InventoryItem from Firestore document
  factory InventoryItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return InventoryItem(
      id: doc.id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      description: data['description'] ?? '',
      currentQuantity: data['currentQuantity'] ?? 0,
      thresholdQuantity: data['thresholdQuantity'] ?? 0,
      unit: data['unit'] ?? 'pieces',
      unitPrice: data['unitPrice']?.toDouble(),
      supplier: data['supplier'],
      supplierContact: data['supplierContact'],
      lastRestocked: (data['lastRestocked'] as Timestamp?)?.toDate(),
      expiryDate: (data['expiryDate'] as Timestamp?)?.toDate(),
      batchNumber: data['batchNumber'],
      location: data['location'],
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      transactions: (data['transactions'] as List<dynamic>?)
          ?.map((item) => InventoryTransaction.fromMap(item as Map<String, dynamic>))
          .toList() ?? [],
      additionalInfo: data['additionalInfo'],
    );
  }

  // Factory constructor to create InventoryItem from JSON
  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      currentQuantity: json['currentQuantity'] ?? 0,
      thresholdQuantity: json['thresholdQuantity'] ?? 0,
      unit: json['unit'] ?? 'pieces',
      unitPrice: json['unitPrice']?.toDouble(),
      supplier: json['supplier'],
      supplierContact: json['supplierContact'],
      lastRestocked: json['lastRestocked'] != null 
          ? DateTime.parse(json['lastRestocked']) 
          : null,
      expiryDate: json['expiryDate'] != null 
          ? DateTime.parse(json['expiryDate']) 
          : null,
      batchNumber: json['batchNumber'],
      location: json['location'],
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      transactions: (json['transactions'] as List<dynamic>?)
          ?.map((item) => InventoryTransaction.fromMap(item as Map<String, dynamic>))
          .toList() ?? [],
      additionalInfo: json['additionalInfo'],
    );
  }

  // Convert InventoryItem to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'category': category,
      'description': description,
      'currentQuantity': currentQuantity,
      'thresholdQuantity': thresholdQuantity,
      'unit': unit,
      'unitPrice': unitPrice,
      'supplier': supplier,
      'supplierContact': supplierContact,
      'lastRestocked': lastRestocked != null 
          ? Timestamp.fromDate(lastRestocked!) 
          : null,
      'expiryDate': expiryDate != null 
          ? Timestamp.fromDate(expiryDate!) 
          : null,
      'batchNumber': batchNumber,
      'location': location,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'transactions': transactions.map((transaction) => transaction.toMap()).toList(),
      'additionalInfo': additionalInfo,
    };
  }

  // Convert InventoryItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'currentQuantity': currentQuantity,
      'thresholdQuantity': thresholdQuantity,
      'unit': unit,
      'unitPrice': unitPrice,
      'supplier': supplier,
      'supplierContact': supplierContact,
      'lastRestocked': lastRestocked?.toIso8601String(),
      'expiryDate': expiryDate?.toIso8601String(),
      'batchNumber': batchNumber,
      'location': location,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'transactions': transactions.map((transaction) => transaction.toMap()).toList(),
      'additionalInfo': additionalInfo,
    };
  }

  // Create a copy of the inventory item with updated fields
  InventoryItem copyWith({
    String? id,
    String? name,
    String? category,
    String? description,
    int? currentQuantity,
    int? thresholdQuantity,
    String? unit,
    double? unitPrice,
    String? supplier,
    String? supplierContact,
    DateTime? lastRestocked,
    DateTime? expiryDate,
    String? batchNumber,
    String? location,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<InventoryTransaction>? transactions,
    Map<String, dynamic>? additionalInfo,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      currentQuantity: currentQuantity ?? this.currentQuantity,
      thresholdQuantity: thresholdQuantity ?? this.thresholdQuantity,
      unit: unit ?? this.unit,
      unitPrice: unitPrice ?? this.unitPrice,
      supplier: supplier ?? this.supplier,
      supplierContact: supplierContact ?? this.supplierContact,
      lastRestocked: lastRestocked ?? this.lastRestocked,
      expiryDate: expiryDate ?? this.expiryDate,
      batchNumber: batchNumber ?? this.batchNumber,
      location: location ?? this.location,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      transactions: transactions ?? this.transactions,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }

  // Check if item is low in stock
  bool get isLowStock => currentQuantity <= thresholdQuantity;

  // Check if item is out of stock
  bool get isOutOfStock => currentQuantity <= 0;

  // Check if item is expired
  bool get isExpired {
    if (expiryDate == null) return false;
    return DateTime.now().isAfter(expiryDate!);
  }

  // Check if item is expiring soon (within 7 days)
  bool get isExpiringSoon {
    if (expiryDate == null) return false;
    final daysUntilExpiry = expiryDate!.difference(DateTime.now()).inDays;
    return daysUntilExpiry <= 7 && daysUntilExpiry > 0;
  }

  // Get stock status
  InventoryStockStatus get stockStatus {
    if (isOutOfStock) return InventoryStockStatus.outOfStock;
    if (isLowStock) return InventoryStockStatus.lowStock;
    return InventoryStockStatus.inStock;
  }

  // Get formatted unit price string
  String get formattedUnitPrice {
    if (unitPrice == null) return 'N/A';
    return '৳${unitPrice!.toStringAsFixed(2)}';
  }

  // Get formatted total value string
  String get formattedTotalValue {
    if (unitPrice == null) return 'N/A';
    final totalValue = unitPrice! * currentQuantity;
    return '৳${totalValue.toStringAsFixed(2)}';
  }

  // Get quantity display with unit
  String get quantityDisplay => '$currentQuantity $unit';

  // Get threshold display with unit
  String get thresholdDisplay => '$thresholdQuantity $unit';

  // Get days until expiry
  int? get daysUntilExpiry {
    if (expiryDate == null) return null;
    return expiryDate!.difference(DateTime.now()).inDays;
  }

  // Get expiry status display
  String get expiryStatusDisplay {
    if (expiryDate == null) return 'No expiry date';
    
    final days = daysUntilExpiry!;
    if (days < 0) {
      return 'Expired ${(-days)} days ago';
    } else if (days == 0) {
      return 'Expires today';
    } else if (days == 1) {
      return 'Expires tomorrow';
    } else if (days <= 7) {
      return 'Expires in $days days';
    } else {
      return 'Expires on ${expiryDate!.day}/${expiryDate!.month}/${expiryDate!.year}';
    }
  }

  // Get last restocked display
  String get lastRestockedDisplay {
    if (lastRestocked == null) return 'Never restocked';
    
    final now = DateTime.now();
    final difference = now.difference(lastRestocked!);
    
    if (difference.inDays == 0) {
      return 'Restocked today';
    } else if (difference.inDays == 1) {
      return 'Restocked yesterday';
    } else if (difference.inDays < 30) {
      return 'Restocked ${difference.inDays} days ago';
    } else {
      return 'Restocked on ${lastRestocked!.day}/${lastRestocked!.month}/${lastRestocked!.year}';
    }
  }

  @override
  String toString() {
    return 'InventoryItem(id: $id, name: $name, category: $category, currentQuantity: $currentQuantity)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InventoryItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

enum InventoryStockStatus {
  inStock,
  lowStock,
  outOfStock,
}

class InventoryTransaction {
  final String type; // 'in' for stock in, 'out' for stock out
  final int quantity;
  final String reason; // 'purchase', 'sale', 'usage', 'waste', 'adjustment'
  final DateTime timestamp;
  final String? note;
  final String? performedBy;

  InventoryTransaction({
    required this.type,
    required this.quantity,
    required this.reason,
    required this.timestamp,
    this.note,
    this.performedBy,
  });

  factory InventoryTransaction.fromMap(Map<String, dynamic> map) {
    return InventoryTransaction(
      type: map['type'] ?? '',
      quantity: map['quantity'] ?? 0,
      reason: map['reason'] ?? '',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      note: map['note'],
      performedBy: map['performedBy'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'quantity': quantity,
      'reason': reason,
      'timestamp': Timestamp.fromDate(timestamp),
      'note': note,
      'performedBy': performedBy,
    };
  }

  bool get isStockIn => type == 'in';
  bool get isStockOut => type == 'out';

  @override
  String toString() {
    return 'InventoryTransaction(type: $type, quantity: $quantity, reason: $reason)';
  }
}
