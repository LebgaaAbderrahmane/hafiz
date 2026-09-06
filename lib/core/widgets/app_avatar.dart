import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/theme.dart';

/// User avatar with fallback to initials.
///
/// Supports network images and generates initials from name.
enum AppAvatarSize { small, medium, large, xlarge }

class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.imageUrl,
    required this.name,
    this.size = AppAvatarSize.medium,
    this.backgroundColor,
    this.textColor,
  });

  final String? imageUrl;
  final String name;
  final AppAvatarSize size;
  final Color? backgroundColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final diameter = switch (size) {
      AppAvatarSize.small => 32.0,
      AppAvatarSize.medium => 40.0,
      AppAvatarSize.large => 56.0,
      AppAvatarSize.xlarge => 80.0,
    };

    final fontSize = switch (size) {
      AppAvatarSize.small => 12.0,
      AppAvatarSize.medium => 14.0,
      AppAvatarSize.large => 20.0,
      AppAvatarSize.xlarge => 28.0,
    };

    final initials = _getInitials(name);
    final bgColor = backgroundColor ?? _getColorFromName(name);
    final fgColor = textColor ?? Colors.white;

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl!,
          width: diameter,
          height: diameter,
          fit: BoxFit.cover,
          placeholder: (context, url) => _buildFallback(
            diameter,
            fontSize,
            bgColor,
            fgColor,
            initials,
          ),
          errorWidget: (context, url, error) => _buildFallback(
            diameter,
            fontSize,
            bgColor,
            fgColor,
            initials,
          ),
        ),
      );
    }

    return _buildFallback(diameter, fontSize, bgColor, fgColor, initials);
  }

  Widget _buildFallback(
    double diameter,
    double fontSize,
    Color bgColor,
    Color fgColor,
    String initials,
  ) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: fgColor,
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  Color _getColorFromName(String name) {
    final colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.warning,
      AppColors.info,
      const Color(0xFF9C27B0),
      const Color(0xFFE91E63),
      const Color(0xFFFF5722),
      const Color(0xFF009688),
    ];
    final index = name.hashCode.abs() % colors.length;
    return colors[index];
  }
}
