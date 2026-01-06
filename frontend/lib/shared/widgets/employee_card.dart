import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Employee card widget for list displays.
class EmployeeCard extends StatelessWidget {
  final String name;
  final String email;
  final String? designation;
  final String? department;
  final String status;
  final VoidCallback? onTap;
  final Widget? trailing;

  const EmployeeCard({
    super.key,
    required this.name,
    required this.email,
    this.designation,
    this.department,
    this.status = 'active',
    this.onTap,
    this.trailing,
  });

  Color get _statusColor {
    switch (status.toLowerCase()) {
      case 'active':
        return AppColors.success;
      case 'resigned':
        return AppColors.error;
      case 'suspended':
        return AppColors.warning;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            status.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: _statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    if (designation != null || department != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        [
                          designation,
                          department,
                        ].where((e) => e != null).join(' • '),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
