import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ModernVitalCard extends StatelessWidget {
  final bool isDark;
  final String title;
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  final int percentage;
  final double progressbarHeight;
  final double titleFontSize;
  final double borderRadius;
  final double labelFontSize;

  const ModernVitalCard({
    super.key,
    required this.title,
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
    required this.percentage,
    required this.isDark,
    this.progressbarHeight = 6,
    this.titleFontSize = 32,
    this.borderRadius = 20,
    this.labelFontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  color.withOpacity(0.15),
                  color.withOpacity(0.05),
                ]
              : [
                  Colors.white,
                  color.withOpacity(0.05),
                ],
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon and Title
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 16),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //
            //     // Container(
            //     //   padding: const EdgeInsets.symmetric(
            //     //     horizontal: 8,
            //     //     vertical: 4,
            //     //   ),
            //     //   decoration: BoxDecoration(
            //     //     color: color.withOpacity(0.15),
            //     //     borderRadius: BorderRadius.circular(8),
            //     //   ),
            //     //   child: Text(
            //     //     title,
            //     //     style: TextStyle(
            //     //       fontSize: 11,
            //     //       fontWeight: FontWeight.w600,
            //     //       color: color,
            //     //     ),
            //     //   ),
            //     // ),
            //   ],
            // ),
            const Spacer(),

            // Value
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: titleFontSize.sp,
                    fontWeight: FontWeight.bold,
                    color: color,
                    height: 1,
                  ),
                ),
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: labelFontSize.sp,
                      fontWeight: FontWeight.w600,
                      color: color.withOpacity(0.7),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Progress Bar
            Stack(
              children: [
                Container(
                  height: progressbarHeight,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: (percentage / 100).clamp(0.0, 1.0),
                  child: Container(
                    height: progressbarHeight,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color, color.withOpacity(0.6)],
                      ),
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.5),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
