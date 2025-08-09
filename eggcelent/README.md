# Eggcelent - Poultry Farm E-commerce Mobile App

A comprehensive Flutter mobile application for poultry farm e-commerce, featuring marketplace integration, order tracking, inventory management, and analytics dashboard.

## Features

### 🛒 Marketplace Integration
- **Product Listings**: Farmers can post advertisements to sell eggs and chicken products
- **Product Categories**: Eggs, Chicken Meat (Leg, Thigh, Breast, Wings, Ribs), Live Chickens
- **Chicken Types**: Layer, Broiler, Deshi varieties
- **Advanced Search & Filters**: Search by category, chicken type, price range
- **Image Gallery**: Multiple product images with full-screen viewing
- **Contact Integration**: Phone, WhatsApp, Email contact methods

### 📦 Order Tracking
- **Real-time Status Updates**: Track orders from Processed → Shipped → Delivered
- **Delivery Estimates**: Expected delivery times and tracking codes
- **Order History**: Complete transaction history with status timeline
- **Push Notifications**: Real-time updates on order status changes

### 📊 Inventory Management
- **Stock Tracking**: Monitor feed, water, medicine, maintenance supplies
- **Low Stock Alerts**: Automatic notifications when items reach threshold
- **Transaction History**: Track stock in/out movements
- **Expiry Management**: Monitor product expiry dates
- **Supplier Information**: Maintain supplier contact details

### 📈 Analytics Dashboard
- **Sensor Data Visualization**: Temperature, humidity, gas level charts
- **Historical Trends**: Line and bar charts for different time periods
- **Alert System**: Visual indicators for out-of-range sensor readings
- **Data Export**: Export analytics data for reporting

## Technology Stack

- **Frontend**: Flutter 3.10+
- **Backend**: Firebase (Firestore, Storage, Messaging)
- **State Management**: Provider
- **Charts**: FL Chart
- **Image Handling**: Image Picker, Cached Network Image
- **Real-time Updates**: Firestore Streams
- **Push Notifications**: Firebase Cloud Messaging

## Project Structure

```
lib/
├── main.dart                 # App entry point with Firebase initialization
├── models/                   # Data models
│   ├── listing.dart         # Product listing model
│   ├── order.dart           # Order and order status models
│   ├── inventory_item.dart  # Inventory management model
│   └── sensor_data.dart     # Sensor data and analytics model
├── screens/                 # UI screens
│   ├── marketplace_list.dart    # Main marketplace screen
│   ├── listing_detail.dart      # Product detail view
│   ├── create_listing.dart      # Create/edit listings
│   ├── orders_tracking.dart     # Order tracking screen
│   ├── inventory_tracker.dart   # Inventory management
│   └── analytics.dart           # Analytics dashboard
├── widgets/                 # Reusable UI components
│   ├── listing_card.dart    # Product listing cards
│   ├── order_card.dart      # Order status cards
│   ├── inventory_card.dart  # Inventory item cards
│   └── chart_widget.dart    # Chart components
├── services/                # Business logic
│   └── firebase_service.dart    # Firebase operations
└── utils/                   # Utilities and constants
    ├── app_colors.dart      # Color palette
    ├── app_text_styles.dart # Typography
    ├── constants.dart       # App constants
    └── error_handling.dart  # Error management
```

## Setup Instructions

### Prerequisites
- Flutter SDK 3.10 or higher
- Dart SDK 3.0 or higher
- Firebase project with Firestore, Storage, and Messaging enabled
- Android Studio / VS Code with Flutter extensions

### Firebase Setup

1. **Create Firebase Project**
   ```bash
   # Go to https://console.firebase.google.com/
   # Create a new project named "eggcelent-poultry-farm"
   ```

2. **Enable Firebase Services**
   - Firestore Database (Native mode)
   - Firebase Storage
   - Firebase Cloud Messaging
   - Firebase Authentication (optional)

3. **Configure Android**
   - Add Android app with package name: `com.example.eggcelent`
   - Download `google-services.json`
   - Place in `android/app/` directory
   - Update `android/build.gradle` and `android/app/build.gradle`

4. **Configure iOS**
   - Add iOS app with bundle ID: `com.example.eggcelent`
   - Download `GoogleService-Info.plist`
   - Place in `ios/Runner/` directory
   - Update `ios/Runner/Info.plist`

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd eggcelent
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   ```bash
   # Replace the placeholder Firebase config files with your actual ones:
   # - android/app/google-services.json
   # - ios/Runner/GoogleService-Info.plist
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Firestore Database Structure

```
listings/
├── {listingId}
│   ├── title: string
│   ├── description: string
│   ├── chickenType: string (Layer|Broiler|Deshi)
│   ├── productCategory: string (Eggs|Chicken Meat|Live Chicken)
│   ├── meatType?: string (Leg|Thigh|Breast|Wings|Ribs)
│   ├── price: number
│   ├── quantity: number
│   ├── quantityUnit: string
│   ├── age?: number (for live chickens)
│   ├── sellerId: string
│   ├── sellerName: string
│   ├── sellerPhone: string
│   ├── contactMethod: string
│   ├── imageUrls: array
│   ├── location: string
│   ├── isActive: boolean
│   ├── createdAt: timestamp
│   └── updatedAt: timestamp

orders/
├── {orderId}
│   ├── listingId: string
│   ├── buyerId: string
│   ├── sellerId: string
│   ├── status: string (Processed|Shipped|Delivered|Cancelled)
│   ├── totalAmount: number
│   ├── trackingCode?: string
│   ├── estimatedDelivery?: timestamp
│   ├── statusHistory: array
│   ├── createdAt: timestamp
│   └── updatedAt: timestamp

inventory/
├── {itemId}
│   ├── name: string
│   ├── category: string (Feed|Water|Medicine|Maintenance Supplies|Eggs|Live Chickens)
│   ├── currentQuantity: number
│   ├── thresholdQuantity: number
│   ├── unit: string
│   ├── supplier?: string
│   ├── expiryDate?: timestamp
│   ├── transactions: array
│   ├── createdAt: timestamp
│   └── updatedAt: timestamp

sensor_data/
├── {dataId}
│   ├── sensorType: string (temperature|humidity|gas_level)
│   ├── value: number
│   ├── unit: string
│   ├── timestamp: timestamp
│   ├── location?: string
│   ├── isAlert: boolean
│   ├── minThreshold?: number
│   └── maxThreshold?: number
```

### Firebase Storage Structure

```
listing_images/
├── {timestamp}_{filename}
└── ...

profile_images/
├── {userId}_{timestamp}_{filename}
└── ...
```

## Key Features Implementation

### Real-time Updates
- Uses Firestore streams for live data synchronization
- Automatic UI updates when data changes
- Offline support with local caching

### Image Management
- Multiple image upload support
- Image compression and optimization
- Cached network images for performance
- Full-screen image gallery

### Search and Filtering
- Text-based search across listings
- Category and type filters
- Price range filtering
- Real-time filter application

### Notifications
- Firebase Cloud Messaging integration
- Push notifications for new orders
- Low stock alerts
- Order status updates

### Error Handling
- Comprehensive error management
- User-friendly error messages
- Retry mechanisms for failed operations
- Offline state handling

## Development Guidelines

### Code Style
- Follow Flutter/Dart style guidelines
- Use meaningful variable and function names
- Add comments for complex logic
- Maintain consistent file structure

### State Management
- Use Provider for state management
- Separate business logic from UI
- Implement proper error handling
- Use streams for real-time data

### Testing
```bash
# Run unit tests
flutter test

# Run integration tests
flutter drive --target=test_driver/app.dart
```

### Building for Production

**Android**
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

**iOS**
```bash
flutter build ios --release
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation

## Roadmap

### Phase 1 (Current)
- ✅ Basic marketplace functionality
- ✅ Order tracking system
- ✅ Inventory management
- ✅ Analytics dashboard

### Phase 2 (Planned)
- [ ] User authentication and profiles
- [ ] Payment gateway integration
- [ ] Advanced analytics and reporting
- [ ] Multi-language support
- [ ] Dark mode theme

### Phase 3 (Future)
- [ ] AI-powered recommendations
- [ ] IoT sensor integration
- [ ] Advanced inventory forecasting
- [ ] Multi-farm management
- [ ] API for third-party integrations

---

**Built with ❤️ for the poultry farming community**
