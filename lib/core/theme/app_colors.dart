import 'package:flutter/material.dart';

class AppColors {
  // --- Strict Brand Palette (2026 Standards) ---

  // Brand Colors
  static const Color primary = Color(0xFFB7E61A); // Lime Green
  static const Color primaryLight = Color(0xFFC7EF34); // Muted Light Lime Green
  static const Color primaryDark = Color(0xFF9DC410); // Rich Dark Lime Green
  
  static const Color secondary = Color(0xFF171B23); // Charcoal Black
  static const Color accent = Color(0xFFB7E61A); // Lime Green

  // Neutrals (Light Theme Soft White Foundations)
  static const Color background = Color(0xFFF8F9FB); // Soft White
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F2F4); // Light neutral gray
  static const Color border = Color(0xFFE2E4E8); // Light border
  static const Color divider = Color(0xFFF1F2F4);

  // Neutrals (Dark Theme Charcoal Foundations)
  static const Color zinc950 = Color(0xFF10141A); // Dark mode scaffold bg
  static const Color zinc900 = Color(0xFF171B23); // Dark mode surface
  static const Color zinc800 = Color(0xFF222731); // Dark mode card surface
  static const Color zinc700 = Color(0xFF2D333F); // Dark mode border / outline

  // Text Hierarchy
  static const Color textPrimary = Color(0xFF171B23); // Charcoal Black
  static const Color textSecondary = Color(0xFF4B5466); // Muted Charcoal
  static const Color textMuted = Color(0xFF8A94A6); // Slate Muted
  static const Color textOnPrimary = Color(0xFF171B23); // Charcoal black on Lime Green background
  static const Color textWhite = Color(0xFFF8F9FB); // Soft White

  // Minimalist Semantic Feedback (derived ONLY from the three brand colors)
  static const Color success = primary; // Lime Green for correct indicators
  static const Color error = secondary; // Charcoal Black for incorrect/error cues
  static const Color warning = textSecondary; // Dark Neutral secondary for warnings
  static const Color info = textMuted; // Muted Charcoal for information

  // Alias for semantic feedback
  static const Color correct = success;
  static const Color incorrect = error;
  static const Color chartSecondary = textMuted;

  // Shadows (Modern Layered with dynamic light/dark opacity)
  static List<BoxShadow> dynamicShadowSm(bool isDark) => [
    BoxShadow(
      color: (isDark ? Colors.black : secondary).withValues(alpha: 0.04),
      offset: const Offset(0, 1),
      blurRadius: 2,
    ),
  ];
  
  static List<BoxShadow> dynamicShadowMd(bool isDark) => [
    BoxShadow(
      color: (isDark ? Colors.black : secondary).withValues(alpha: 0.06),
      offset: const Offset(0, 4),
      blurRadius: 8,
      spreadRadius: -1,
    ),
    BoxShadow(
      color: (isDark ? Colors.black : secondary).withValues(alpha: 0.04),
      offset: const Offset(0, 2),
      blurRadius: 4,
      spreadRadius: -1,
    ),
  ];

  static List<BoxShadow> dynamicShadowLg(bool isDark) => [
    BoxShadow(
      color: (isDark ? Colors.black : secondary).withValues(alpha: 0.08),
      offset: const Offset(0, 12),
      blurRadius: 20,
      spreadRadius: -3,
    ),
    BoxShadow(
      color: (isDark ? Colors.black : secondary).withValues(alpha: 0.04),
      offset: const Offset(0, 4),
      blurRadius: 8,
      spreadRadius: -2,
    ),
  ];

  // Legacy variables kept for compatibility
  static List<BoxShadow> shadowSmLegacy = [
    BoxShadow(color: const Color(0x171B230A), offset: const Offset(0, 1), blurRadius: 2),
  ];
  static List<BoxShadow> shadowMdLegacy = [
    BoxShadow(color: const Color(0x171B2314), offset: const Offset(0, 4), blurRadius: 6),
  ];
  static List<BoxShadow> shadowLgLegacy = [
    BoxShadow(color: const Color(0x171B231A), offset: const Offset(0, 10), blurRadius: 15),
  ];

  // Static properties to keep compiler happy if referenced directly
  static List<BoxShadow> get shadowSm => shadowSmLegacy;
  static List<BoxShadow> get shadowMd => shadowMdLegacy;
  static List<BoxShadow> get shadowLg => shadowLgLegacy;

  static Color shadowLight = const Color(0xFF171B23).withValues(alpha: 0.03);
  static Color shadowMedium = const Color(0xFF171B23).withValues(alpha: 0.06);

  // Gradients
  static const Gradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient surfaceGradient = LinearGradient(
    colors: [surface, background],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
