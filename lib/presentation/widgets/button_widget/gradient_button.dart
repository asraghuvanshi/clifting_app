import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PrimaryGradientButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isLoading;
  final VoidCallback? onTap;
  final double height;
  final double borderRadius;
  final List<Color> gradientColors;
  final double letterSpacing;
  final FontWeight fontWeight;
  final double fontSize;

  const PrimaryGradientButton({
    super.key,
    required this.title,
    required this.icon,
    required this.isLoading,
    required this.onTap,
    this.height = 56,
    this.borderRadius = 28,
    this.gradientColors = const [],
    this.letterSpacing = 1.5,
    this.fontWeight = FontWeight.w900,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    final colors = gradientColors.isNotEmpty
        ? gradientColors
        : [Colors.blueAccent, Colors.deepPurpleAccent];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: isLoading
            ? null
            : () {
                HapticFeedback.mediumImpact();
                onTap?.call();
              },
        splashColor: Colors.white.withOpacity(0.2),
        highlightColor: Colors.white.withOpacity(0.1),
        child: Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: LinearGradient(
              colors: isLoading
                  ? [Colors.grey.shade700, Colors.grey.shade900]
                  : colors,
            ),
            boxShadow: isLoading
                ? null
                : [
                    BoxShadow(
                      color: colors.first.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, 8),
                    ),
                  ],
          ),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: fontSize,
                          fontWeight: fontWeight,
                          letterSpacing: letterSpacing,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        icon,
                        color: Colors.white,
                        size: 22,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
