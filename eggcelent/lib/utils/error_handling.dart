import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app_colors.dart';
import 'constants.dart';

class ErrorHandler {
  // Show error snackbar
  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  // Show success snackbar
  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Show warning snackbar
  static void showWarningSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.warning,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Show error dialog
  static void showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(
              color: AppColors.error,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(message),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'OK',
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ],
        );
      },
    );
  }

  // Handle Firebase exceptions
  static String handleFirebaseException(Exception exception) {
    if (exception is FirebaseException) {
      switch (exception.code) {
        case 'permission-denied':
          return 'You don\'t have permission to perform this action.';
        case 'unavailable':
          return 'Service is currently unavailable. Please try again later.';
        case 'deadline-exceeded':
          return 'Request timed out. Please check your internet connection.';
        case 'not-found':
          return 'The requested data was not found.';
        case 'already-exists':
          return 'This item already exists.';
        case 'resource-exhausted':
          return 'Too many requests. Please try again later.';
        case 'failed-precondition':
          return 'Operation failed due to invalid conditions.';
        case 'aborted':
          return 'Operation was aborted. Please try again.';
        case 'out-of-range':
          return 'Invalid input range.';
        case 'unimplemented':
          return 'This feature is not yet implemented.';
        case 'internal':
          return 'Internal server error. Please try again later.';
        case 'data-loss':
          return 'Data loss occurred. Please contact support.';
        case 'unauthenticated':
          return 'Authentication required. Please log in.';
        default:
          return exception.message ?? AppConstants.genericErrorMessage;
      }
    }
    return AppConstants.genericErrorMessage;
  }

  // Handle general exceptions
  static String handleGeneralException(Exception exception) {
    final String message = exception.toString();
    
    if (message.contains('SocketException') || message.contains('NetworkException')) {
      return AppConstants.networkErrorMessage;
    } else if (message.contains('TimeoutException')) {
      return 'Request timed out. Please try again.';
    } else if (message.contains('FormatException')) {
      return 'Invalid data format received.';
    } else if (message.contains('PlatformException')) {
      return 'Platform error occurred. Please try again.';
    }
    
    return AppConstants.genericErrorMessage;
  }

  // Log error for debugging
  static void logError(String operation, Exception exception, [StackTrace? stackTrace]) {
    print('ERROR in $operation: $exception');
    if (stackTrace != null) {
      print('Stack trace: $stackTrace');
    }
  }

  // Validate form fields
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    
    final phoneRegex = RegExp(r'^[+]?[0-9]{10,15}$');
    if (!phoneRegex.hasMatch(value.trim().replaceAll(' ', ''))) {
      return 'Please enter a valid phone number';
    }
    
    return null;
  }

  static String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Price is required';
    }
    
    final price = double.tryParse(value.trim());
    if (price == null) {
      return 'Please enter a valid price';
    }
    
    if (price < AppConstants.minPriceValue || price > AppConstants.maxPriceValue) {
      return 'Price must be between ${AppConstants.minPriceValue} and ${AppConstants.maxPriceValue}';
    }
    
    return null;
  }

  static String? validateQuantity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Quantity is required';
    }
    
    final quantity = int.tryParse(value.trim());
    if (quantity == null) {
      return 'Please enter a valid quantity';
    }
    
    if (quantity < AppConstants.minQuantityValue || quantity > AppConstants.maxQuantityValue) {
      return 'Quantity must be between ${AppConstants.minQuantityValue} and ${AppConstants.maxQuantityValue}';
    }
    
    return null;
  }

  static String? validateAge(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Age is required';
    }
    
    final age = int.tryParse(value.trim());
    if (age == null) {
      return 'Please enter a valid age';
    }
    
    if (age < AppConstants.minAgeValue || age > AppConstants.maxAgeValue) {
      return 'Age must be between ${AppConstants.minAgeValue} and ${AppConstants.maxAgeValue} days';
    }
    
    return null;
  }

  // Check internet connectivity
  static Future<bool> hasInternetConnection() async {
    try {
      // This is a simple check - in a real app, you might want to use
      // connectivity_plus package for more robust connectivity checking
      return true; // Placeholder - implement actual connectivity check
    } catch (e) {
      return false;
    }
  }

  // Retry mechanism for failed operations
  static Future<T> retryOperation<T>(
    Future<T> Function() operation, {
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 1),
  }) async {
    int attempts = 0;
    
    while (attempts < maxRetries) {
      try {
        return await operation();
      } catch (e) {
        attempts++;
        if (attempts >= maxRetries) {
          rethrow;
        }
        await Future.delayed(delay);
      }
    }
    
    throw Exception('Max retries exceeded');
  }
}
