import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

import '../../../../core/animations/spring_animations.dart';
import '../../../../core/services/api/service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/image_helper.dart';
import '../../../../core/utils/localization_helper.dart';
import '../../../../core/widgets/adaptive_glass.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/locale_notifier.dart';
import '../../../notifications/presentation/pages/notification_page.dart';
import '../../../notifications/domain/providers/notification_provider.dart';

class HomeScrollState {
  const HomeScrollState({
    this.isHeaderVisible = true,
    this.lastScrollOffset = 0.0,
    this.scrollStartOffset = 0.0,
    this.wasScrollingDown = false,
  });

  final bool isHeaderVisible;
  final double lastScrollOffset;
  final double scrollStartOffset;
  final bool wasScrollingDown;

  HomeScrollState copyWith({
    bool? isHeaderVisible,
    double? lastScrollOffset,
    double? scrollStartOffset,
    bool? wasScrollingDown,
  }) {
    return HomeScrollState(
      isHeaderVisible: isHeaderVisible ?? this.isHeaderVisible,
      lastScrollOffset: lastScrollOffset ?? this.lastScrollOffset,
      scrollStartOffset: scrollStartOffset ?? this.scrollStartOffset,
      wasScrollingDown: wasScrollingDown ?? this.wasScrollingDown,
    );
  }
}

class HomeScrollNotifier extends Notifier<HomeScrollState> {
  @override
  HomeScrollState build() => const HomeScrollState();

  static const double _scrollThreshold = 10.0;
  static const double _showThreshold = 50.0;

  bool handleScrollNotification(ScrollNotification notification) {
    if (notification.metrics.axis != Axis.vertical) {
      return false;
    }

    if (notification is ScrollUpdateNotification) {
      final currentOffset = notification.metrics.pixels;
      final delta = currentOffset - state.lastScrollOffset;

      if (delta.abs() > _scrollThreshold) {
        final isScrollingDown = delta > 0;
        var scrollStartOffset = state.scrollStartOffset;
        var wasScrollingDown = state.wasScrollingDown;
        var isHeaderVisible = state.isHeaderVisible;

        if (isScrollingDown != wasScrollingDown) {
          scrollStartOffset = currentOffset;
          wasScrollingDown = isScrollingDown;
        }

        if (isScrollingDown && isHeaderVisible && currentOffset > 50) {
          isHeaderVisible = false;
        } else if (!isScrollingDown && !isHeaderVisible) {
          final scrolledUpDistance = scrollStartOffset - currentOffset;
          if (scrolledUpDistance >= _showThreshold) {
            isHeaderVisible = true;
          }
        }

        state = state.copyWith(
          isHeaderVisible: isHeaderVisible,
          lastScrollOffset: currentOffset,
          scrollStartOffset: scrollStartOffset,
          wasScrollingDown: wasScrollingDown,
        );
      }
    }

    return false;
  }

  void showHeader() {
    if (!state.isHeaderVisible) {
      state = state.copyWith(isHeaderVisible: true);
    }
  }
}

final homeScrollProvider =
    NotifierProvider.autoDispose<HomeScrollNotifier, HomeScrollState>(
  HomeScrollNotifier.new,
);

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static const double _headerHeight = 76.0;
  static const double _chipsHeight = 66.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionDataAsync = ref.watch(sessionPresentationDataProvider);
    final userDataAsync = ref.watch(userProfileProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final localeAsync = ref.watch(localeProvider);
    final languageCode = localeAsync.value?.languageCode ?? 'tr';
    final scrollState = ref.watch(homeScrollProvider);
    final scrollNotifier = ref.read(homeScrollProvider.notifier);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.getBackgroundGradient(context),
        ),
        child: SafeArea(
          child: NotificationListener<ScrollNotification>(
            onNotification: scrollNotifier.handleScrollNotification,
            child: Stack(
              children: [
                // Full-screen scroll view with padding
                Positioned.fill(
                  child: AnimatedPadding(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    padding: EdgeInsets.only(
                      top: scrollState.isHeaderVisible
                          ? (_headerHeight + _chipsHeight)
                          : 0,
                    ),
                    child: sessionDataAsync.when(
                      data: (sessionData) {
                        final pageController =
                            ref.watch(categoryPageControllerProvider);

                        // Tüm kategorilerin sunumlarını liste olarak hazırla
                        final allCategories = [
                          sessionData.getAllPresentations(),
                          sessionData.getRegisteredPresentations(),
                          sessionData.oturum1,
                          sessionData.oturum2,
                          sessionData.oturum3,
                          sessionData.oturum4,
                        ];

                        return PageView.builder(
                          controller: pageController,
                          itemCount: allCategories.length,
                          onPageChanged: (index) {
                            // PageView geçişinde header'ı göster
                            scrollNotifier.showHeader();

                            ref
                                .read(selectedCategoryProvider.notifier)
                                .set(index);

                            // Bottom bar'ı üste döndür
                            ref
                                .read(resetBottomBarProvider.notifier)
                                .increment();

                            // Aktif chip'i görünür yap
                            final scrollController =
                                ref.read(chipScrollControllerProvider);
                            if (scrollController.hasClients) {
                              // Her chip için ortalama genişlik (padding + text + margin)
                              final chipWidth = 120.0;
                              final screenWidth =
                                  MediaQuery.of(context).size.width;
                              final targetScroll = (index * chipWidth) -
                                  (screenWidth / 2) +
                                  (chipWidth / 2);

                              scrollController.animateTo(
                                targetScroll.clamp(0.0,
                                    scrollController.position.maxScrollExtent),
                                duration: SpringAnimations.standard,
                                curve: SpringAnimations.standardSpring,
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
                                ref.invalidate(unreadCountProvider);
                              },
                              child: presentations.isEmpty
                                  ? ListView(
                                      children: [
                                        Center(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 100),
                                            child: AdaptiveGlass(
                                              borderRadius:
                                                  const Radius.circular(20),
                                              settings: LiquidGlassSettings(
                                                blur: 6,
                                                ambientStrength: 0.6,
                                                lightAngle: 0.2 * math.pi,
                                                glassColor: Colors.white
                                                    .withValues(alpha: 0.1),
                                              ),
                                              fallbackBlur: 6,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(24),
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  border: Border.all(
                                                    color: Colors.white
                                                        .withValues(alpha: 0.4),
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .noEventsYet,
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
                                        final presentation =
                                            presentations[index];
                                        final isRegistered =
                                            sessionData.kayitliSunum.any((r) =>
                                                r.sunumId == presentation.id);

                                        // Oturum numarasını bul
                                        int? sessionNumber;
                                        if (sessionData.oturum1
                                            .contains(presentation)) {
                                          sessionNumber = 1;
                                        } else if (sessionData.oturum2
                                            .contains(presentation)) {
                                          sessionNumber = 2;
                                        } else if (sessionData.oturum3
                                            .contains(presentation)) {
                                          sessionNumber = 3;
                                        } else if (sessionData.oturum4
                                            .contains(presentation)) {
                                          sessionNumber = 4;
                                        }

                                        // Spring list item animation
                                        return SpringListItem(
                                          index: index,
                                          delay: Duration(
                                              milliseconds: index * 60),
                                          child: RepaintBoundary(
                                            child: _buildEventCard(
                                              context,
                                              ref,
                                              presentation,
                                              index,
                                              isRegistered,
                                              languageCode,
                                              sessionNumber,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            );
                          },
                        );
                      },
                      loading: () => Center(
                        child: AdaptiveGlass(
                          borderRadius: const Radius.circular(20),
                          settings: LiquidGlassSettings(
                            blur: 6,
                            ambientStrength: 0.6,
                            lightAngle: 0.2 * math.pi,
                            glassColor: Colors.white.withValues(alpha: 0.1),
                          ),
                          fallbackBlur: 6,
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
                        child: AdaptiveGlass(
                          borderRadius: const Radius.circular(20),
                          settings: LiquidGlassSettings(
                            blur: 6,
                            ambientStrength: 0.6,
                            lightAngle: 0.2 * math.pi,
                            glassColor: Colors.white.withValues(alpha: 0.1),
                          ),
                          fallbackBlur: 6,
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
                                const Icon(Icons.error_outline,
                                    size: 64, color: Colors.white),
                                const SizedBox(height: 16),
                                Text(
                                    AppLocalizations.of(context)!
                                        .anErrorOccurred,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    )),
                                const SizedBox(height: 8),
                                Text(
                                  AppLocalizations.of(context)!
                                      .eventsLoadFailed,
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),
                                ElevatedButton(
                                  onPressed: () => ref.invalidate(
                                      sessionPresentationDataProvider),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.white.withValues(alpha: 0.15),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child:
                                      Text(AppLocalizations.of(context)!.retry),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Header overlay
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: AnimatedSlide(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    offset: scrollState.isHeaderVisible
                        ? Offset.zero
                        : const Offset(0, -1.0),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: scrollState.isHeaderVisible ? 1.0 : 0.0,
                      child: _buildHeaderBar(context, ref, userDataAsync),
                    ),
                  ),
                ),
                // Chips overlay
                Positioned(
                  top: _headerHeight,
                  left: 0,
                  right: 0,
                  child: AnimatedSlide(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    offset: scrollState.isHeaderVisible
                        ? Offset.zero
                        : const Offset(0, -1.3),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: scrollState.isHeaderVisible ? 1.0 : 0.0,
                      child:
                          _buildCategoryChips(context, ref, selectedCategory),
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

  Widget _buildCategoryChips(
      BuildContext context, WidgetRef ref, int selectedCategory) {
    final categories = [
      AppLocalizations.of(context)!.categoryAll,
      AppLocalizations.of(context)!.myRegistrations,
      AppLocalizations.of(context)!.session1,
      AppLocalizations.of(context)!.session2,
      AppLocalizations.of(context)!.session3,
      AppLocalizations.of(context)!.session4,
    ];

    final pageController = ref.watch(categoryPageControllerProvider);
    final scrollController = ref.watch(chipScrollControllerProvider);

    return Container(
      height: 52,
      margin: const EdgeInsets.only(top: 12, bottom: 2),
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final isSelected = selectedCategory == index;
          return Padding(
            padding: const EdgeInsets.only(right: 4),
            child: GestureDetector(
              onTap: () {
                // PageView'ı spring animasyonla kaydır
                pageController.animateToPage(
                  index,
                  duration: SpringAnimations.standard,
                  curve: SpringAnimations.standardSpring,
                );
              },
              child: AnimatedContainer(
                duration: SpringAnimations.fast,
                curve: SpringAnimations.gentleSpring,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
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
                  color:
                      isSelected ? null : Colors.white.withValues(alpha: 0.2),
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
                            color:
                                const Color(0xFF667eea).withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: AnimatedDefaultTextStyle(
                    duration: SpringAnimations.fast,
                    curve: SpringAnimations.gentleSpring,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
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

  Widget _buildHeaderBar(
      BuildContext context, WidgetRef ref, AsyncValue<dynamic> userDataAsync) {
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
            child: InkWell(
              onTap: () {
                showNotificationModal(context);
              },
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    // User Name - EN SOLDA
                    userDataAsync.when(
                      data: (user) {
                        final userName = user.name?.trim() ?? '';
                        return Text(
                          userName.isEmpty ? AppLocalizations.of(context)!.user : userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
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
                      error: (_, __) => Text(
                        AppLocalizations.of(context)!.user,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Notification Icon with Badge - EN SAĞDA
                    _buildBellIconWithBadge(ref),
                  ],
                ),
              ),
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
    String languageCode,
    int? sessionNumber,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: AdaptiveGlass(
        borderRadius: const Radius.circular(24),
        settings: LiquidGlassSettings(
          blur: 0,
          ambientStrength: 0.7,
          lightAngle: 0.3 * math.pi,
          glassColor: Colors.transparent,
          chromaticAberration: 0.0,
        ),
        fallbackBlur: 0,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              context.push('/event/${presentation.id}');
            },
            borderRadius: BorderRadius.circular(24),
            child: Container(
              decoration: BoxDecoration(
                color: isRegistered
                    ? Colors.green.withValues(alpha: 0.15)
                    : Colors.white.withValues(alpha: 0.28),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isRegistered
                      ? Colors.green.shade400
                      : Colors.white.withValues(alpha: 0.45),
                  width: isRegistered ? 2 : 1,
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
                          ImageHelper.getImageForBranch(presentation.branch),
                          width: double.infinity,
                          fit: BoxFit.fitWidth,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback gradient if image fails
                            return AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Container(
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
                          child: AdaptiveGlass(
                            borderRadius: const Radius.circular(50),
                            settings: LiquidGlassSettings(
                              blur: 6,
                              ambientStrength: 0.6,
                              lightAngle: 0.2 * math.pi,
                              glassColor: Colors.transparent,
                              chromaticAberration: 0.0,
                            ),
                            fallbackBlur: 0,
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: isRegistered
                                    ? const Color(0xFF10B981)
                                        .withValues(alpha: 0.8)
                                    : Colors.grey.withValues(alpha: 0.6),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  width: 2.5,
                                ),
                              ),
                              child: Icon(
                                isRegistered
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                                size: 26,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Süre badge - Sağ alt
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: AdaptiveGlass(
                          borderRadius: const Radius.circular(14),
                          settings: LiquidGlassSettings(
                            blur: 10,
                            ambientStrength: 0.7,
                            lightAngle: 0.3 * math.pi,
                            glassColor: Colors.transparent,
                            chromaticAberration: 0.0,
                          ),
                          fallbackBlur: 0,
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
                      // Oturum badge - Sol alt
                      if (sessionNumber != null)
                        Positioned(
                          bottom: 12,
                          left: 12,
                          child: AdaptiveGlass(
                            borderRadius: const Radius.circular(14),
                            settings: LiquidGlassSettings(
                              blur: 10,
                              ambientStrength: 0.7,
                              lightAngle: 0.3 * math.pi,
                              glassColor: Colors.transparent,
                              chromaticAberration: 0.0,
                            ),
                            fallbackBlur: 0,
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
                    ],
                  ),
                  // Content section
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 20, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          presentation.title ??
                              AppLocalizations.of(context)!.noTitleInfo,
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
                          presentation.school ??
                              AppLocalizations.of(context)!.noInstitutionInfo,
                        ),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          context,
                          Icons.category,
                          getLocalizedText(
                            presentation.type,
                            languageCode,
                          ).isEmpty
                              ? AppLocalizations.of(context)!.noTypeInfo
                              : getLocalizedText(
                                  presentation.type,
                                  languageCode,
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
        Icon(icon,
            size: 18, color: AppTextStyles.getSecondaryTextColor(context)),
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

  Widget _buildBellIconWithBadge(WidgetRef ref) {
    final unreadCountAsync = ref.watch(unreadCountProvider);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        SvgPicture.asset(
          'assets/svg/bell.svg',
          width: 26,
          height: 26,
          colorFilter: const ColorFilter.mode(
            Colors.white,
            BlendMode.srcIn,
          ),
        ),
        unreadCountAsync.when(
          data: (count) {
            if (count == 0) return const SizedBox.shrink();

            return Positioned(
              right: -6,
              top: -6,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF4444),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 1.5,
                  ),
                ),
                constraints: const BoxConstraints(
                  minWidth: 10,
                  minHeight: 10,
                ),
              ),
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }
}
