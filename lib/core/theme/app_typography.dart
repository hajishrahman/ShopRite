import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTypography {
  static TextStyle headingLarge = GoogleFonts.poppins(
      fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary);

  static TextStyle headingMedium = GoogleFonts.poppins(
      fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textPrimary);

  static TextStyle headingSmall = GoogleFonts.poppins(
      fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary);

  static TextStyle bodyLarge = GoogleFonts.poppins(
      fontSize: 16, fontWeight: FontWeight.normal, color: AppColors.textPrimary);

  static TextStyle bodyMedium = GoogleFonts.poppins(
      fontSize: 14, fontWeight: FontWeight.normal, color: AppColors.textSecondary);

  static TextStyle bodySmall = GoogleFonts.poppins(
      fontSize: 12, fontWeight: FontWeight.normal, color: AppColors.textSecondary, height: 1.5, 
      letterSpacing: 0.5);

  static TextStyle buttonText = GoogleFonts.poppins(
      fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white);

  static TextStyle priceText = GoogleFonts.poppins(
      fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary);
}
