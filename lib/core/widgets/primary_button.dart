import 'package:flutter/material.dart';
import 'package:swipeorregret/app/app_theme.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isLoading;
  final bool isDisabled;
  final double? height;
  final double? width;
  final EdgeInsets? padding;
  final ButtonVariant variant;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.isLoading = false,
    this.isDisabled = false,
    this.height,
    this.width,
    this.padding,
    this.variant = ButtonVariant.primary,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final locale = Localizations.localeOf(context);

    // Determine if we're in dark mode
    final isDarkMode = theme.brightness == Brightness.dark;

    // Determine colors based on variant
    Color bgColor;
    Color txtColor;

    switch (variant) {
      case ButtonVariant.secondary:
        bgColor = backgroundColor ?? colorScheme.surfaceVariant;
        txtColor = textColor ?? colorScheme.onSurfaceVariant;
        break;
      case ButtonVariant.outlined:
        bgColor = Colors.transparent;
        txtColor = textColor ?? colorScheme.primary;
        break;
      case ButtonVariant.primary:
      default:
        bgColor = backgroundColor ?? colorScheme.primary;
        txtColor = textColor ?? colorScheme.onPrimary;
    }

    // Handle custom backgroundColor/textColor overrides
    if (backgroundColor != null) bgColor = backgroundColor!;
    if (textColor != null) txtColor = textColor!;

    // For disabled state
    final disabledBgColor = isDarkMode
        ? colorScheme.onSurface.withOpacity(0.12)
        : colorScheme.onSurface.withOpacity(0.12);
    final disabledTextColor = isDarkMode
        ? colorScheme.onSurface.withOpacity(0.38)
        : colorScheme.onSurface.withOpacity(0.38);

    // Get text style
    final buttonTextStyle = AppTheme.getTextStyle(
      locale: locale,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: isDisabled || isLoading ? disabledTextColor : txtColor,
    );

    // For outlined variant, use OutlinedButton instead
    if (variant == ButtonVariant.outlined) {
      return OutlinedButton(
        onPressed: (isLoading || isDisabled) ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: txtColor,
          disabledForegroundColor: disabledTextColor,
          minimumSize: Size(width ?? double.infinity, height ?? 56),
          maximumSize: width != null
              ? Size(width!, height ?? 56)
              : Size.infinite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(
            color: isDisabled || isLoading
                ? disabledTextColor
                : txtColor.withOpacity(0.5),
            width: 1,
          ),
          padding:
              padding ??
              const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: isDisabled ? disabledTextColor : txtColor,
                ),
              )
            : Text(text, style: buttonTextStyle, textAlign: TextAlign.center),
      );
    }

    return ElevatedButton(
      onPressed: (isLoading || isDisabled) ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isDisabled || isLoading ? disabledBgColor : bgColor,
        foregroundColor: txtColor,
        disabledForegroundColor: disabledTextColor,
        disabledBackgroundColor: disabledBgColor,
        minimumSize: Size(width ?? double.infinity, height ?? 56),
        maximumSize: width != null ? Size(width!, height ?? 56) : Size.infinite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: (variant == ButtonVariant.primary && isDarkMode) ? 2 : 0,
        shadowColor: (variant == ButtonVariant.primary && isDarkMode)
            ? Colors.black
            : null,
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: isDisabled ? disabledTextColor : txtColor,
              ),
            )
          : Text(text, style: buttonTextStyle, textAlign: TextAlign.center),
    );
  }
}

enum ButtonVariant { primary, secondary, outlined }
