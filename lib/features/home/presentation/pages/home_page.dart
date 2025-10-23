import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../services/service.dart';

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
    final presentationsAsync = ref.watch(presentationDataProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: presentationsAsync.when(
            data: (presentations) => RefreshIndicator(
              color: Colors.white,
              backgroundColor: const Color(0xFF1a1a2e),
              onRefresh: () async {
                ref.invalidate(presentationDataProvider);
              },
              child: presentations.isEmpty
                  ? Center(
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
                          child: const Text(
                            'Henüz etkinlik yok',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: presentations.length,
                      itemBuilder: (context, index) {
                        final presentation = presentations[index];
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
                          ),
                        );
                      },
                    ),
            ),
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
                      const Text('Bir hata oluştu',
                          style: TextStyle(
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
                        onPressed: () => ref.invalidate(presentationDataProvider),
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
                        child: const Text('Tekrar Dene'),
                      ),
                    ],
                  ),
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
    dynamic presentation,
    int index,
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
                  // Image section
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
                  // Content section
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 20, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          presentation.title ?? 'Başlık Yok',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          Icons.business,
                          presentation.school ?? 'Kurum bilgisi yok',
                        ),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          Icons.timer,
                          '${presentation.duration ?? '0'} dakika',
                        ),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          Icons.category,
                          presentation.type ?? 'Tip bilgisi yok',
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
                            presentation.branch ?? 'Alan bilgisi yok',
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

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.black87),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
