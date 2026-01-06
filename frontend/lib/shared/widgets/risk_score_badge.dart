import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';

/// Risk score badge widget for AI anomaly detection display.
class RiskScoreBadge extends StatelessWidget {
  final double score;
  final bool showLabel;

  const RiskScoreBadge({super.key, required this.score, this.showLabel = true});

  Color get _backgroundColor {
    if (score < AppConstants.lowRiskThreshold) {
      return AppColors.riskLow;
    } else if (score < AppConstants.mediumRiskThreshold) {
      return AppColors.riskMedium;
    } else {
      return AppColors.riskHigh;
    }
  }

  String get _label {
    if (score < AppConstants.lowRiskThreshold) {
      return 'Low Risk';
    } else if (score < AppConstants.mediumRiskThreshold) {
      return 'Medium Risk';
    } else {
      return 'High Risk';
    }
  }

  IconData get _icon {
    if (score < AppConstants.lowRiskThreshold) {
      return Icons.check_circle;
    } else if (score < AppConstants.mediumRiskThreshold) {
      return Icons.warning;
    } else {
      return Icons.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _backgroundColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _backgroundColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 16, color: _backgroundColor),
          const SizedBox(width: 6),
          Text(
            showLabel ? _label : '${(score * 100).toInt()}%',
            style: TextStyle(
              color: _backgroundColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
