import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:image_picker/image_picker.dart';
import '../models/listing.dart';
import '../models/order.dart';
import '../models/inventory_item.dart';
import '../models/sensor_data.dart';
import '../utils/constants.dart';
import '../utils/error_handling.dart';

class FirebaseService {
  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Firebase Storage instance
  final FirebaseStorage _storage = FirebaseStorage.instance;
  
  // Firebase Messaging instance
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Image picker instance
  final ImagePicker _imagePicker = ImagePicker();

  // ==================== LISTING OPERATIONS ====================

  // Get all listings with real-time updates
  Stream<List<Listing>> getListingsStream({
    String? category,
    String? chickenType,
    double? maxPrice,
    int limit = 20,
  }) {
    Query query = _firestore
        .collection(AppConstants.listingsCollection)
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true);

    if (category != null) {
      query = query.where('productCategory', isEqualTo: category);
    }
    
    if (chickenType != null) {
      query = query.where('chickenType', isEqualTo: chickenType);
    }
    
    if (maxPrice != null) {
      query = query.where('price', isLessThanOrEqualTo: maxPrice);
    }

    query = query.limit(limit);

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Listing.fromFirestore(doc)).toList();
    });
  }

  // Get single listing by ID
  Future<Listing?> getListingById(String listingId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.listingsCollection)
          .doc(listingId)
          .get();
      
      if (doc.exists) {
        return Listing.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      ErrorHandler.logError('getListingById', e as Exception);
      rethrow;
    }
  }

  // Create new listing
  Future<String> createListing(Listing listing) async {
    try {
      final docRef = await _firestore
          .collection(AppConstants.listingsCollection)
          .add(listing.toFirestore());
      
      // Send notification to interested users
      await _sendNewListingNotification(listing);
      
      return docRef.id;
    } catch (e) {
      ErrorHandler.logError('createListing', e as Exception);
      rethrow;
    }
  }

  // Update existing listing
  Future<void> updateListing(String listingId, Listing listing) async {
    try {
      await _firestore
          .collection(AppConstants.listingsCollection)
          .doc(listingId)
          .update(listing.toFirestore());
    } catch (e) {
      ErrorHandler.logError('updateListing', e as Exception);
      rethrow;
    }
  }

  // Delete listing
  Future<void> deleteListing(String listingId) async {
    try {
      await _firestore
          .collection(AppConstants.listingsCollection)
          .doc(listingId)
          .update({'isActive': false});
    } catch (e) {
      ErrorHandler.logError('deleteListing', e as Exception);
      rethrow;
    }
  }

  // Search listings
  Future<List<Listing>> searchListings(String searchTerm) async {
    try {
      // Note: Firestore doesn't support full-text search natively
      // This is a basic implementation - consider using Algolia or similar for production
      final snapshot = await _firestore
          .collection(AppConstants.listingsCollection)
          .where('isActive', isEqualTo: true)
          .get();

      final listings = snapshot.docs
          .map((doc) => Listing.fromFirestore(doc))
          .where((listing) =>
              listing.title.toLowerCase().contains(searchTerm.toLowerCase()) ||
              listing.description.toLowerCase().contains(searchTerm.toLowerCase()) ||
              listing.chickenType.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();

      return listings;
    } catch (e) {
      ErrorHandler.logError('searchListings', e as Exception);
      rethrow;
    }
  }

  // ==================== ORDER OPERATIONS ====================

  // Get orders stream for a user
  Stream<List<Order>> getOrdersStream({String? userId, bool? isBuyer}) {
    Query query = _firestore
        .collection(AppConstants.ordersCollection)
        .orderBy('createdAt', descending: true);

    if (userId != null && isBuyer == true) {
      query = query.where('buyerId', isEqualTo: userId);
    } else if (userId != null && isBuyer == false) {
      query = query.where('sellerId', isEqualTo: userId);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Order.fromFirestore(doc)).toList();
    });
  }

  // Get single order by ID
  Future<Order?> getOrderById(String orderId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.ordersCollection)
          .doc(orderId)
          .get();
      
      if (doc.exists) {
        return Order.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      ErrorHandler.logError('getOrderById', e as Exception);
      rethrow;
    }
  }

  // Create new order
  Future<String> createOrder(Order order) async {
    try {
      final docRef = await _firestore
          .collection(AppConstants.ordersCollection)
          .add(order.toFirestore());
      
      // Send notification to seller
      await _sendNewOrderNotification(order);
      
      return docRef.id;
    } catch (e) {
      ErrorHandler.logError('createOrder', e as Exception);
      rethrow;
    }
  }

  // Update order status
  Future<void> updateOrderStatus(String orderId, String newStatus, {String? note}) async {
    try {
      final order = await getOrderById(orderId);
      if (order == null) throw Exception('Order not found');

      final statusUpdate = OrderStatusUpdate(
        status: newStatus,
        timestamp: DateTime.now(),
        note: note,
      );

      final updatedHistory = [...order.statusHistory, statusUpdate];

      await _firestore
          .collection(AppConstants.ordersCollection)
          .doc(orderId)
          .update({
        'status': newStatus,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
        'statusHistory': updatedHistory.map((update) => update.toMap()).toList(),
      });

      // Send notification about status update
      await _sendOrderUpdateNotification(order.copyWith(status: newStatus));
    } catch (e) {
      ErrorHandler.logError('updateOrderStatus', e as Exception);
      rethrow;
    }
  }

  // ==================== INVENTORY OPERATIONS ====================

  // Get inventory items stream
  Stream<List<InventoryItem>> getInventoryStream({String? category}) {
    Query query = _firestore
        .collection(AppConstants.inventoryCollection)
        .where('isActive', isEqualTo: true)
        .orderBy('name');

    if (category != null) {
      query = query.where('category', isEqualTo: category);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => InventoryItem.fromFirestore(doc)).toList();
    });
  }

  // Get low stock items
  Stream<List<InventoryItem>> getLowStockItemsStream() {
    return _firestore
        .collection(AppConstants.inventoryCollection)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => InventoryItem.fromFirestore(doc))
          .where((item) => item.isLowStock)
          .toList();
    });
  }

  // Create inventory item
  Future<String> createInventoryItem(InventoryItem item) async {
    try {
      final docRef = await _firestore
          .collection(AppConstants.inventoryCollection)
          .add(item.toFirestore());
      
      return docRef.id;
    } catch (e) {
      ErrorHandler.logError('createInventoryItem', e as Exception);
      rethrow;
    }
  }

  // Update inventory item
  Future<void> updateInventoryItem(String itemId, InventoryItem item) async {
    try {
      await _firestore
          .collection(AppConstants.inventoryCollection)
          .doc(itemId)
          .update(item.toFirestore());
    } catch (e) {
      ErrorHandler.logError('updateInventoryItem', e as Exception);
      rethrow;
    }
  }

  // Update inventory quantity
  Future<void> updateInventoryQuantity(
    String itemId, 
    int newQuantity, 
    String transactionType, 
    String reason, 
    {String? note}
  ) async {
    try {
      final item = await getInventoryItemById(itemId);
      if (item == null) throw Exception('Inventory item not found');

      final transaction = InventoryTransaction(
        type: transactionType,
        quantity: (newQuantity - item.currentQuantity).abs(),
        reason: reason,
        timestamp: DateTime.now(),
        note: note,
      );

      final updatedTransactions = [...item.transactions, transaction];

      await _firestore
          .collection(AppConstants.inventoryCollection)
          .doc(itemId)
          .update({
        'currentQuantity': newQuantity,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
        'transactions': updatedTransactions.map((t) => t.toMap()).toList(),
      });

      // Check if item is now low stock and send notification
      if (newQuantity <= item.thresholdQuantity) {
        await _sendLowStockNotification(item.copyWith(currentQuantity: newQuantity));
      }
    } catch (e) {
      ErrorHandler.logError('updateInventoryQuantity', e as Exception);
      rethrow;
    }
  }

  // Get inventory item by ID
  Future<InventoryItem?> getInventoryItemById(String itemId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.inventoryCollection)
          .doc(itemId)
          .get();
      
      if (doc.exists) {
        return InventoryItem.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      ErrorHandler.logError('getInventoryItemById', e as Exception);
      rethrow;
    }
  }

  // ==================== SENSOR DATA OPERATIONS ====================

  // Get sensor data stream
  Stream<List<SensorData>> getSensorDataStream({
    String? sensorType,
    DateTime? startDate,
    DateTime? endDate,
    int limit = 100,
  }) {
    Query query = _firestore
        .collection(AppConstants.sensorDataCollection)
        .orderBy('timestamp', descending: true);

    if (sensorType != null) {
      query = query.where('sensorType', isEqualTo: sensorType);
    }

    if (startDate != null) {
      query = query.where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate));
    }

    if (endDate != null) {
      query = query.where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endDate));
    }

    query = query.limit(limit);

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => SensorData.fromFirestore(doc)).toList();
    });
  }

  // Add sensor data
  Future<String> addSensorData(SensorData sensorData) async {
    try {
      final docRef = await _firestore
          .collection(AppConstants.sensorDataCollection)
          .add(sensorData.toFirestore());
      
      return docRef.id;
    } catch (e) {
      ErrorHandler.logError('addSensorData', e as Exception);
      rethrow;
    }
  }

  // Get latest sensor readings
  Future<Map<String, SensorData>> getLatestSensorReadings() async {
    try {
      final Map<String, SensorData> latestReadings = {};
      
      for (String sensorType in AppConstants.sensorTypes) {
        final snapshot = await _firestore
            .collection(AppConstants.sensorDataCollection)
            .where('sensorType', isEqualTo: sensorType)
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();
        
        if (snapshot.docs.isNotEmpty) {
          latestReadings[sensorType] = SensorData.fromFirestore(snapshot.docs.first);
        }
      }
      
      return latestReadings;
    } catch (e) {
      ErrorHandler.logError('getLatestSensorReadings', e as Exception);
      rethrow;
    }
  }

  // ==================== IMAGE OPERATIONS ====================

  // Pick image from gallery or camera
  Future<XFile?> pickImage({ImageSource source = ImageSource.gallery}) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      return image;
    } catch (e) {
      ErrorHandler.logError('pickImage', e as Exception);
      rethrow;
    }
  }

  // Upload image to Firebase Storage
  Future<String> uploadImage(XFile imageFile, String path) async {
    try {
      final File file = File(imageFile.path);
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}_${imageFile.name}';
      final Reference ref = _storage.ref().child(path).child(fileName);
      
      final UploadTask uploadTask = ref.putFile(file);
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      ErrorHandler.logError('uploadImage', e as Exception);
      rethrow;
    }
  }

  // Upload listing image
  Future<String> uploadListingImage(XFile imageFile) async {
    return await uploadImage(imageFile, AppConstants.listingImagesPath);
  }

  // Delete image from Firebase Storage
  Future<void> deleteImage(String imageUrl) async {
    try {
      final Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      ErrorHandler.logError('deleteImage', e as Exception);
      // Don't rethrow - image deletion failure shouldn't break the app
    }
  }

  // ==================== NOTIFICATION OPERATIONS ====================

  // Send new listing notification
  Future<void> _sendNewListingNotification(Listing listing) async {
    try {
      // In a real app, you would send this to users who are interested in this type of product
      // For now, we'll just log it
      print('New listing notification: ${listing.title}');
    } catch (e) {
      ErrorHandler.logError('_sendNewListingNotification', e as Exception);
    }
  }

  // Send new order notification
  Future<void> _sendNewOrderNotification(Order order) async {
    try {
      // Send notification to seller
      print('New order notification for seller: ${order.sellerName}');
    } catch (e) {
      ErrorHandler.logError('_sendNewOrderNotification', e as Exception);
    }
  }

  // Send order update notification
  Future<void> _sendOrderUpdateNotification(Order order) async {
    try {
      // Send notification to buyer
      print('Order update notification: ${order.status}');
    } catch (e) {
      ErrorHandler.logError('_sendOrderUpdateNotification', e as Exception);
    }
  }

  // Send low stock notification
  Future<void> _sendLowStockNotification(InventoryItem item) async {
    try {
      print('Low stock notification: ${item.name} - ${item.currentQuantity} ${item.unit} remaining');
    } catch (e) {
      ErrorHandler.logError('_sendLowStockNotification', e as Exception);
    }
  }

  // Get FCM token
  Future<String?> getFCMToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      ErrorHandler.logError('getFCMToken', e as Exception);
      return null;
    }
  }

  // ==================== UTILITY METHODS ====================

  // Check if user has internet connection
  Future<bool> hasInternetConnection() async {
    return await ErrorHandler.hasInternetConnection();
  }

  // Batch write operations
  Future<void> batchWrite(List<Map<String, dynamic>> operations) async {
    try {
      final WriteBatch batch = _firestore.batch();
      
      for (final operation in operations) {
        final String collection = operation['collection'];
        final String? docId = operation['docId'];
        final Map<String, dynamic> data = operation['data'];
        final String operationType = operation['type']; // 'create', 'update', 'delete'
        
        DocumentReference docRef;
        if (docId != null) {
          docRef = _firestore.collection(collection).doc(docId);
        } else {
          docRef = _firestore.collection(collection).doc();
        }
        
        switch (operationType) {
          case 'create':
            batch.set(docRef, data);
            break;
          case 'update':
            batch.update(docRef, data);
            break;
          case 'delete':
            batch.delete(docRef);
            break;
        }
      }
      
      await batch.commit();
    } catch (e) {
      ErrorHandler.logError('batchWrite', e as Exception);
      rethrow;
    }
  }

  // Get collection statistics
  Future<Map<String, int>> getCollectionStats() async {
    try {
      final Map<String, int> stats = {};
      
      // Count listings
      final listingsSnapshot = await _firestore
          .collection(AppConstants.listingsCollection)
          .where('isActive', isEqualTo: true)
          .get();
      stats['listings'] = listingsSnapshot.docs.length;
      
      // Count orders
      final ordersSnapshot = await _firestore
          .collection(AppConstants.ordersCollection)
          .get();
      stats['orders'] = ordersSnapshot.docs.length;
      
      // Count inventory items
      final inventorySnapshot = await _firestore
          .collection(AppConstants.inventoryCollection)
          .where('isActive', isEqualTo: true)
          .get();
      stats['inventory'] = inventorySnapshot.docs.length;
      
      return stats;
    } catch (e) {
      ErrorHandler.logError('getCollectionStats', e as Exception);
      rethrow;
    }
  }
}
