// Flutter imports:
import 'package:flutter/material.dart';

/// Loading Overlay Widget
/// Shows a loading indicator over content
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    required this.isLoading,
    required this.child,
    super.key,
    this.message,
  });
  final bool isLoading;
  final Widget child;
  final String? message;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          child,
          if (isLoading)
            ColoredBox(
              color: Colors.black.withValues(alpha: 0.3),
              child: Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        if (message != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            message!,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      );
}
