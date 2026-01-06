import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Custom button widget with loading state support.
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 50,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = isOutlined
        ? OutlinedButton.styleFrom(
            side: BorderSide(color: backgroundColor ?? AppColors.primary),
            minimumSize: Size(width ?? double.infinity, height),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? AppColors.primary,
            foregroundColor: textColor ?? Colors.white,
            minimumSize: Size(width ?? double.infinity, height),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          );

    final child = isLoading
        ? const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );

    if (isOutlined) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: buttonStyle,
        child: child,
      );
    }

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: buttonStyle,
      child: child,
    );
  }
}
