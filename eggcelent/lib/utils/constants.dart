class AppConstants {
  // Firestore Collection Names
  static const String listingsCollection = 'listings';
  static const String ordersCollection = 'orders';
  static const String inventoryCollection = 'inventory';
  static const String sensorDataCollection = 'sensor_data';
  static const String usersCollection = 'users';
  
  // Firebase Storage Paths
  static const String listingImagesPath = 'listing_images';
  static const String profileImagesPath = 'profile_images';
  
  // Chicken Types
  static const List<String> chickenTypes = [
    'Layer',
    'Broiler',
    'Deshi',
  ];
  
  // Product Categories
  static const List<String> productCategories = [
    'Eggs',
    'Chicken Meat',
    'Live Chicken',
  ];
  
  // Meat Types
  static const List<String> meatTypes = [
    'Leg',
    'Thigh',
    'Breast',
    'Wings',
    'Ribs',
    'Whole Chicken',
  ];
  
  // Order Status
  static const String orderStatusProcessed = 'Processed';
  static const String orderStatusShipped = 'Shipped';
  static const String orderStatusDelivered = 'Delivered';
  static const String orderStatusCancelled = 'Cancelled';
  
  static const List<String> orderStatuses = [
    orderStatusProcessed,
    orderStatusShipped,
    orderStatusDelivered,
    orderStatusCancelled,
  ];
  
  // Inventory Categories
  static const List<String> inventoryCategories = [
    'Feed',
    'Water',
    'Medicine',
    'Maintenance Supplies',
    'Eggs',
    'Live Chickens',
  ];
  
  // Sensor Types
  static const String sensorTemperature = 'temperature';
  static const String sensorHumidity = 'humidity';
  static const String sensorGasLevel = 'gas_level';
  
  static const List<String> sensorTypes = [
    sensorTemperature,
    sensorHumidity,
    sensorGasLevel,
  ];
  
  // Time Periods for Analytics
  static const List<String> timePeriods = [
    'Last 24 Hours',
    'Last 7 Days',
    'Last 30 Days',
    'Last 3 Months',
    'Last Year',
  ];
  
  // Error Messages
  static const String networkErrorMessage = 'Network error. Please check your internet connection.';
  static const String genericErrorMessage = 'Something went wrong. Please try again.';
  static const String noDataMessage = 'No data available.';
  static const String imageUploadErrorMessage = 'Failed to upload image. Please try again.';
  static const String formValidationErrorMessage = 'Please fill in all required fields.';
  static const String permissionDeniedMessage = 'Permission denied. Please grant necessary permissions.';
  
  // Success Messages
  static const String listingCreatedMessage = 'Listing created successfully!';
  static const String listingUpdatedMessage = 'Listing updated successfully!';
  static const String listingDeletedMessage = 'Listing deleted successfully!';
  static const String orderPlacedMessage = 'Order placed successfully!';
  static const String inventoryUpdatedMessage = 'Inventory updated successfully!';
  
  // Validation Rules
  static const int minPriceValue = 1;
  static const int maxPriceValue = 100000;
  static const int minQuantityValue = 1;
  static const int maxQuantityValue = 10000;
  static const int minAgeValue = 1;
  static const int maxAgeValue = 365; // days
  
  // Image Constraints
  static const int maxImageSizeBytes = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageExtensions = ['jpg', 'jpeg', 'png'];
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 50;
  
  // Notification Types
  static const String notificationNewOrder = 'new_order';
  static const String notificationOrderUpdate = 'order_update';
  static const String notificationLowStock = 'low_stock';
  static const String notificationNewListing = 'new_listing';
  
  // Default Values
  static const String defaultImageUrl = 'https://placehold.co/400x300?text=No+Image+Available';
  static const String defaultProfileImageUrl = 'https://placehold.co/100x100?text=User';
  
  // Contact Methods
  static const List<String> contactMethods = [
    'Phone',
    'WhatsApp',
    'Email',
  ];
  
  // Units
  static const List<String> quantityUnits = [
    'pieces',
    'kg',
    'dozen',
    'crates',
  ];
  
  // Chart Colors (hex values for easy reference)
  static const List<String> chartColorHex = [
    '#2E7D32',
    '#FF8F00',
    '#2196F3',
    '#9C27B0',
    '#E91E63',
    '#00BCD4',
  ];
  
  // App Information
  static const String appName = 'Eggcelent';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Poultry Farm E-commerce Platform';
  
  // API Timeouts (in seconds)
  static const int connectionTimeout = 30;
  static const int receiveTimeout = 30;
  
  // Cache Duration (in minutes)
  static const int imageCacheDuration = 60;
  static const int dataCacheDuration = 5;
}
