import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/locale_notifier.dart';
import '../../../../core/theme/theme_mode.dart';
import '../../../../core/widgets/settings_bottom_sheet.dart';
import '../../../../core/services/api/service.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(userProfileProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: Text(AppLocalizations.of(context)!.profile),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.getBackgroundGradient(context),
        ),
        child: authState.when(
          data: (user) => const _ProfileContent(),
          loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.white),
                const SizedBox(height: 16),
                Text(AppLocalizations.of(context)!.profileLoadFailed, style: const TextStyle(color: Colors.white)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.refresh(userProfileProvider),
                  child: Text(AppLocalizations.of(context)!.retry),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileContent extends ConsumerStatefulWidget {
  const _ProfileContent();

  @override
  ConsumerState<_ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends ConsumerState<_ProfileContent> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProfileProvider).value;
    if (user == null) return const SizedBox.shrink();

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(userProfileProvider);
          await ref.read(userProfileProvider.future);
        },
        color: Colors.white,
        backgroundColor: Colors.white.withValues(alpha: 0.2),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
          // Statistics
          Text(
            AppLocalizations.of(context)!.statistics,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),

          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.event,
                    title: AppLocalizations.of(context)!.registeredEvents,
                    value: '${user.registeredPresentationCount ?? 0}',
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.check_circle,
                    title: AppLocalizations.of(context)!.attendedEvents,
                    value: '${user.attendanceCount ?? 0}',
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),

          // General Attendance Badge
          if (user.generalRollCall == true) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.green.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.generalAttendanceTaken,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),

        // Actions
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              ListTile(
                leading: SizedBox(
                  width: 24,
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/svg/calendar.svg',
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                  ),
                ),
                title: Text(AppLocalizations.of(context)!.dailySchedule, style: const TextStyle(color: Colors.white)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
                onTap: () => context.push(AppRoutes.schedule),
              ),
              Divider(height: 1, color: Colors.white.withValues(alpha: 0.2)),
              ListTile(
                leading: SizedBox(
                  width: 24,
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/svg/map-location-dot.svg',
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                  ),
                ),
                title: Text(AppLocalizations.of(context)!.campusMap, style: const TextStyle(color: Colors.white)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
                onTap: () => context.push(AppRoutes.campusMap),
              ),
              if (user.anket != null && user.anket!.isNotEmpty) ...[
                Divider(height: 1, color: Colors.white.withValues(alpha: 0.2)),
                ListTile(
                  leading: SizedBox(
                    width: 24,
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/svg/clipboard-list.svg',
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      ),
                    ),
                  ),
                  title: Text(AppLocalizations.of(context)!.ibdaySurvey, style: const TextStyle(color: Colors.white)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
                  onTap: () async {
                    try {
                      final uri = Uri.parse(user.anket!);
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    } catch (e) {
                      debugPrint('Could not launch survey URL: $e');
                    }
                  },
                ),
              ],
              Divider(height: 1, color: Colors.white.withValues(alpha: 0.2)),
              ListTile(
                leading: SizedBox(
                  width: 24,
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/svg/moon.svg',
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                  ),
                ),
                title: Text(AppLocalizations.of(context)!.themeSelection, style: const TextStyle(color: Colors.white)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
                onTap: () => _showThemeSelection(context, ref),
              ),
              Divider(height: 1, color: Colors.white.withValues(alpha: 0.2)),
              ListTile(
                leading: SizedBox(
                  width: 24,
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/svg/globe.svg',
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                  ),
                ),
                title: Text(AppLocalizations.of(context)!.languageSelection, style: const TextStyle(color: Colors.white)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
                onTap: () => _showLanguageSelection(context, ref),
              ),
              Divider(height: 1, color: Colors.white.withValues(alpha: 0.2)),
              ListTile(
                leading: SizedBox(
                  width: 24,
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/svg/arrow-right-from-bracket.svg',
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
                    ),
                  ),
                ),
                title: Text(AppLocalizations.of(context)!.logout, style: const TextStyle(color: Colors.red)),
                onTap: () => _showLogoutDialog(context, ref),
              ),
            ],
          ),
        ),

        // Personal Information Section
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: SizedBox(
                width: 24,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/svg/circle-user.svg',
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                ),
              ),
              title: Text(
                AppLocalizations.of(context)!.profileInformation,
                style: const TextStyle(color: Colors.white),
              ),
              trailing: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
              iconColor: Colors.white,
              collapsedIconColor: Colors.white,
              children: [
                Divider(height: 1, color: Colors.white.withValues(alpha: 0.2)),
                _buildProfileInfoRow(
                  context,
                  'assets/svg/envelope.svg',
                  AppLocalizations.of(context)!.profileEmail,
                  user.email ?? AppLocalizations.of(context)!.notProvided,
                ),
                if (user.telephone != null && user.telephone != '0' && user.telephone!.isNotEmpty)
                  _buildProfileInfoRow(
                    context,
                    'assets/svg/phone.svg',
                    AppLocalizations.of(context)!.profilePhone,
                    user.telephone!,
                  ),
                if (user.school != null && user.school!.isNotEmpty)
                  _buildProfileInfoRow(
                    context,
                    'assets/svg/school.svg',
                    AppLocalizations.of(context)!.profileSchool,
                    user.school!,
                  ),
                if (user.job != null && user.job!.isNotEmpty)
                  _buildProfileInfoRow(
                    context,
                    'assets/svg/briefcase.svg',
                    AppLocalizations.of(context)!.profileJobTitle,
                    user.job!,
                  ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),

        // Footer Section
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svg/copyright.svg',
                    width: 16,
                    height: 16,
                    colorFilter: ColorFilter.mode(
                      Colors.white.withValues(alpha: 0.7),
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      AppLocalizations.of(context)!.appDevelopedBy,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Eyuboglu Logo
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(
                  'assets/images/eek_white.png',
                  height: 60,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 12),
              // Dynamic Version Info
              FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final info = snapshot.data!;
                    return Text(
                      '${AppLocalizations.of(context)!.version} ${info.version} (${info.buildNumber})',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 11,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) async {
    final result = await showLiquidGlassLogoutDialog(
      context: context,
      title: AppLocalizations.of(context)!.logout,
      message: AppLocalizations.of(context)!.logoutConfirmation,
      cancelText: AppLocalizations.of(context)!.cancel,
      confirmText: AppLocalizations.of(context)!.logout,
    );

    if (result == true) {
      await ref.read(authNotifierProvider.notifier).logout();
      if (context.mounted) {
        context.go(AppRoutes.login);
      }
    }
  }

  void _showThemeSelection(BuildContext context, WidgetRef ref) async {
    final currentThemeAsync = ref.read(themeModeProvider);
    final currentTheme = currentThemeAsync.value ?? ThemeMode.system;

    final result = await showLiquidGlassBottomSheet<ThemeMode>(
      context: context,
      title: AppLocalizations.of(context)!.themeSelection,
      currentValue: currentTheme,
      options: [
        LiquidGlassOption(
          value: ThemeMode.light,
          label: AppLocalizations.of(context)!.lightTheme,
          iconPath: 'assets/svg/sun.svg',
        ),
        LiquidGlassOption(
          value: ThemeMode.dark,
          label: AppLocalizations.of(context)!.darkTheme,
          iconPath: 'assets/svg/moon.svg',
        ),
        LiquidGlassOption(
          value: ThemeMode.system,
          label: AppLocalizations.of(context)!.systemTheme,
          iconPath: 'assets/svg/circle-half-stroke.svg',
        ),
      ],
    );

    if (result != null) {
      switch (result) {
        case ThemeMode.light:
          await ref.read(themeModeProvider.notifier).setLight();
        case ThemeMode.dark:
          await ref.read(themeModeProvider.notifier).setDark();
        case ThemeMode.system:
          await ref.read(themeModeProvider.notifier).setSystem();
      }
    }
  }

  void _showLanguageSelection(BuildContext context, WidgetRef ref) async {
    final currentLocaleAsync = ref.read(localeProvider);
    final currentLocale = currentLocaleAsync.value;
    final currentLanguage = currentLocale?.languageCode ?? 'tr';

    final result = await showLiquidGlassBottomSheet<String>(
      context: context,
      title: AppLocalizations.of(context)!.languageSelection,
      currentValue: currentLanguage,
      options: [
        LiquidGlassOption(
          value: 'tr',
          label: AppLocalizations.of(context)!.turkish,
          emoji: '🇹🇷',
        ),
        LiquidGlassOption(
          value: 'en',
          label: AppLocalizations.of(context)!.english,
          emoji: '🇬🇧',
        ),
      ],
    );

    if (result != null) {
      if (result == 'tr') {
        await ref.read(localeProvider.notifier).setTurkish();
      } else if (result == 'en') {
        await ref.read(localeProvider.notifier).setEnglish();
      }
    }
  }

  Widget _buildProfileInfoRow(BuildContext context, String iconPath, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Center(
              child: SvgPicture.asset(
                iconPath,
                width: 18,
                height: 18,
                colorFilter: ColorFilter.mode(
                  Colors.white.withValues(alpha: 0.7),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
