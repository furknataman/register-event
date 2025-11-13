import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/localization_helper.dart';
import '../../../../core/utils/image_helper.dart';
import '../../../../core/data/models/presentation_model.dart';
import '../../../../core/data/models/presentation_status.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/services/api/service.dart';
import '../../../../core/theme/theme_mode.dart';
import '../../../../core/notifications/toast/toast_message.dart';
import '../../../../core/widgets/gradient_button.dart';

// Platform-specific glass effect wrapper
// Android'de LiquidGlass performans sorunu yaratıyor, basit Container kullan
Widget _buildGlassEffect({
  required Widget child,
  required bool isDark,
}) {
  if (Platform.isAndroid) {
    // Android: Basit container, daha performanslı
    return child;
  }

  // iOS: LiquidGlass efekti
  return LiquidGlass(
    settings: LiquidGlassSettings(
      blur: 0,
      ambientStrength: 0.7,
      lightAngle: 0.3 * math.pi,
      glassColor: Colors.transparent,
      chromaticAberration: 0.0,
    ),
    shape: LiquidRoundedSuperellipse(
      borderRadius: const Radius.circular(16),
    ),
    glassContainsChild: false,
    child: child,
  );
}

class EventDetailPage extends ConsumerStatefulWidget {
  final String eventId;

  const EventDetailPage({
    super.key,
    required this.eventId,
  });

  @override
  ConsumerState<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends ConsumerState<EventDetailPage> {
  @override
  Widget build(BuildContext context) {
    final eventAsync = ref.watch(eventDetailsProvider(int.parse(widget.eventId)));
    final sessionDataAsync = ref.watch(sessionPresentationDataProvider);

    // Dark mode kontrolü
    final themeModeAsync = ref.watch(themeModeProvider);
    final themeMode = themeModeAsync.value ?? ThemeMode.system;
    final isDark = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.primaryBlue,
      body: eventAsync.when(
        data: (presentation) {
          if (presentation == null) {
            return Center(
              child: Text(
                AppLocalizations.of(context)!.noEventsYet,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            );
          }

          return sessionDataAsync.when(
            data: (sessionData) {
              // Check if user is registered for this presentation
              final isRegistered = sessionData.kayitliSunum
                  .any((r) => r.sunumId == presentation.id);

              return Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: isDark
                          ? AppColors.backgroundGradientDark
                          : AppColors.backgroundGradient,
                    ),
                    child: CustomScrollView(
                      physics: const ClampingScrollPhysics(),
                      slivers: [
                        // Header image with SliverAppBar
                        SliverAppBar(
                          expandedHeight: 240,
                          pinned: true,
                          backgroundColor: isDark
                              ? const Color(0xFF1a1a2e)
                              : const Color(0xFF004B8D),
                          leading: IconButton(
                            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          flexibleSpace: FlexibleSpaceBar(
                            background: Stack(
                              fit: StackFit.expand,
                              children: [
                                // Background color
                                Container(
                                  color: isDark
                                      ? const Color(0xFF1a1a2e)
                                      : const Color(0xFF004B8D),
                                ),
                                // Image
                                RepaintBoundary(
                                  child: Image.asset(
                                    ImageHelper.getImageForBranch(presentation.branch),
                                    fit: BoxFit.cover,
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    height: double.infinity,
                                    cacheHeight: 480,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Colors.white.withValues(alpha: 0.12),
                                              Colors.white.withValues(alpha: 0.22),
                                            ],
                                          ),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.event,
                                            size: 80,
                                            color: Colors.white.withValues(alpha: 0.5),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                // Gradient overlay
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.black.withValues(alpha: 0.2),
                                        Colors.black.withValues(alpha: 0.5),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate([
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title
                                  Text(
                                    presentation.title ??
                                        AppLocalizations.of(context)!
                                            .noTitleInfo,
                                    style: TextStyle(
                                      color:
                                          AppTextStyles.getTextColor(context),
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      height: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  // Info cards - Grid layout
                                  RepaintBoundary(
                                    child: Wrap(
                                      spacing: 12,
                                      runSpacing: 12,
                                      children: [
                                        if (presentation.presentationPlace !=
                                            null)
                                          SizedBox(
                                            width: (MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    56) /
                                                2,
                                            child: _buildInfoCard(
                                              context,
                                              'assets/svg/location-dot.svg',
                                              AppLocalizations.of(context)!
                                                  .presentationPlace,
                                              presentation.presentationPlace!,
                                              isDark,
                                            ),
                                          ),
                                        if (presentation.time != null)
                                          SizedBox(
                                            width: (MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    56) /
                                                2,
                                            child: _buildInfoCard(
                                              context,
                                              'assets/svg/clock.svg',
                                              AppLocalizations.of(context)!
                                                  .presentationTime,
                                              presentation.time!,
                                              isDark,
                                            ),
                                          ),
                                        if (presentation.session != null)
                                          SizedBox(
                                            width: (MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    56) /
                                                2,
                                            child: _buildInfoCard(
                                              context,
                                              'assets/svg/calendar.svg',
                                              'Oturum',
                                              '${AppLocalizations.of(context)!.session} ${presentation.session}',
                                              isDark,
                                            ),
                                          ),
                                        if (presentation.quota != null &&
                                            presentation.registrationCount !=
                                                null)
                                          SizedBox(
                                            width: (MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    56) /
                                                2,
                                            child: _buildInfoCard(
                                              context,
                                              'assets/svg/users.svg',
                                              AppLocalizations.of(context)!
                                                  .quota,
                                              '${presentation.registrationCount}/${presentation.quota}',
                                              isDark,
                                            ),
                                          ),
                                        if (presentation.duration != null)
                                          SizedBox(
                                            width: (MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    56) /
                                                2,
                                            child: _buildInfoCard(
                                              context,
                                              'assets/svg/hourglass.svg',
                                              AppLocalizations.of(context)!
                                                  .duration,
                                              '${presentation.duration} ${AppLocalizations.of(context)!.minutes}',
                                              isDark,
                                            ),
                                          ),
                                        if (presentation.language != null)
                                          SizedBox(
                                            width: (MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    56) /
                                                2,
                                            child: _buildInfoCard(
                                              context,
                                              'assets/svg/globe.svg',
                                              AppLocalizations.of(context)!
                                                  .language,
                                              getLocalizedText(
                                                presentation.language,
                                                Localizations.localeOf(context)
                                                    .languageCode,
                                              ),
                                              isDark,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  // Presenters
                                  if (presentation.presenter1Name != null) ...[
                                    Text(
                                      AppLocalizations.of(context)!.speakers,
                                      style: TextStyle(
                                        color:
                                            AppTextStyles.getTextColor(context),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    _buildPresenterCard(
                                      context,
                                      presentation.presenter1Name!,
                                      presentation.presenter1Email,
                                      presentation.position,
                                      isDark,
                                    ),
                                    if (presentation.presenter2Name !=
                                        null) ...[
                                      const SizedBox(height: 12),
                                      _buildPresenterCard(
                                        context,
                                        presentation.presenter2Name!,
                                        presentation.presenter2Email,
                                        null, // position sadece ilk sunucu için var
                                        isDark,
                                      ),
                                    ],
                                    const SizedBox(height: 20),
                                  ],

                                  // Description
                                  if (presentation.description != null) ...[
                                    _buildGlassEffect(
                                      isDark: isDark,
                                      child: Container(
                                        padding: const EdgeInsets.all(18),
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? Colors.white
                                                  .withValues(alpha: 0.15)
                                              : Colors.white
                                                  .withValues(alpha: 0.25),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          border: Border.all(
                                            color: isDark
                                                ? Colors.white
                                                    .withValues(alpha: 0.3)
                                                : Colors.white
                                                    .withValues(alpha: 0.4),
                                          ),
                                        ),
                                        child: Text(
                                          presentation.description!,
                                          style: TextStyle(
                                            color: AppTextStyles.getTextColor(
                                                context,
                                                opacity: 0.95),
                                            height: 1.6,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Register button at bottom
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: RepaintBoundary(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: SafeArea(
                          top: false,
                          child: _buildRegisterButton(
                            context,
                            ref,
                            presentation,
                            isRegistered,
                            isDark,
                            widget.eventId,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
            loading: () => Container(
              decoration: BoxDecoration(
                gradient: isDark
                    ? AppColors.backgroundGradientDark
                    : AppColors.backgroundGradient,
              ),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
            error: (error, stack) => Container(
              decoration: BoxDecoration(
                gradient: isDark
                    ? AppColors.backgroundGradientDark
                    : AppColors.backgroundGradient,
              ),
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.anErrorOccurred,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        },
        loading: () {
          final themeModeAsync = ref.watch(themeModeProvider);
          final themeMode = themeModeAsync.value ?? ThemeMode.system;
          final isDarkLoading = themeMode == ThemeMode.dark ||
              (themeMode == ThemeMode.system &&
                  MediaQuery.of(context).platformBrightness == Brightness.dark);

          return Container(
            decoration: BoxDecoration(
              gradient: isDarkLoading
                  ? AppColors.backgroundGradientDark
                  : AppColors.backgroundGradient,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.loading,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        },
        error: (error, stack) {
          final themeModeAsync = ref.watch(themeModeProvider);
          final themeMode = themeModeAsync.value ?? ThemeMode.system;
          final isDarkError = themeMode == ThemeMode.dark ||
              (themeMode == ThemeMode.system &&
                  MediaQuery.of(context).platformBrightness == Brightness.dark);

          return Container(
            decoration: BoxDecoration(
              gradient: isDarkError
                  ? AppColors.backgroundGradientDark
                  : AppColors.backgroundGradient,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.anErrorOccurred,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      AppLocalizations.of(context)!.eventInfoLoadFailed,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => ref
                        .invalidate(eventDetailsProvider(int.parse(widget.eventId))),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.15),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(AppLocalizations.of(context)!.retry),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String iconPath,
    String label,
    String value,
    bool isDark,
  ) {
    return _buildGlassEffect(
      isDark: isDark,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(
                iconPath,
                width: 18,
                height: 18,
                colorFilter: ColorFilter.mode(
                  AppTextStyles.getTextColor(context),
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  color: AppTextStyles.getTextColor(context),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresenterCard(
    BuildContext context,
    String name,
    String? email,
    String? position,
    bool isDark,
  ) {
    return _buildGlassEffect(
      isDark: isDark,
      child: Container(
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFF667eea),
            child: Text(
              name.substring(0, 1).toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          title: Text(
            name,
            style: TextStyle(
              color: AppTextStyles.getTextColor(context),
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (position != null) ...[
                const SizedBox(height: 4),
                Text(
                  position,
                  style: TextStyle(
                    color: AppTextStyles.getTextColor(context, opacity: 0.85),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              if (email != null) ...[
                const SizedBox(height: 3),
                Text(
                  email,
                  style: TextStyle(
                    color: AppTextStyles.getSecondaryTextColor(context),
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterButton(
    BuildContext context,
    WidgetRef ref,
    ClassModelPresentation presentation,
    bool isRegistered,
    bool isDark,
    String eventId,
  ) {
    final status = PresentationStatus.fromValue(presentation.status);

    return _RegisterActionButton(
      presentation: presentation,
      isRegistered: isRegistered,
      isDark: isDark,
      eventId: eventId,
      status: status,
    );
  }
}

class _RegisterActionButton extends ConsumerStatefulWidget {
  final ClassModelPresentation presentation;
  final bool isRegistered;
  final bool isDark;
  final String eventId;
  final PresentationStatus status;

  const _RegisterActionButton({
    required this.presentation,
    required this.isRegistered,
    required this.isDark,
    required this.eventId,
    required this.status,
  });

  @override
  ConsumerState<_RegisterActionButton> createState() =>
      _RegisterActionButtonState();
}

class _RegisterActionButtonState extends ConsumerState<_RegisterActionButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressController;
  late final Animation<double> _scaleAnimation;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
      reverseDuration: const Duration(milliseconds: 160),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(
        parent: _pressController,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (_isProcessing) {
      HapticFeedback.selectionClick();
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    HapticFeedback.selectionClick();

    final localizations = AppLocalizations.of(context)!;
    final userAsync = ref.read(userProfileProvider);
    var success = false;

    try {
      await userAsync.when(
        data: (user) async {
          if (user.id == null || widget.presentation.id == null) {
            toastMessage(localizations.userInfoNotFound);
            return;
          }

          try {
            if (widget.isRegistered) {
              await ref
                  .read(webServiceProvider)
                  .removeEvent(user.id!, widget.presentation.id!);
              toastMessage(localizations.unregistrationSuccess);
            } else {
              await ref
                  .read(webServiceProvider)
                  .registerEvent(user.id!, widget.presentation.id!);
              toastMessage(localizations.registrationSuccess);
            }

            ref.invalidate(sessionPresentationDataProvider);
            ref.invalidate(eventDetailsProvider(int.parse(widget.eventId)));
            success = true;
          } catch (e) {
            toastMessage(localizations.operationFailed);
            HapticFeedback.mediumImpact();
          }
        },
        loading: () {
          toastMessage(localizations.userInfoLoading);
        },
        error: (error, _) {
          toastMessage(localizations.userInfoFetchFailed);
          HapticFeedback.mediumImpact();
        },
      );
    } finally {
      if (!mounted) {
        return;
      }
      setState(() {
        _isProcessing = false;
      });
      if (success) {
        HapticFeedback.lightImpact();
      }
    }
  }

  void _onHighlightChanged(bool isHighlighted) {
    if (isHighlighted) {
      _pressController.forward();
    } else {
      _pressController.reverse();
    }
  }

  String _getButtonText(AppLocalizations localizations) {
    switch (widget.status) {
      case PresentationStatus.canRegister:
        return localizations.register;
      case PresentationStatus.alreadyRegistered:
        return localizations.unregister;
      case PresentationStatus.timePassed:
        return localizations.timeHasPassed;
      case PresentationStatus.sameSessionRegistered:
        return localizations.sameSessionRegistered;
      case PresentationStatus.quotaFull:
        return localizations.quotaFull;
      case PresentationStatus.registeredButTimePassed:
        return localizations.registeredTimePassed;
      case PresentationStatus.presentationNotFound:
        return localizations.presentationNotFound;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final buttonText = _getButtonText(localizations);
    final buttonIcon = widget.status.getIconPath();
    final buttonColors = widget.status.getButtonColors();

    final button = GradientButton(
      text: '',
      onPressed: _handleTap,
      isLoading: _isProcessing,
      enabled: !widget.status.isDisabled,
      gradientColors: buttonColors.cast<Color>(),
      onHighlightChanged: _onHighlightChanged,
      child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.92, end: 1.0).animate(animation),
                child: child,
              ),
            );
          },
          child: _isProcessing
              ? Row(
                  key: const ValueKey('processing'),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      localizations.processing,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Row(
                  key: ValueKey(buttonText),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      buttonIcon,
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      buttonText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
    );

    return _buildGlassEffect(
      isDark: widget.isDark,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: button,
      ),
    );
  }
}
