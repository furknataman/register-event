import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Exact bottom bar composition inspired by the demo layout
// Left group: Home pill + middle icon; Spacer animates; Right icon.
class LiquidBottomNav extends StatelessWidget {
  final ValueChanged<int> onTap; // 0: home, 1: scan, 2: profile
  final double tabSpacing; // expands on scroll (e.g., 0..150)
  final int currentIndex;

  const LiquidBottomNav({
    super.key,
    required this.onTap,
    required this.tabSpacing,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Left group (Home/Scan selection) — demo-like
              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                    child: Row(
                      children: [
                        if (currentIndex == 0)
                          _GlassPill(
                            onTap: () => onTap(0),
                            iconAsset: 'assets/svg/home.svg',
                            label: 'Home',
                          )
                        else
                          _GlassIcon(
                            onTap: () => onTap(0),
                            iconAsset: 'assets/svg/home.svg',
                            padding: const EdgeInsets.all(8),
                          ),
                        const SizedBox(width: 6),
                        if (currentIndex == 1)
                          _GlassPill(
                            onTap: () => onTap(1),
                            iconAsset: 'assets/svg/scan.svg',
                            label: 'Scan',
                          )
                        else
                          _GlassIcon(
                            onTap: () => onTap(1),
                            iconAsset: 'assets/svg/scan.svg',
                            padding: const EdgeInsets.all(8),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              AnimatedSize(
                alignment: Alignment.center,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                child: SizedBox(width: tabSpacing, height: 0),
              ),
              // Right group (Profile selection) — demo-like
              if (currentIndex == 2)
                _GlassPill(
                  onTap: () => onTap(2),
                  iconAsset: 'assets/svg/profile.svg',
                  label: 'Profile',
                  largeIcon: true,
                )
              else
                _GlassIcon(
                  onTap: () => onTap(2),
                  iconAsset: 'assets/svg/profile.svg',
                  padding: const EdgeInsets.all(12),
                  large: true,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SvgIcon extends StatelessWidget {
  final String asset;
  final double size;
  const _SvgIcon(this.asset, {this.size = 26});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      width: size,
      height: size,
      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
    );
  }
}

class _GlassPill extends StatelessWidget {
  final VoidCallback onTap;
  final String iconAsset;
  final String label;
  final bool largeIcon;

  const _GlassPill({
    required this.onTap,
    required this.iconAsset,
    required this.label,
    this.largeIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(40),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                _SvgIcon(iconAsset, size: largeIcon ? 32 : 28),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassIcon extends StatelessWidget {
  final VoidCallback onTap;
  final String iconAsset;
  final EdgeInsets padding;
  final bool large;

  const _GlassIcon({
    required this.onTap,
    required this.iconAsset,
    required this.padding,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(40),
            ),
            padding: padding,
            child: _SvgIcon(iconAsset, size: large ? 32 : 28),
          ),
        ),
      ),
    );
  }
}
