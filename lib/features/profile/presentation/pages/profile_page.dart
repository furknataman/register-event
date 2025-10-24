import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/locale_notifier.dart';
import '../../../../core/theme/theme_mode.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

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
          data: (user) => user != null
              ? _ProfileContent(user: user)
              : const _NotLoggedInContent(),
          loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.white),
                const SizedBox(height: 16),
                Text('Error: $error', style: const TextStyle(color: Colors.white)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.refresh(authNotifierProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileContent extends ConsumerWidget {
  final dynamic user; // Using dynamic temporarily until User model is available

  const _ProfileContent({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Header
          Container(
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
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    user.name?.substring(0, 1).toUpperCase() ?? 'U',
                    style: const TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name ?? 'Unknown User',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                      if (user.school != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          user.school!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.8),
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
          const SizedBox(height: 16),

          // Profile Information
          const Text(
            'Profile Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        const SizedBox(height: 12),

        _ProfileInfoCard(
          iconPath: 'assets/svg/envelope.svg',
          title: 'Email',
          value: user.email ?? 'Not provided',
        ),
        if (user.phone != null)
          _ProfileInfoCard(
            iconPath: 'assets/svg/phone.svg',
            title: 'Phone',
            value: user.phone!,
          ),
        if (user.school != null)
          _ProfileInfoCard(
            iconPath: 'assets/svg/school.svg',
            title: 'School',
            value: user.school!,
          ),
        if (user.branch != null)
          _ProfileInfoCard(
            iconPath: 'assets/svg/briefcase.svg',
            title: 'Branch',
            value: user.branch!,
          ),
        
        const SizedBox(height: 24),

        // Statistics
        const Text(
          'Statistics',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.event,
                title: 'Registered Events',
                value: '${user.registeredEventIds?.length ?? 0}',
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.check_circle,
                title: 'Attended Events',
                value: '${user.attendedEventIds?.length ?? 0}',
                color: Colors.green,
              ),
            ),
          ],
        ),
        
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
              Text(
                'Bu uygulama Eyüboğlu Eğitim Kurumları tarafından geliştirilmiştir',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Version 1.0.8 (8)',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 80),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.logout),
        content: Text(AppLocalizations.of(context)!.logoutConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await ref.read(authNotifierProvider.notifier).logout();
              if (context.mounted) {
                // Temporarily disable login flow; return to home instead
                context.go(AppRoutes.home);
              }
            },
            child: Text(AppLocalizations.of(context)!.logout, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showThemeSelection(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a2e),
        title: Text(AppLocalizations.of(context)!.themeSelection, style: const TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.light_mode, color: Colors.white),
              title: Text(AppLocalizations.of(context)!.lightTheme, style: const TextStyle(color: Colors.white)),
              onTap: () async {
                await ref.read(themeModeProvider.notifier).setLight();
                if (dialogContext.mounted) Navigator.of(dialogContext).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode, color: Colors.white),
              title: Text(AppLocalizations.of(context)!.darkTheme, style: const TextStyle(color: Colors.white)),
              onTap: () async {
                await ref.read(themeModeProvider.notifier).setDark();
                if (dialogContext.mounted) Navigator.of(dialogContext).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_system_daydream, color: Colors.white),
              title: Text(AppLocalizations.of(context)!.systemTheme, style: const TextStyle(color: Colors.white)),
              onTap: () async {
                await ref.read(themeModeProvider.notifier).setSystem();
                if (dialogContext.mounted) Navigator.of(dialogContext).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageSelection(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a2e),
        title: Text(AppLocalizations.of(context)!.languageSelection, style: const TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Text('🇹🇷', style: TextStyle(fontSize: 24)),
              title: Text(AppLocalizations.of(context)!.turkish, style: const TextStyle(color: Colors.white)),
              onTap: () async {
                await ref.read(localeProvider.notifier).setTurkish();
                if (dialogContext.mounted) Navigator.of(dialogContext).pop();
              },
            ),
            ListTile(
              leading: const Text('🇬🇧', style: TextStyle(fontSize: 24)),
              title: Text(AppLocalizations.of(context)!.english, style: const TextStyle(color: Colors.white)),
              onTap: () async {
                await ref.read(localeProvider.notifier).setEnglish();
                if (dialogContext.mounted) Navigator.of(dialogContext).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _NotLoggedInContent extends StatelessWidget {
  const _NotLoggedInContent();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_off, size: 64, color: Colors.white.withValues(alpha: 0.6)),
          const SizedBox(height: 16),
          const Text(
            'Not logged in',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please log in to view your profile',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 24),
          // Login disabled for now to keep bottom bar visible in shell
          const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class _ProfileInfoCard extends StatelessWidget {
  final String iconPath;
  final String title;
  final String value;

  const _ProfileInfoCard({
    required this.iconPath,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: ListTile(
        leading: SizedBox(
          width: 28,
          child: Center(
            child: SvgPicture.asset(
              iconPath,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                AppTextStyles.getTextColor(context),
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        title: Text(title, style: AppTextStyles.profileInfoTitle(context)),
        subtitle: Text(value, style: AppTextStyles.profileInfoSubtitle(context)),
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
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
