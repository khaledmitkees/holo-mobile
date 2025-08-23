import 'package:flutter/material.dart';
import 'primary_button.dart';

/// A generic error widget that displays an error title, message, and retry button
class ErrorWidget extends StatelessWidget {
  /// The error title to display
  final String title;
  
  /// The error message to display
  final String message;
  
  /// Callback function when retry button is pressed
  final VoidCallback onRetry;
  
  /// Optional icon to display above the title
  final IconData? icon;
  
  /// Optional custom styling for the title
  final TextStyle? titleStyle;
  
  /// Optional custom styling for the message
  final TextStyle? messageStyle;
  
  /// Optional custom text for the retry button
  final String? retryButtonText;
  
  /// Optional background color for the error widget
  final Color? backgroundColor;

  const ErrorWidget({
    super.key,
    required this.title,
    required this.message,
    required this.onRetry,
    this.icon,
    this.titleStyle,
    this.messageStyle,
    this.retryButtonText,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: backgroundColor,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(
              icon!,
              size: 64,
              color: Colors.red.shade400,
            ),
            const SizedBox(height: 24),
          ],
          Text(
            title,
            style: titleStyle ??
                const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: messageStyle ??
                const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.5,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          PrimaryButton(
            text: retryButtonText ?? 'Retry',
            onPressed: onRetry,
          ),
        ],
      ),
    );
  }
}
