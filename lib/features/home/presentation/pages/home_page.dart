import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/localization_helper.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/locale_notifier.dart';
import '../../../../core/services/api/service.dart';
import '../../../notifications/presentation/pages/notification_page.dart';

// Resim listesi - sırayla kullanılacak
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

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionDataAsync = ref.watch(sessionPresentationDataProvider);
    final userDataAsync = ref.watch(userDataProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.getBackgroundGradient(context),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeaderBar(context, userDataAsync),
              _buildCategoryChips(context, ref, selectedCategory),
              Expanded(
                child: sessionDataAsync.when(
                  data: (sessionData) {
                    final pageController = ref.watch(categoryPageControllerProvider);

                    // Tüm kategorilerin sunumlarını liste olarak hazırla
                    final allCategories = [
                      sessionData.getAllPresentations(),
                      sessionData.oturum1,
                      sessionData.oturum2,
                      sessionData.oturum3,
                      sessionData.oturum4,
                      sessionData.getRegisteredPresentations(),
                    ];

                    return PageView.builder(
                      controller: pageController,
                      itemCount: allCategories.length,
                      onPageChanged: (index) {
                        ref.read(selectedCategoryProvider.notifier).state = index;

                        // Bottom bar'ı üste döndür
                        ref.read(resetBottomBarProvider.notifier).state++;

                        // Aktif chip'i görünür yap
                        final scrollController = ref.read(chipScrollControllerProvider);
                        if (scrollController.hasClients) {
                          // Her chip için ortalama genişlik (padding + text + margin)
                          final chipWidth = 120.0;
                          final screenWidth = MediaQuery.of(context).size.width;
                          final targetScroll = (index * chipWidth) - (screenWidth / 2) + (chipWidth / 2);

                          scrollController.animateTo(
                            targetScroll.clamp(0.0, scrollController.position.maxScrollExtent),
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      itemBuilder: (context, pageIndex) {
                        final presentations = allCategories[pageIndex];

                        return RefreshIndicator(
                          color: Colors.white,
                          backgroundColor: const Color(0xFF1a1a2e),
                          onRefresh: () async {
                            ref.invalidate(sessionPresentationDataProvider);
                          },
                          child: presentations.isEmpty
                              ? ListView(
                                  children: [
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 100),
                                        child: LiquidGlass(
                                          settings: LiquidGlassSettings(
                                            blur: 6,
                                            ambientStrength: 0.6,
                                            lightAngle: 0.2 * math.pi,
                                            glassColor: Colors.white.withValues(alpha: 0.1),
                                          ),
                                          shape: LiquidRoundedSuperellipse(
                                            borderRadius: const Radius.circular(20),
                                          ),
                                          glassContainsChild: false,
                                          child: Container(
                                            padding: const EdgeInsets.all(24),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withValues(alpha: 0.2),
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(
                                                color: Colors.white.withValues(alpha: 0.4),
                                                width: 1,
                                              ),
                                            ),
                                            child: Text(
                                              AppLocalizations.of(context)!.noEventsYet,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: presentations.length,
                                  itemBuilder: (context, index) {
                                    final presentation = presentations[index];
                                    final isRegistered = sessionData.kayitliSunum
                                        .any((r) => r.sunumId == presentation.id);

                                    // Oturum numarasını bul
                                    int? sessionNumber;
                                    if (sessionData.oturum1.contains(presentation)) {
                                      sessionNumber = 1;
                                    } else if (sessionData.oturum2.contains(presentation)) {
                                      sessionNumber = 2;
                                    } else if (sessionData.oturum3.contains(presentation)) {
                                      sessionNumber = 3;
                                    } else if (sessionData.oturum4.contains(presentation)) {
                                      sessionNumber = 4;
                                    }

                                    return TweenAnimationBuilder(
                                      duration: Duration(milliseconds: 300 + (index * 100)),
                                      tween: Tween<double>(begin: 0, end: 1),
                                      builder: (context, double value, child) {
                                        return Opacity(
                                          opacity: value,
                                          child: Transform.translate(
                                            offset: Offset(0, 50 * (1 - value)),
                                            child: child,
                                          ),
                                        );
                                      },
                                      child: _buildEventCard(
                                        context,
                                        ref,
                                        presentation,
                                        index,
                                        isRegistered,
                                        sessionNumber,
                                      ),
                                    );
                                  },
                                ),
                        );
                      },
                    );
                  },
                  loading: () => Center(
                    child: LiquidGlass(
                      settings: LiquidGlassSettings(
                        blur: 6,
                        ambientStrength: 0.6,
                        lightAngle: 0.2 * math.pi,
                        glassColor: Colors.white.withValues(alpha: 0.1),
                      ),
                      shape: LiquidRoundedSuperellipse(
                        borderRadius: const Radius.circular(20),
                      ),
                      glassContainsChild: false,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.4),
                            width: 1,
                          ),
                        ),
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  error: (error, stack) => Center(
                    child: LiquidGlass(
                      settings: LiquidGlassSettings(
                        blur: 6,
                        ambientStrength: 0.6,
                        lightAngle: 0.2 * math.pi,
                        glassColor: Colors.white.withValues(alpha: 0.1),
                      ),
                      shape: LiquidRoundedSuperellipse(
                        borderRadius: const Radius.circular(20),
                      ),
                      glassContainsChild: false,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.4),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error_outline, size: 64, color: Colors.white),
                            const SizedBox(height: 16),
                            Text(AppLocalizations.of(context)!.anErrorOccurred,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )),
                            const SizedBox(height: 8),
                            Text(
                              error.toString(),
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () => ref.invalidate(sessionPresentationDataProvider),
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
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips(BuildContext context, WidgetRef ref, int selectedCategory) {
    final categories = [
      AppLocalizations.of(context)!.categoryAll,
      AppLocalizations.of(context)!.session1,
      AppLocalizations.of(context)!.session2,
      AppLocalizations.of(context)!.session3,
      AppLocalizations.of(context)!.session4,
      AppLocalizations.of(context)!.myRegistrations,
    ];

    final pageController = ref.watch(categoryPageControllerProvider);
    final scrollController = ref.watch(chipScrollControllerProvider);

    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 4, bottom: 12),
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final isSelected = selectedCategory == index;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                // PageView'ı o sayfaya kaydır
                pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF667eea),
                            Color(0xFF764ba2),
                          ],
                        )
                      : null,
                  color: isSelected ? null : Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.3)
                        : Colors.white.withValues(alpha: 0.25),
                    width: isSelected ? 1.5 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFF667eea).withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      letterSpacing: 0.2,
                      shadows: isSelected
                          ? [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                offset: const Offset(0, 1),
                                blurRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                    child: Text(categories[index]),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderBar(BuildContext context, AsyncValue<dynamic> userDataAsync) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                // Notification Icon
                InkWell(
                  onTap: () {
                    showNotificationModal(context);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      'assets/svg/bell.svg',
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                // User Name
                userDataAsync.when(
                  data: (user) {
                    final fullName = '${user.name ?? ''} ${user.surname ?? ''}'.trim();
                    return Text(
                      fullName.isEmpty ? 'Kullanıcı' : fullName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  },
                  loading: () => const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                  error: (_, __) => const Text(
                    'Kullanıcı',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventCard(
    BuildContext context,
    WidgetRef ref,
    dynamic presentation,
    int index,
    bool isRegistered,
    int? sessionNumber,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: LiquidGlass(
        settings: LiquidGlassSettings(
          blur: 0,
          ambientStrength: 0.7,
          lightAngle: 0.3 * math.pi,
          glassColor: Colors.transparent,
          chromaticAberration: 0.0,
        ),
        shape: LiquidRoundedSuperellipse(
          borderRadius: const Radius.circular(24),
        ),
        glassContainsChild: false,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              context.push('/event/${presentation.id}');
            },
            borderRadius: BorderRadius.circular(24),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.28),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.45),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Image section with badges
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                        child: Image.asset(
                          _lessonImages[(presentation.id ?? 0) % _lessonImages.length],
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback gradient if image fails
                            return Container(
                              height: 200,
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
                      // Kayıt durumu icon badge - Sağ üst
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: isRegistered
                                      ? const Color(0xFF6366F1).withValues(alpha: 0.7)
                                      : Colors.grey.withValues(alpha: 0.6),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    width: 2.5,
                                  ),
                                ),
                                child: Icon(
                                  isRegistered ? Icons.bookmark : Icons.bookmark_border,
                                  size: 26,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Süre badge - Sağ alt
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.timer,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 7),
                                  Text(
                                    '${presentation.duration ?? '0'} ${AppLocalizations.of(context)!.minutes}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Oturum badge - Sol alt
                      if (sessionNumber != null)
                        Positioned(
                          bottom: 12,
                          left: 12,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.4),
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.event_note,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 7),
                                    Text(
                                      '${AppLocalizations.of(context)!.session} $sessionNumber',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black54,
                                            offset: Offset(0, 1),
                                            blurRadius: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  // Content section
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 20, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          presentation.title ?? AppLocalizations.of(context)!.noTitleInfo,
                          style: AppTextStyles.cardTitle(context),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        // Sunucu isimleri
                        if (presentation.presenter1Name != null)
                          Column(
                            children: [
                              _buildInfoRow(
                                context,
                                Icons.person,
                                presentation.presenter1Name!,
                              ),
                              if (presentation.presenter2Name != null) ...[
                                const SizedBox(height: 6),
                                _buildInfoRow(
                                  context,
                                  Icons.person,
                                  presentation.presenter2Name!,
                                ),
                              ],
                              const SizedBox(height: 8),
                            ],
                          ),
                        _buildInfoRow(
                          context,
                          Icons.business,
                          presentation.school ?? AppLocalizations.of(context)!.noInstitutionInfo,
                        ),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          context,
                          Icons.category,
                          getLocalizedText(
                            presentation.type,
                            ref.watch(localeProvider).languageCode,
                          ).isEmpty
                              ? AppLocalizations.of(context)!.noTypeInfo
                              : getLocalizedText(
                                  presentation.type,
                                  ref.watch(localeProvider).languageCode,
                                ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.22),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.38),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            presentation.branch ?? AppLocalizations.of(context)!.noBranchInfo,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppTextStyles.getSecondaryTextColor(context)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.cardSubtitle(context),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
