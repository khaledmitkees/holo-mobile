import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final double? width;
  final double height;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double borderRadius;
  final double fontSize;
  final FontWeight fontWeight;
  final double borderWidth;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.height = 48,
    this.padding,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.borderRadius = 24,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
    this.borderWidth = 1.5,
  });

  @override
  Widget build(BuildContext context) {
    final bool isButtonEnabled = isEnabled && !isLoading && onPressed != null;
    
    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: isButtonEnabled ? onPressed : null,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.transparent,
          disabledBackgroundColor: Colors.grey[100],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          side: BorderSide(
            color: isButtonEnabled 
                ? (borderColor ?? Colors.black)
                : Colors.grey[400]!,
            width: borderWidth,
          ),
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 24),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    textColor ?? Colors.black,
                  ),
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  color: isButtonEnabled 
                      ? (textColor ?? Colors.black)
                      : Colors.grey[600],
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                ),
              ),
      ),
    );
  }
}
