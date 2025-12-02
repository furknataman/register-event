import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autumn_conference/core/data/models/presentation_model.dart';
import 'package:autumn_conference/core/providers/navigation_state.dart';
import 'package:autumn_conference/core/services/api/service.dart';
import 'package:autumn_conference/core/theme/app_colors.dart';
import 'package:autumn_conference/core/utils/localization_helper.dart';
import 'package:autumn_conference/core/utils/image_helper.dart';
import 'package:autumn_conference/core/widgets/adaptive_glass.dart';
import 'package:autumn_conference/l10n/app_localizations.dart';
import 'package:autumn_conference/l10n/locale_notifier.dart';

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void update(String query) {
    if (state != query) {
      state = query;
    }
  }
}

final searchQueryProvider =
    NotifierProvider.autoDispose<SearchQueryNotifier, String>(
  SearchQueryNotifier.new,
);

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      final trimmedQuery = query.toLowerCase().trim();
      ref.read(searchQueryProvider.notifier).update(trimmedQuery);

      // Eğer query boşsa bottom bar'ı geri getir
      if (trimmedQuery.isEmpty) {
        ref.read(resetBottomBarProvider.notifier).increment();
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(0);
        }
      }
    });
  }

  List<ClassModelPresentation> _filterEvents(
    List<ClassModelPresentation> events,
    String searchQuery,
  ) {
    if (searchQuery.isEmpty) {
      return events;
    }

    final normalizedQuery = searchQuery.toLowerCase();

    return events.where((event) {
      final title = (event.title ?? '').toLowerCase();
      final presenter1 = (event.presenter1Name ?? '').toLowerCase();
      final presenter2 = (event.presenter2Name ?? '').toLowerCase();
      final school = (event.school ?? '').toLowerCase();
      final type = (event.type ?? '').toLowerCase();
      final branch = (event.branch ?? '').toLowerCase();

      return title.contains(normalizedQuery) ||
          presenter1.contains(normalizedQuery) ||
          presenter2.contains(normalizedQuery) ||
          school.contains(normalizedQuery) ||
          type.contains(normalizedQuery) ||
          branch.contains(normalizedQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final eventData = ref.watch(sessionPresentationDataProvider);
    final localeAsync = ref.watch(localeProvider);
    final languageCode = localeAsync.value?.languageCode ?? 'tr';
    final searchQuery = ref.watch(searchQueryProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.getBackgroundGradient(context),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.25),
                          width: 1.5,
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                        autofocus: true,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          hintText:
                              AppLocalizations.of(context)!.searchPlaceholder,
                          hintStyle: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 16,
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: SvgPicture.asset(
                              'assets/svg/search.svg',
                              width: 24,
                              height: 24,
                              colorFilter: ColorFilter.mode(
                                Colors.white.withValues(alpha: 0.8),
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    ref
                                        .read(searchQueryProvider.notifier)
                                        .update('');
                                    // Bottom bar'ı geri getir
                                    ref
                                        .read(resetBottomBarProvider.notifier)
                                        .increment();
                                    // Scroll pozisyonunu reset et
                                    if (_scrollController.hasClients) {
                                      _scrollController.jumpTo(0);
                                    }
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Results
              Expanded(
                child: eventData.when(
                  loading: () => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/svg/search.svg',
                          width: 80,
                          height: 80,
                          colorFilter: ColorFilter.mode(
                            Colors.white.withValues(alpha: 0.4),
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          AppLocalizations.of(context)!.startSearching,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  error: (err, stack) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/svg/search.svg',
                          width: 80,
                          height: 80,
                          colorFilter: ColorFilter.mode(
                            Colors.white.withValues(alpha: 0.4),
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          AppLocalizations.of(context)!.startSearching,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  data: (sessionData) {
                    final allEvents = sessionData.getAllPresentations();
                    final filteredEvents =
                        _filterEvents(allEvents, searchQuery);

                    if (searchQuery.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/svg/search.svg',
                              width: 80,
                              height: 80,
                              colorFilter: ColorFilter.mode(
                                Colors.white.withValues(alpha: 0.4),
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              AppLocalizations.of(context)!.startSearching,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (filteredEvents.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/svg/search.svg',
                              width: 64,
                              height: 64,
                              colorFilter: ColorFilter.mode(
                                Colors.white.withValues(alpha: 0.6),
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              AppLocalizations.of(context)!.noResults,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              AppLocalizations.of(context)!
                                  .noResultsFor(searchQuery),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return Column(
                      children: [
                        // Sonuç sayısı
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              AppLocalizations.of(context)!
                                  .searchResultsCount(filteredEvents.length.toString()),
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        // Sonuç listesi
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, top: 10, bottom: 70),
                            physics: const BouncingScrollPhysics(),
                            itemCount: filteredEvents.length,
                            itemBuilder: (context, index) {
                              final presentation = filteredEvents[index];

                              // Kayıt durumu
                              final isRegistered = sessionData.kayitliSunum
                                  .any((r) => r.sunumId == presentation.id);

                              // Oturum numarası
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
                                  presentation,
                                  index,
                                  languageCode,
                                  isRegistered,
                                  sessionNumber,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventCard(
    BuildContext context,
    dynamic presentation,
    int index,
    String languageCode,
    bool isRegistered,
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
                          ImageHelper.getImageForBranch(presentation.branch),
                          height: 220,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback gradient if image fails
                            return Container(
                              height: 220,
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
                                    ? const Color(0xFF6366F1)
                                        .withValues(alpha: 0.7)
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
                                Icons.person,
                                presentation.presenter1Name!,
                              ),
                              if (presentation.presenter2Name != null) ...[
                                const SizedBox(height: 6),
                                _buildInfoRow(
                                  Icons.person,
                                  presentation.presenter2Name!,
                                ),
                              ],
                              const SizedBox(height: 8),
                            ],
                          ),
                        _buildInfoRow(
                          Icons.business,
                          presentation.school ??
                              AppLocalizations.of(context)!.noInstitutionInfo,
                        ),
                        const SizedBox(height: 8),
                        _buildInfoRow(
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

  Widget _buildInfoRow(IconData icon, String text) {
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
}
