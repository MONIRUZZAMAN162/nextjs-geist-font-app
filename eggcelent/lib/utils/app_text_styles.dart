import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Heading Styles
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );
  
  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );
  
  static const TextStyle heading4 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  // Body Text Styles
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.4,
  );
  
  // Button Text Styles
  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  
  static const TextStyle buttonTextSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
  
  // Form Text Styles
  static const TextStyle labelText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle inputText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle hintText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textHint,
  );
  
  // Card Text Styles
  static const TextStyle cardTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle cardSubtitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );
  
  static const TextStyle cardPrice = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );
  
  // Status Text Styles
  static const TextStyle statusProcessed = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.orderProcessed,
  );
  
  static const TextStyle statusShipped = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.orderShipped,
  );
  
  static const TextStyle statusDelivered = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.orderDelivered,
  );
  
  // Error Text Style
  static const TextStyle errorText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.error,
  );
  
  // Success Text Style
  static const TextStyle successText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.success,
  );
  
  // App Bar Text Style
  static const TextStyle appBarTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  
  // Navigation Text Style
  static const TextStyle navigationLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
  
  // Chart Text Styles
  static const TextStyle chartTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle chartLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );
  
  // Complete Text Theme for MaterialApp
  static const TextTheme textTheme = TextTheme(
    displayLarge: heading1,
    displayMedium: heading2,
    displaySmall: heading3,
    headlineMedium: heading4,
    titleLarge: cardTitle,
    titleMedium: labelText,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: buttonText,
    labelSmall: hintText,
  );
}
