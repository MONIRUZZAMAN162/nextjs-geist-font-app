import '../models/listing.dart';
import '../models/order.dart';
import '../models/inventory_item.dart';
import '../models/sensor_data.dart';

class DemoData {
  // Demo listings for testing
  static List<Listing> getDemoListings() {
    return [
      Listing(
        id: 'demo_1',
        title: 'Fresh Layer Eggs - Grade A',
        description: 'Premium quality fresh eggs from free-range layer chickens. Collected daily and stored in optimal conditions.',
        chickenType: 'Layer',
        productCategory: 'Eggs',
        price: 12.0,
        quantity: 30,
        quantityUnit: 'dozen',
        sellerId: 'seller_1',
        sellerName: 'Rahman Poultry Farm',
        sellerPhone: '+8801712345678',
        sellerEmail: 'rahman@example.com',
        contactMethod: 'Phone',
        imageUrls: [
          'https://placehold.co/400x300?text=Fresh+Layer+Eggs+Grade+A',
          'https://placehold.co/400x300?text=Premium+Quality+Eggs',
        ],
        location: 'Dhaka, Bangladesh',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      
      Listing(
        id: 'demo_2',
        title: 'Broiler Chicken Breast - Fresh Cut',
        description: 'Tender and juicy broiler chicken breast, freshly cut and ready for cooking. Perfect for grilling and roasting.',
        chickenType: 'Broiler',
        productCategory: 'Chicken Meat',
        meatType: 'Breast',
        price: 280.0,
        quantity: 5,
        quantityUnit: 'kg',
        sellerId: 'seller_2',
        sellerName: 'Karim Meat Shop',
        sellerPhone: '+8801812345678',
        sellerWhatsApp: '+8801812345678',
        contactMethod: 'WhatsApp',
        imageUrls: [
          'https://placehold.co/400x300?text=Fresh+Broiler+Chicken+Breast',
          'https://placehold.co/400x300?text=Premium+Meat+Cut',
        ],
        location: 'Chittagong, Bangladesh',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      
      Listing(
        id: 'demo_3',
        title: 'Live Deshi Chickens - 3 Months Old',
        description: 'Healthy deshi chickens, 3 months old, vaccinated and ready for sale. Great for backyard farming.',
        chickenType: 'Deshi',
        productCategory: 'Live Chicken',
        age: 90,
        price: 450.0,
        quantity: 10,
        quantityUnit: 'pieces',
        sellerId: 'seller_3',
        sellerName: 'Hasan Farm',
        sellerPhone: '+8801912345678',
        sellerEmail: 'hasan@example.com',
        contactMethod: 'Email',
        imageUrls: [
          'https://placehold.co/400x300?text=Live+Deshi+Chickens+3+Months',
          'https://placehold.co/400x300?text=Healthy+Vaccinated+Chickens',
        ],
        location: 'Sylhet, Bangladesh',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      
      Listing(
        id: 'demo_4',
        title: 'Broiler Chicken Wings - Bulk Pack',
        description: 'Fresh broiler chicken wings in bulk packaging. Perfect for restaurants and large families.',
        chickenType: 'Broiler',
        productCategory: 'Chicken Meat',
        meatType: 'Wings',
        price: 220.0,
        quantity: 3,
        quantityUnit: 'kg',
        sellerId: 'seller_4',
        sellerName: 'City Poultry',
        sellerPhone: '+8801612345678',
        contactMethod: 'Phone',
        imageUrls: [
          'https://placehold.co/400x300?text=Fresh+Broiler+Chicken+Wings',
        ],
        location: 'Rajshahi, Bangladesh',
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      
      Listing(
        id: 'demo_5',
        title: 'Layer Chicken Legs - Premium Quality',
        description: 'High-quality layer chicken legs, perfect for curry and stew preparations.',
        chickenType: 'Layer',
        productCategory: 'Chicken Meat',
        meatType: 'Leg',
        price: 250.0,
        quantity: 2,
        quantityUnit: 'kg',
        sellerId: 'seller_5',
        sellerName: 'Green Valley Farm',
        sellerPhone: '+8801512345678',
        sellerWhatsApp: '+8801512345678',
        contactMethod: 'WhatsApp',
        imageUrls: [
          'https://placehold.co/400x300?text=Premium+Layer+Chicken+Legs',
        ],
        location: 'Khulna, Bangladesh',
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 12)),
      ),
    ];
  }

  // Demo orders for testing
  static List<Order> getDemoOrders() {
    return [
      Order(
        id: 'order_1',
        listingId: 'demo_1',
        listingTitle: 'Fresh Layer Eggs - Grade A',
        buyerId: 'buyer_1',
        buyerName: 'Ahmed Hassan',
        buyerPhone: '+8801712345679',
        sellerId: 'seller_1',
        sellerName: 'Rahman Poultry Farm',
        sellerPhone: '+8801712345678',
        unitPrice: 12.0,
        quantity: 5,
        quantityUnit: 'dozen',
        totalAmount: 60.0,
        status: 'Shipped',
        trackingCode: 'EGG001234',
        estimatedDelivery: DateTime.now().add(const Duration(days: 1)),
        deliveryAddress: '123 Main Street, Dhaka',
        imageUrl: 'https://placehold.co/400x300?text=Fresh+Layer+Eggs+Grade+A',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 6)),
        statusHistory: [
          OrderStatusUpdate(
            status: 'Processed',
            timestamp: DateTime.now().subtract(const Duration(days: 2)),
            note: 'Order received and confirmed',
          ),
          OrderStatusUpdate(
            status: 'Shipped',
            timestamp: DateTime.now().subtract(const Duration(hours: 6)),
            note: 'Package dispatched for delivery',
          ),
        ],
      ),
      
      Order(
        id: 'order_2',
        listingId: 'demo_2',
        listingTitle: 'Broiler Chicken Breast - Fresh Cut',
        buyerId: 'buyer_2',
        buyerName: 'Fatima Khan',
        buyerPhone: '+8801812345679',
        sellerId: 'seller_2',
        sellerName: 'Karim Meat Shop',
        sellerPhone: '+8801812345678',
        unitPrice: 280.0,
        quantity: 2,
        quantityUnit: 'kg',
        totalAmount: 560.0,
        status: 'Delivered',
        actualDelivery: DateTime.now().subtract(const Duration(hours: 2)),
        deliveryAddress: '456 Park Avenue, Chittagong',
        imageUrl: 'https://placehold.co/400x300?text=Fresh+Broiler+Chicken+Breast',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
        statusHistory: [
          OrderStatusUpdate(
            status: 'Processed',
            timestamp: DateTime.now().subtract(const Duration(days: 3)),
            note: 'Order confirmed',
          ),
          OrderStatusUpdate(
            status: 'Shipped',
            timestamp: DateTime.now().subtract(const Duration(days: 1)),
            note: 'Out for delivery',
          ),
          OrderStatusUpdate(
            status: 'Delivered',
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
            note: 'Successfully delivered',
          ),
        ],
      ),
    ];
  }

  // Demo inventory items for testing
  static List<InventoryItem> getDemoInventoryItems() {
    return [
      InventoryItem(
        id: 'inv_1',
        name: 'Layer Feed Premium',
        category: 'Feed',
        description: 'High-quality feed for layer chickens with essential nutrients',
        currentQuantity: 45,
        thresholdQuantity: 20,
        unit: 'bags',
        unitPrice: 850.0,
        supplier: 'Feed Supply Co.',
        supplierContact: '+8801712345680',
        lastRestocked: DateTime.now().subtract(const Duration(days: 5)),
        expiryDate: DateTime.now().add(const Duration(days: 180)),
        location: 'Warehouse A',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(days: 5)),
        transactions: [
          InventoryTransaction(
            type: 'in',
            quantity: 50,
            reason: 'purchase',
            timestamp: DateTime.now().subtract(const Duration(days: 5)),
            note: 'Monthly stock replenishment',
          ),
          InventoryTransaction(
            type: 'out',
            quantity: 5,
            reason: 'usage',
            timestamp: DateTime.now().subtract(const Duration(days: 2)),
            note: 'Daily feeding',
          ),
        ],
      ),
      
      InventoryItem(
        id: 'inv_2',
        name: 'Broiler Starter Feed',
        category: 'Feed',
        description: 'Specialized starter feed for broiler chickens',
        currentQuantity: 15,
        thresholdQuantity: 25,
        unit: 'bags',
        unitPrice: 920.0,
        supplier: 'Premium Feeds Ltd.',
        supplierContact: '+8801812345680',
        lastRestocked: DateTime.now().subtract(const Duration(days: 10)),
        expiryDate: DateTime.now().add(const Duration(days: 150)),
        location: 'Warehouse B',
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        transactions: [
          InventoryTransaction(
            type: 'in',
            quantity: 30,
            reason: 'purchase',
            timestamp: DateTime.now().subtract(const Duration(days: 10)),
            note: 'Stock replenishment',
          ),
          InventoryTransaction(
            type: 'out',
            quantity: 15,
            reason: 'usage',
            timestamp: DateTime.now().subtract(const Duration(days: 1)),
            note: 'Weekly feeding',
          ),
        ],
      ),
      
      InventoryItem(
        id: 'inv_3',
        name: 'Multivitamin Supplement',
        category: 'Medicine',
        description: 'Essential vitamins and minerals for chicken health',
        currentQuantity: 8,
        thresholdQuantity: 10,
        unit: 'bottles',
        unitPrice: 450.0,
        supplier: 'Vet Supplies Inc.',
        supplierContact: '+8801912345680',
        lastRestocked: DateTime.now().subtract(const Duration(days: 15)),
        expiryDate: DateTime.now().add(const Duration(days: 365)),
        location: 'Medicine Cabinet',
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        updatedAt: DateTime.now().subtract(const Duration(days: 3)),
        transactions: [
          InventoryTransaction(
            type: 'in',
            quantity: 12,
            reason: 'purchase',
            timestamp: DateTime.now().subtract(const Duration(days: 15)),
            note: 'Monthly medicine stock',
          ),
          InventoryTransaction(
            type: 'out',
            quantity: 4,
            reason: 'usage',
            timestamp: DateTime.now().subtract(const Duration(days: 3)),
            note: 'Health maintenance',
          ),
        ],
      ),
      
      InventoryItem(
        id: 'inv_4',
        name: 'Fresh Eggs - Layer',
        category: 'Eggs',
        description: 'Fresh eggs collected from layer chickens',
        currentQuantity: 120,
        thresholdQuantity: 50,
        unit: 'dozen',
        unitPrice: 12.0,
        lastRestocked: DateTime.now().subtract(const Duration(hours: 6)),
        location: 'Cold Storage',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 6)),
        transactions: [
          InventoryTransaction(
            type: 'in',
            quantity: 150,
            reason: 'production',
            timestamp: DateTime.now().subtract(const Duration(hours: 6)),
            note: 'Daily egg collection',
          ),
          InventoryTransaction(
            type: 'out',
            quantity: 30,
            reason: 'sale',
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
            note: 'Customer orders',
          ),
        ],
      ),
    ];
  }

  // Demo sensor data for testing
  static List<SensorData> getDemoSensorData() {
    final now = DateTime.now();
    final List<SensorData> data = [];
    
    // Generate temperature data for the last 24 hours
    for (int i = 0; i < 24; i++) {
      data.add(SensorData(
        id: 'temp_$i',
        sensorType: 'temperature',
        value: 22.0 + (i % 8) + (i % 3) * 0.5,
        unit: '°C',
        timestamp: now.subtract(Duration(hours: 23 - i)),
        location: 'Coop A',
        deviceId: 'TEMP_001',
        minThreshold: 18.0,
        maxThreshold: 28.0,
      ));
    }
    
    // Generate humidity data for the last 24 hours
    for (int i = 0; i < 24; i++) {
      data.add(SensorData(
        id: 'hum_$i',
        sensorType: 'humidity',
        value: 55.0 + (i % 10) + (i % 4) * 2.0,
        unit: '%',
        timestamp: now.subtract(Duration(hours: 23 - i)),
        location: 'Coop A',
        deviceId: 'HUM_001',
        minThreshold: 40.0,
        maxThreshold: 70.0,
      ));
    }
    
    // Generate gas level data for the last 24 hours
    for (int i = 0; i < 24; i++) {
      data.add(SensorData(
        id: 'gas_$i',
        sensorType: 'gas_level',
        value: 15.0 + (i % 5) + (i % 2) * 1.5,
        unit: 'ppm',
        timestamp: now.subtract(Duration(hours: 23 - i)),
        location: 'Coop A',
        deviceId: 'GAS_001',
        minThreshold: 0.0,
        maxThreshold: 25.0,
      ));
    }
    
    return data;
  }
}
