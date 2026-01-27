import 'package:device_monitor/src/config/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StrokeButton extends StatelessWidget {
  final double? width;
  final double? height;
  final double elevation;
  final double borderRadius;
  final Color? backgroundColor;
  final Color strokeColor;
  final double strokeWidth;
  final Function? onPressed;
  final Widget? suffix;
  final Widget? prefix;
  final String buttonText;
  final TextStyle? buttonTextStyle;
  final EdgeInsetsGeometry? padding;
  final MainAxisAlignment? mainAxisAlignment;

  const StrokeButton({
    super.key,
    this.width,
    this.height = 45,
    this.backgroundColor = AppColors.white,
    this.onPressed,
    this.suffix,
    this.prefix,
    required this.buttonText,
    this.buttonTextStyle,
    this.borderRadius = 8,
    this.strokeColor = AppColors.primaryColorLight,
    this.strokeWidth = 1,
    this.elevation = 1,
    this.padding,
    this.mainAxisAlignment = MainAxisAlignment.spaceEvenly,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: width,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: strokeColor, width: strokeWidth),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: MaterialButton(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: padding ?? EdgeInsets.zero,
          height: height!.h,
          elevation: elevation,
          color: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          onPressed: () {
            onPressed?.call();
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: mainAxisAlignment!,
            children: [
              prefix ?? const SizedBox(),
              Text(
                buttonText,
                style: buttonTextStyle ??
                    theme.textTheme.titleSmall?.copyWith(
                      color: AppColors.primaryColorLight,
                    ),
              ),
              suffix ?? const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
