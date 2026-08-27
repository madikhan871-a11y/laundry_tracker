import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({
    super.key,
    required this.status,
  });

  Color get backgroundColor {
    switch (status) {
      case 'Pending':
        return AppColors.pending.withValues(alpha: 0.12);
      case 'Washing':
        return AppColors.washing.withValues(alpha: 0.12);
      case 'Ready':
        return AppColors.ready.withValues(alpha: 0.12);
      case 'Delivered':
        return AppColors.delivered.withValues(alpha: 0.12);
      default:
        return AppColors.primaryLight;
    }
  }

  Color get textColor {
    switch (status) {
      case 'Pending':
        return AppColors.pending;
      case 'Washing':
        return AppColors.washing;
      case 'Ready':
        return AppColors.ready;
      case 'Delivered':
        return AppColors.delivered;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}