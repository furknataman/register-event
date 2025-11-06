import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/api/service.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/locale_notifier.dart';
import '../../../../core/animations/spring_animations.dart';

class SchedulePage extends ConsumerWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programFlowAsync = ref.watch(programFlowProvider);
    final localeAsync = ref.watch(localeProvider);
    final languageCode = localeAsync.value?.languageCode ?? 'tr';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: Text(AppLocalizations.of(context)!.dailySchedule),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.getBackgroundGradient(context),
        ),
        child: SafeArea(
          child: programFlowAsync.when(
            data: (programList) {
              if (programList.isEmpty) {
                return _buildEmptyState(context);
              }

              return RefreshIndicator(
                color: Colors.white,
                backgroundColor: const Color(0xFF1a1a2e),
                onRefresh: () async {
                  ref.invalidate(programFlowProvider);
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: programList.length,
                  itemBuilder: (context, index) {
                    final program = programList[index];

                    return SpringListItem(
                      index: index,
                      child: _ProgramCard(
                        program: program,
                        languageCode: languageCode,
                        index: index,
                      ),
                    );
                  },
                ),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.white),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.scheduleLoadFailed,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.refresh(programFlowProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
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
    );
  }
}

class _ProgramCard extends StatelessWidget {
  final dynamic program;
  final String languageCode;
  final int index;

  const _ProgramCard({
    required this.program,
    required this.languageCode,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final localizedProgram = program.getLocalizedProgram(languageCode);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
                width: 1.5,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Time Badge - Kompakt versiyon
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: Colors.white,
                        size: 22,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        program.baslangicSaati.substring(0, 5),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        width: 22,
                        height: 1,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                      Text(
                        program.bitisSaati.substring(0, 5),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Program Description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizedProgram.replaceAll('\\n', '\n'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
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
    );
  }
}
