import 'package:flutter/material.dart';
import '../theme/theme.dart';
import 'app_card.dart';

/// Loading skeleton placeholder.
///
/// Use while data is loading to prevent layout shifts.
/// Per design spec: "Use skeletons for dashboards, tables, student profiles."
class AppSkeleton extends StatelessWidget {
  const AppSkeleton({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius,
    this.lines = 1,
    this.lineSpacing = AppSpacing.sm,
  });

  final double? width;
  final double height;
  final BorderRadius? borderRadius;
  final int lines;
  final double lineSpacing;

  @override
  Widget build(BuildContext context) {
    if (lines == 1) {
      return _SkeletonBox(
        width: width,
        height: height,
        borderRadius: borderRadius ?? AppSpacing.radiusSM,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        lines * 2 - 1,
        (index) {
          if (index.isOdd) {
            return SizedBox(height: lineSpacing);
          }
          final lineIndex = index ~/ 2;
          final isLastLine = lineIndex == lines - 1;
          return _SkeletonBox(
            width: isLastLine ? (width ?? 120) : width,
            height: height,
            borderRadius: borderRadius ?? AppSpacing.radiusSM,
          );
        },
      ),
    );
  }
}

class _SkeletonBox extends StatefulWidget {
  const _SkeletonBox({
    this.width,
    required this.height,
    required this.borderRadius,
  });

  final double? width;
  final double height;
  final BorderRadius borderRadius;

  @override
  State<_SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<_SkeletonBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant.withValues(alpha: _animation.value),
            borderRadius: widget.borderRadius,
          ),
        );
      },
    );
  }
}

/// Skeleton for a list of cards.
class AppCardSkeleton extends StatelessWidget {
  const AppCardSkeleton({super.key, this.count = 3});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        count,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const AppSkeleton(width: 40, height: 40),
                    AppSpacing.gapHorizontalMD,
                    const Expanded(
                      child: AppSkeleton(height: 16, lines: 2),
                    ),
                  ],
                ),
                AppSpacing.gapMD,
                const AppSkeleton(height: 12, lines: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
