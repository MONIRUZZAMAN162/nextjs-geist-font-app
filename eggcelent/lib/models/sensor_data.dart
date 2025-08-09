import 'package:cloud_firestore/cloud_firestore.dart';

class SensorData {
  final String id;
  final String sensorType; // temperature, humidity, gas_level
  final double value;
  final String unit; // °C, %, ppm, etc.
  final DateTime timestamp;
  final String? location; // Farm location or coop identifier
  final String? deviceId; // Sensor device identifier
  final bool isAlert; // Whether this reading triggered an alert
  final double? minThreshold; // Minimum acceptable value
  final double? maxThreshold; // Maximum acceptable value
  final Map<String, dynamic>? additionalInfo;

  SensorData({
    required this.id,
    required this.sensorType,
    required this.value,
    required this.unit,
    required this.timestamp,
    this.location,
    this.deviceId,
    this.isAlert = false,
    this.minThreshold,
    this.maxThreshold,
    this.additionalInfo,
  });

  // Factory constructor to create SensorData from Firestore document
  factory SensorData.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return SensorData(
      id: doc.id,
      sensorType: data['sensorType'] ?? '',
      value: (data['value'] ?? 0).toDouble(),
      unit: data['unit'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      location: data['location'],
      deviceId: data['deviceId'],
      isAlert: data['isAlert'] ?? false,
      minThreshold: data['minThreshold']?.toDouble(),
      maxThreshold: data['maxThreshold']?.toDouble(),
      additionalInfo: data['additionalInfo'],
    );
  }

  // Factory constructor to create SensorData from JSON
  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      id: json['id'] ?? '',
      sensorType: json['sensorType'] ?? '',
      value: (json['value'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      location: json['location'],
      deviceId: json['deviceId'],
      isAlert: json['isAlert'] ?? false,
      minThreshold: json['minThreshold']?.toDouble(),
      maxThreshold: json['maxThreshold']?.toDouble(),
      additionalInfo: json['additionalInfo'],
    );
  }

  // Convert SensorData to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'sensorType': sensorType,
      'value': value,
      'unit': unit,
      'timestamp': Timestamp.fromDate(timestamp),
      'location': location,
      'deviceId': deviceId,
      'isAlert': isAlert,
      'minThreshold': minThreshold,
      'maxThreshold': maxThreshold,
      'additionalInfo': additionalInfo,
    };
  }

  // Convert SensorData to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sensorType': sensorType,
      'value': value,
      'unit': unit,
      'timestamp': timestamp.toIso8601String(),
      'location': location,
      'deviceId': deviceId,
      'isAlert': isAlert,
      'minThreshold': minThreshold,
      'maxThreshold': maxThreshold,
      'additionalInfo': additionalInfo,
    };
  }

  // Create a copy of the sensor data with updated fields
  SensorData copyWith({
    String? id,
    String? sensorType,
    double? value,
    String? unit,
    DateTime? timestamp,
    String? location,
    String? deviceId,
    bool? isAlert,
    double? minThreshold,
    double? maxThreshold,
    Map<String, dynamic>? additionalInfo,
  }) {
    return SensorData(
      id: id ?? this.id,
      sensorType: sensorType ?? this.sensorType,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      timestamp: timestamp ?? this.timestamp,
      location: location ?? this.location,
      deviceId: deviceId ?? this.deviceId,
      isAlert: isAlert ?? this.isAlert,
      minThreshold: minThreshold ?? this.minThreshold,
      maxThreshold: maxThreshold ?? this.maxThreshold,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }

  // Get formatted value with unit
  String get formattedValue => '${value.toStringAsFixed(1)} $unit';

  // Get sensor type display name
  String get sensorTypeDisplay {
    switch (sensorType) {
      case 'temperature':
        return 'Temperature';
      case 'humidity':
        return 'Humidity';
      case 'gas_level':
        return 'Gas Level';
      default:
        return sensorType.replaceAll('_', ' ').toUpperCase();
    }
  }

  // Check if value is within acceptable range
  bool get isWithinRange {
    if (minThreshold != null && value < minThreshold!) return false;
    if (maxThreshold != null && value > maxThreshold!) return false;
    return true;
  }

  // Get status based on thresholds
  SensorStatus get status {
    if (!isWithinRange) return SensorStatus.alert;
    
    // Check if close to thresholds (warning zone)
    if (minThreshold != null && maxThreshold != null) {
      final range = maxThreshold! - minThreshold!;
      final warningMargin = range * 0.1; // 10% margin
      
      if (value <= minThreshold! + warningMargin || 
          value >= maxThreshold! - warningMargin) {
        return SensorStatus.warning;
      }
    }
    
    return SensorStatus.normal;
  }

  // Get status color based on sensor status
  String get statusColor {
    switch (status) {
      case SensorStatus.normal:
        return '#4CAF50'; // Green
      case SensorStatus.warning:
        return '#FF9800'; // Orange
      case SensorStatus.alert:
        return '#F44336'; // Red
    }
  }

  // Get time ago display
  String get timeAgoDisplay {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  // Get detailed timestamp display
  String get detailedTimestamp {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year} '
           '${timestamp.hour.toString().padLeft(2, '0')}:'
           '${timestamp.minute.toString().padLeft(2, '0')}';
  }

  // Check if data is recent (within last hour)
  bool get isRecent {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    return difference.inHours < 1;
  }

  // Check if data is stale (older than 24 hours)
  bool get isStale {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    return difference.inHours > 24;
  }

  @override
  String toString() {
    return 'SensorData(id: $id, sensorType: $sensorType, value: $value, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SensorData && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

enum SensorStatus {
  normal,
  warning,
  alert,
}

// Helper class for aggregated sensor data
class SensorDataSummary {
  final String sensorType;
  final double averageValue;
  final double minValue;
  final double maxValue;
  final int dataPointsCount;
  final DateTime periodStart;
  final DateTime periodEnd;
  final List<SensorData> alertReadings;

  SensorDataSummary({
    required this.sensorType,
    required this.averageValue,
    required this.minValue,
    required this.maxValue,
    required this.dataPointsCount,
    required this.periodStart,
    required this.periodEnd,
    required this.alertReadings,
  });

  // Create summary from list of sensor data
  factory SensorDataSummary.fromDataList(List<SensorData> dataList, String sensorType) {
    if (dataList.isEmpty) {
      return SensorDataSummary(
        sensorType: sensorType,
        averageValue: 0,
        minValue: 0,
        maxValue: 0,
        dataPointsCount: 0,
        periodStart: DateTime.now(),
        periodEnd: DateTime.now(),
        alertReadings: [],
      );
    }

    final values = dataList.map((data) => data.value).toList();
    final alertReadings = dataList.where((data) => data.isAlert).toList();
    
    // Sort by timestamp to get period range
    dataList.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return SensorDataSummary(
      sensorType: sensorType,
      averageValue: values.reduce((a, b) => a + b) / values.length,
      minValue: values.reduce((a, b) => a < b ? a : b),
      maxValue: values.reduce((a, b) => a > b ? a : b),
      dataPointsCount: dataList.length,
      periodStart: dataList.first.timestamp,
      periodEnd: dataList.last.timestamp,
      alertReadings: alertReadings,
    );
  }

  // Get formatted average value
  String get formattedAverageValue {
    if (dataPointsCount == 0) return 'N/A';
    return averageValue.toStringAsFixed(1);
  }

  // Get formatted min value
  String get formattedMinValue {
    if (dataPointsCount == 0) return 'N/A';
    return minValue.toStringAsFixed(1);
  }

  // Get formatted max value
  String get formattedMaxValue {
    if (dataPointsCount == 0) return 'N/A';
    return maxValue.toStringAsFixed(1);
  }

  // Get alert count
  int get alertCount => alertReadings.length;

  // Check if there were any alerts in this period
  bool get hasAlerts => alertReadings.isNotEmpty;

  @override
  String toString() {
    return 'SensorDataSummary(sensorType: $sensorType, avg: $averageValue, alerts: $alertCount)';
  }
}
