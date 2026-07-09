import 'dart:math';

import 'package:flutter/material.dart';

import './app_colors.dart';
import './app_spacing.dart';

/// ======================================================
/// Theme Extensions
/// ======================================================

extension ContextThemeX on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Color get bgColor =>
      isDark ? AppColors.darkBackground : AppColors.lightBackground;

  Color get surfaceColor =>
      isDark ? AppColors.darkSurface : AppColors.lightSurface;

  Color get textPrimary =>
      isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

  Color get textSecondary =>
      isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

  Color get borderColor =>
      isDark ? AppColors.darkBorder : AppColors.lightBorder;
}

/// ======================================================
/// Spacing
/// ======================================================

const Widget verticalSpaceTiny = SizedBox(height: AppSpacing.xxs);
const Widget verticalSpaceSmall = SizedBox(height: AppSpacing.xs);
const Widget verticalSpaceMedium = SizedBox(height: AppSpacing.md);
const Widget verticalSpaceLarge = SizedBox(height: AppSpacing.lg);
const Widget verticalSpaceMassive = SizedBox(height: 120);

const Widget horizontalSpaceTiny = SizedBox(width: AppSpacing.xxs);
const Widget horizontalSpaceSmall = SizedBox(width: AppSpacing.xs);
const Widget horizontalSpaceMedium = SizedBox(width: AppSpacing.md);
const Widget horizontalSpaceLarge = SizedBox(width: AppSpacing.lg);

Widget verticalSpace(double height) => SizedBox(height: height);

Widget spacedDivider = const Column(
  children: [
    verticalSpaceMedium,
    Divider(
      color: Colors.blueGrey,
      height: 5,
    ),
    verticalSpaceMedium,
  ],
);

/// ======================================================
/// Screen Helpers
/// ======================================================

double screenWidth(BuildContext context) =>
    MediaQuery.of(context).size.width;

double screenHeight(BuildContext context) =>
    MediaQuery.of(context).size.height;

double screenHeightFraction(
  BuildContext context, {
  int dividedBy = 1,
  double offsetBy = 0,
  double max = 3000,
}) {
  return min(
    (screenHeight(context) - offsetBy) / dividedBy,
    max,
  );
}

double screenWidthFraction(
  BuildContext context, {
  int dividedBy = 1,
  double offsetBy = 0,
  double max = 3000,
}) {
  return min(
    (screenWidth(context) - offsetBy) / dividedBy,
    max,
  );
}

double halfScreenWidth(BuildContext context) =>
    screenWidthFraction(context, dividedBy: 2);

double thirdScreenWidth(BuildContext context) =>
    screenWidthFraction(context, dividedBy: 3);

double quarterScreenWidth(BuildContext context) =>
    screenWidthFraction(context, dividedBy: 4);

double getResponsiveHorizontalSpaceMedium(BuildContext context) =>
    screenWidthFraction(context, dividedBy: 10);

/// ======================================================
/// Responsive Font Sizes
/// ======================================================

double getResponsiveSmallFontSize(BuildContext context) =>
    getResponsiveFontSize(
      context,
      fontSize: 14,
      max: 15,
    );

double getResponsiveMediumFontSize(BuildContext context) =>
    getResponsiveFontSize(
      context,
      fontSize: 16,
      max: 17,
    );

double getResponsiveLargeFontSize(BuildContext context) =>
    getResponsiveFontSize(
      context,
      fontSize: 21,
      max: 31,
    );

double getResponsiveExtraLargeFontSize(BuildContext context) =>
    getResponsiveFontSize(
      context,
      fontSize: 25,
    );

double getResponsiveMassiveFontSize(BuildContext context) =>
    getResponsiveFontSize(
      context,
      fontSize: 30,
    );

double getResponsiveFontSize(
  BuildContext context, {
  double? fontSize,
  double? max,
}) {
  max ??= 100;

  return min(
    screenWidthFraction(context, dividedBy: 10) *
        ((fontSize ?? 100) / 100),
    max,
  );
}

/// ======================================================
/// Date Helpers
/// ======================================================

String timeAgo(DateTime date) {
  final diff = DateTime.now().difference(date);

  if (diff.inSeconds < 60) {
    return 'just now';
  }

  if (diff.inMinutes < 60) {
    return '${diff.inMinutes}m ago';
  }

  if (diff.inHours < 24) {
    return '${diff.inHours}h ago';
  }

  if (diff.inDays < 7) {
    return '${diff.inDays}d ago';
  }

  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  return '${months[date.month - 1]} ${date.day}';
}

/// ======================================================
/// Greeting
/// ======================================================

String greetingForNow() {
  final hour = DateTime.now().hour;

  if (hour < 12) {
    return 'Good morning';
  }

  if (hour < 17) {
    return 'Good afternoon';
  }

  return 'Good evening';
}