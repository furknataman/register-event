import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../animations/spring_animations.dart';
import '../../l10n/app_localizations.dart';

// Exact bottom bar composition inspired by the demo layout
// Left group: Home pill + Scan + Search; Spacer animates; Right icon.
class LiquidBottomNav extends StatelessWidget {
  final ValueChanged<int> onTap; // 0: home, 1: scan, 2: search, 3: profile
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
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
        child: AnimatedSize(
          duration: SpringAnimations.standard,
          curve: SpringAnimations.standardSpring,
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Left group (Home/Scan/Search selection) — demo-like
              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 6.0),
                    child: Row(
                      children: [
                        if (currentIndex == 0)
                          _GlassPill(
                            onTap: () => onTap(0),
                            iconAsset: 'assets/svg/home.svg',
                            label: AppLocalizations.of(context)!.navHome,
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
                            label: AppLocalizations.of(context)!.navScan,
                          )
                        else
                          _GlassIcon(
                            onTap: () => onTap(1),
                            iconAsset: 'assets/svg/scan.svg',
                            padding: const EdgeInsets.all(8),
                          ),
                        const SizedBox(width: 6),
                        if (currentIndex == 2)
                          _GlassPill(
                            onTap: () => onTap(2),
                            iconAsset: 'assets/svg/search.svg',
                            label: AppLocalizations.of(context)!.navSearch,
                          )
                        else
                          _GlassIcon(
                            onTap: () => onTap(2),
                            iconAsset: 'assets/svg/search.svg',
                            padding: const EdgeInsets.all(8),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Flexible(
                child: AnimatedSize(
                  alignment: Alignment.center,
                  duration: SpringAnimations.standard,
                  curve: SpringAnimations.standardSpring,
                  child: SizedBox(
                    width: tabSpacing.clamp(
                        0, MediaQuery.of(context).size.width - 300),
                    height: 0,
                  ),
                ),
              ),
              // Right group (Profile selection) — demo-like
              if (currentIndex == 3)
                _GlassPill(
                  onTap: () => onTap(3),
                  iconAsset: 'assets/svg/profile.svg',
                  label: AppLocalizations.of(context)!.navProfile,
                  largeIcon: true,
                )
              else
                _GlassIcon(
                  onTap: () => onTap(3),
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

class _GlassPill extends ConsumerStatefulWidget {
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
  ConsumerState<_GlassPill> createState() => _GlassPillState();
}

class _GlassPillState extends ConsumerState<_GlassPill> with SpringButtonMixin {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: onTapDown,
      onTapUp: (details) {
        onTapUp(details);
        widget.onTap();
      },
      onTapCancel: onTapCancel,
      child: buildPressAnimation(
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
                  _SvgIcon(widget.iconAsset, size: widget.largeIcon ? 32 : 28),
                  const SizedBox(width: 6),
                  Text(
                    widget.label,
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
      ),
    );
  }
}

class _GlassIcon extends ConsumerStatefulWidget {
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
  ConsumerState<_GlassIcon> createState() => _GlassIconState();
}

class _GlassIconState extends ConsumerState<_GlassIcon> with SpringButtonMixin {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: onTapDown,
      onTapUp: (details) {
        onTapUp(details);
        widget.onTap();
      },
      onTapCancel: onTapCancel,
      child: buildPressAnimation(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(40),
              ),
              padding: widget.padding,
              child: _SvgIcon(widget.iconAsset, size: widget.large ? 32 : 28),
            ),
          ),
        ),
      ),
    );
  }
}
