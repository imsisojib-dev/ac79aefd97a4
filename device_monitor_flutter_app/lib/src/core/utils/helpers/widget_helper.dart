import 'dart:io';
import 'dart:ui';

import 'package:device_monitor/src/config/resources/app_colors.dart';
import 'package:device_monitor/src/config/resources/app_images.dart';
import 'package:device_monitor/src/core/di/di_container.dart';
import 'package:device_monitor/src/core/enums/e_dialog_type.dart';
import 'package:device_monitor/src/core/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WidgetHelper {
  static void showDialogWithDynamicContent({
    required Widget content,
    Color? popupBackgroundColor,
    Color? popupBorderColor,
  }) {
    //final theme = Theme.of(sl<NavigationService>().navigatorKey.currentContext!);
    showDialog(
      barrierLabel: "ConfirmationDialog",
      //barrierColor: Colors.transparent,
      context: sl<NavigationService>().navigatorKey.currentContext!,
      builder: (context) {
        return _BlurryDialog(
          alertDialog: AlertDialog(
            surfaceTintColor: Colors.white,
            backgroundColor: popupBackgroundColor ?? Colors.white,
            shadowColor: AppColors.secondaryColorLight.withOpacity(.7),
            elevation: 7,
            //backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            //titlePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            //contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            //insetPadding: EdgeInsets.zero,
            buttonPadding: EdgeInsets.all(16.h),
            content: content,
          ),
        );
      },
    );
  }

  static void showAlertDialog({
    required String title,
    required String message,
    required EDialogType dialogType,
    Color? popupBackgroundColor,
    Color? popupBorderColor,
    Widget? positiveButton,
    Widget? cancelButton,
    bool barrierDismissible = true,
    bool showCloseIcon = true,
    Function? onCloseDialog,
  }) {
    final theme = Theme.of(sl<NavigationService>().navigatorKey.currentContext!);
    showDialog(
      barrierLabel: "AlertDialog",
      barrierDismissible: barrierDismissible,
      //barrierColor: Colors.transparent,
      context: sl<NavigationService>().navigatorKey.currentContext!,
      builder: (context) {
        return _BlurryDialog(
          alertDialog: AlertDialog(
            surfaceTintColor: Colors.white,
            backgroundColor: popupBackgroundColor ?? Colors.white,
            shadowColor: AppColors.secondaryColorLight.withOpacity(.7),
            elevation: 7,
            //backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            //titlePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            //contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            //insetPadding: EdgeInsets.zero,
            buttonPadding: EdgeInsets.all(16.h),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    showCloseIcon
                        ? InkWell(
                      // iconSize: 24.h,
                      // padding: EdgeInsets.zero,
                      onTap: () {
                        Navigator.pop(context);
                        onCloseDialog?.call();
                      },
                      child: const Icon(
                        Icons.clear,
                        color: AppColors.textSecondaryColorLight,
                      ),
                    )
                        : const SizedBox(),
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                ),
                SizedBox(
                  height: 8.h,
                ),
                Image.asset(
                  dialogType == EDialogType.warning
                      ? AppImages.iconDialogWarning
                      : dialogType == EDialogType.error
                      ? AppImages.iconDialogError
                      : AppImages.iconDialogSuccess,
                  height: 68.h,
                  width: 68.h,
                ),
                SizedBox(
                  height: 32.h,
                ),
                Text(
                  title,
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontSize: 22.sp,
                  ),
                ),
                SizedBox(
                  height: 24.h,
                ),
                Text(
                  message,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondaryColorLight,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 32.h,
                ),
                positiveButton ?? const SizedBox(),
                if (cancelButton != null)
                  SizedBox(
                    height: 10.h,
                  ),
                cancelButton ?? const SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }

  static IconData getHealthIcon(double score) {
    if (score >= 80) return Icons.sentiment_very_satisfied;
    if (score >= 60) return Icons.sentiment_satisfied;
    if (score >= 40) return Icons.sentiment_neutral;
    return Icons.sentiment_dissatisfied;
  }

  static Color getBatteryColor(int level) {
    if (level >= 80) return AppColors.successGreen;
    if (level >= 50) return AppColors.infoBlue;
    if (level >= 20) return AppColors.warningAmber;
    return AppColors.errorRed;
  }

  static Color getMemoryColor(int usage) {
    if (usage <= 50) return AppColors.successGreen;
    if (usage <= 70) return AppColors.infoBlue;
    if (usage <= 85) return AppColors.warningAmber;
    return AppColors.errorRed;
  }

  static Color getConditionColor(String condition) {
    switch (condition.toUpperCase()) {
      case 'EXCELLENT':
        return AppColors.successGreen;
      case 'GOOD':
        return AppColors.infoBlue;
      case 'NEEDS_ATTENTION':
        return AppColors.warningAmber;
      case 'CRITICAL':
        return AppColors.errorRed;
      default:
        return Colors.grey;
    }
  }

  static IconData getConditionIcon(String condition) {
    switch (condition.toUpperCase()) {
      case 'EXCELLENT':
        return Icons.verified;
      case 'GOOD':
        return Icons.check_circle;
      case 'NEEDS_ATTENTION':
        return Icons.warning_amber_rounded;
      case 'CRITICAL':
        return Icons.error;
      default:
        return Icons.help;
    }
  }

  static Color getSeverityColor(String severity) {
    switch (severity.toUpperCase()) {
      case 'LOW':
        return AppColors.successGreen;
      case 'MEDIUM':
        return AppColors.warningAmber;
      case 'HIGH':
        return AppColors.errorRed;
      default:
        return Colors.grey;
    }
  }

  static Color getBatteryDrainColor(int drain) {
    if (drain <= 15) return AppColors.successGreen;
    if (drain <= 25) return AppColors.infoBlue;
    if (drain <= 35) return AppColors.warningAmber;
    return AppColors.errorRed;
  }

  static IconData getPeriodIcon(String period) {
    if (period.contains('Morning')) return Icons.wb_sunny;
    if (period.contains('Afternoon')) return Icons.wb_twilight;
    if (period.contains('Evening')) return Icons.nights_stay;
    return Icons.access_time;
  }

  static Color getHealthScoreColor(int score) {
    if (score >= 80) return AppColors.successGreen;
    if (score >= 60) return AppColors.infoBlue;
    if (score >= 40) return AppColors.warningAmber;
    return AppColors.errorRed;
  }

  static Widget buildLegendItem(String label, int count, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '$label ($count)',
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

}

class _BlurryDialog extends StatelessWidget {
  final AlertDialog alertDialog;

  const _BlurryDialog({
    required this.alertDialog,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: Platform.isIOS ? ImageFilter.blur(sigmaX: 0, sigmaY: 0) : ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: alertDialog,
    );
  }
}