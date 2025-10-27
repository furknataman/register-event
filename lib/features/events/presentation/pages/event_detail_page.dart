import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/localization_helper.dart';
import '../../../../core/data/models/presentation_model.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/services/api/service.dart';
import '../../../../core/theme/theme_mode.dart';

// Resim listesi - home page ile aynı
const List<String> _lessonImages = [
  'assets/lesson_images/ADMINISTRATION.PNG',
  'assets/lesson_images/ARTS.PNG',
  'assets/lesson_images/BIOLOGY.png',
  'assets/lesson_images/CHEMISTRY.PNG',
  'assets/lesson_images/EARLY_YEARS.PNG',
  'assets/lesson_images/ESL.PNG',
  'assets/lesson_images/FOREIGN LANGUAGES.PNG',
  'assets/lesson_images/GENERAL_EDUCATION.PNG',
  'assets/lesson_images/GEOGRAPHY.png',
  'assets/lesson_images/GUIDANCE.PNG',
  'assets/lesson_images/HISTORY.PNG',
  'assets/lesson_images/IB_DP.PNG',
  'assets/lesson_images/IB_MYP.PNG',
  'assets/lesson_images/IB_PYP.PNG',
  'assets/lesson_images/INTERDISCIPLINARY.PNG',
  'assets/lesson_images/IT.png',
  'assets/lesson_images/LIBRARY.PNG',
  'assets/lesson_images/MATH.png',
  'assets/lesson_images/MUSIC.PNG',
  'assets/lesson_images/PE.png',
  'assets/lesson_images/PHILOSOPHY.png',
  'assets/lesson_images/PHYSICS.png',
  'assets/lesson_images/SCIENCE.png',
  'assets/lesson_images/SOCIAL_STUDIES.PNG',
  'assets/lesson_images/TURKISH.png',
];

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

class EventDetailPage extends ConsumerWidget {
  final String eventId;

  const EventDetailPage({
    super.key,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(eventDetailsProvider(int.parse(eventId)));
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: Text(AppLocalizations.of(context)!.description),
      ),
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
                    child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header image with overlay
                  RepaintBoundary(
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(24),
                            bottomRight: Radius.circular(24),
                          ),
                          child: Image.asset(
                            _lessonImages[(presentation.id ?? 0) % _lessonImages.length],
                            height: 300,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            cacheHeight: 600,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 300,
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
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(24),
                                bottomRight: Radius.circular(24),
                              ),
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
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          presentation.title ?? AppLocalizations.of(context)!.noTitleInfo,
                          style: TextStyle(
                            color: AppTextStyles.getTextColor(context),
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
                            if (presentation.presentationPlace != null)
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 56) / 2,
                                child: _buildInfoCard(
                                  context,
                                  'assets/svg/location-dot.svg',
                                  'Sunum Yeri',
                                  presentation.presentationPlace!,
                                  isDark,
                                ),
                              ),
                            if (presentation.time != null)
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 56) / 2,
                                child: _buildInfoCard(
                                  context,
                                  'assets/svg/clock.svg',
                                  'Sunum Saati',
                                  presentation.time!,
                                  isDark,
                                ),
                              ),
                            if (presentation.session != null)
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 56) / 2,
                                child: _buildInfoCard(
                                  context,
                                  'assets/svg/calendar.svg',
                                  'Oturum',
                                  '${AppLocalizations.of(context)!.session} ${presentation.session}',
                                  isDark,
                                ),
                              ),
                            if (presentation.quota != null && presentation.registrationCount != null)
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 56) / 2,
                                child: _buildInfoCard(
                                  context,
                                  'assets/svg/users.svg',
                                  'Kontenjan',
                                  '${presentation.registrationCount}/${presentation.quota}',
                                  isDark,
                                ),
                              ),
                            if (presentation.duration != null)
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 56) / 2,
                                child: _buildInfoCard(
                                  context,
                                  'assets/svg/hourglass.svg',
                                  'Süre',
                                  '${presentation.duration} ${AppLocalizations.of(context)!.minutes}',
                                  isDark,
                                ),
                              ),
                            if (presentation.language != null)
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 56) / 2,
                                child: _buildInfoCard(
                                  context,
                                  'assets/svg/globe.svg',
                                  'Dil',
                                  getLocalizedText(
                                    presentation.language,
                                    Localizations.localeOf(context).languageCode,
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
                              color: AppTextStyles.getTextColor(context),
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
                          if (presentation.presenter2Name != null) ...[
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
                          Text(
                            AppLocalizations.of(context)!.description,
                            style: TextStyle(
                              color: AppTextStyles.getTextColor(context),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildGlassEffect(
                            isDark: isDark,
                            child: Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.15)
                                    : Colors.white.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.3)
                                      : Colors.white.withValues(alpha: 0.4),
                                ),
                              ),
                              child: Text(
                                presentation.description!,
                                style: TextStyle(
                                  color: AppTextStyles.getTextColor(context, opacity: 0.95),
                                  height: 1.6,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
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
                      error.toString(),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(eventDetailsProvider(int.parse(eventId))),
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
  ) {
    return _buildGlassEffect(
      isDark: isDark,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            final userAsync = ref.read(userDataProvider);
            await userAsync.when(
              data: (user) async {
                if (user.id == null || presentation.id == null) return;

                try {
                  if (isRegistered) {
                    // Unregister
                    await ref.read(webServiceProvider).removeEvent(user.id!, presentation.id!);
                  } else {
                    // Register
                    await ref.read(webServiceProvider).registerEvent(user.id!, presentation.id!);
                  }
                  // Refresh data
                  ref.invalidate(sessionPresentationDataProvider);
                  ref.invalidate(eventDetailsProvider(int.parse(eventId)));
                } catch (e) {
                  // Show error if needed
                }
              },
              loading: () {},
              error: (_, __) {},
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/svg/bookmark.svg',
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  isRegistered
                      ? AppLocalizations.of(context)!.unregister
                      : AppLocalizations.of(context)!.register,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
