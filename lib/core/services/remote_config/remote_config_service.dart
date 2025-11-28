import 'dart:convert';
import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  // Store URLs (sabit)
  static const String androidStoreUrl =
      'https://play.google.com/store/apps/details?id=com.eyuboglu.tok';
  static const String iosStoreUrl =
      'https://apps.apple.com/tr/app/ibday-2025/id6467399144';

  // Remote Config key - tek JSON parametre
  static const String _appUpdateConfigKey = 'app_update_config';

  // Default JSON config
  static const String _defaultConfig = '''
{
  "min_android_version": "1.0.0",
  "min_ios_version": "1.0.0",
  "force_update": false
}
''';

  Future<void> initialize() async {
    try {
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: Duration.zero, // Test icin hemen fetch
        ),
      );

      await _remoteConfig.setDefaults({
        _appUpdateConfigKey: _defaultConfig,
      });

      final activated = await _remoteConfig.fetchAndActivate();
      debugPrint('RemoteConfig activated: $activated');
      debugPrint('RemoteConfig raw value: ${_remoteConfig.getString(_appUpdateConfigKey)}');
    } catch (e) {
      debugPrint('RemoteConfig initialize error: $e');
    }
  }

  Map<String, dynamic> get _updateConfig {
    try {
      final jsonString = _remoteConfig.getString(_appUpdateConfigKey);
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Config parse error: $e');
      return {
        'min_android_version': '1.0.0',
        'min_ios_version': '1.0.0',
        'force_update': false,
      };
    }
  }

  String get minVersion {
    final config = _updateConfig;
    if (Platform.isAndroid) {
      return config['min_android_version'] as String? ?? '1.0.0';
    } else if (Platform.isIOS) {
      return config['min_ios_version'] as String? ?? '1.0.0';
    }
    return '1.0.0';
  }

  bool get forceUpdate {
    final config = _updateConfig;
    return config['force_update'] as bool? ?? false;
  }

  String get storeUrl {
    if (Platform.isAndroid) {
      return androidStoreUrl;
    } else if (Platform.isIOS) {
      return iosStoreUrl;
    }
    return '';
  }

  Future<UpdateInfo> checkForUpdate() async {
    try {
      await _remoteConfig.fetchAndActivate();

      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      final minRequiredVersion = minVersion;
      final isForceUpdate = forceUpdate;

      final needsUpdate = _compareVersions(currentVersion, minRequiredVersion);

      debugPrint('=== UPDATE CHECK ===');
      debugPrint('Current version: $currentVersion');
      debugPrint('Min required: $minRequiredVersion');
      debugPrint('Force update: $isForceUpdate');
      debugPrint('Needs update: $needsUpdate');
      debugPrint('Final forceUpdate: ${isForceUpdate && needsUpdate}');

      return UpdateInfo(
        needsUpdate: needsUpdate,
        forceUpdate: isForceUpdate && needsUpdate,
        currentVersion: currentVersion,
        minVersion: minRequiredVersion,
        storeUrl: storeUrl,
      );
    } catch (e) {
      debugPrint('CheckForUpdate error: $e');
      return UpdateInfo(
        needsUpdate: false,
        forceUpdate: false,
        currentVersion: '',
        minVersion: '',
        storeUrl: '',
      );
    }
  }

  bool _compareVersions(String current, String min) {
    try {
      final currentParts = current.split('.').map(int.parse).toList();
      final minParts = min.split('.').map(int.parse).toList();

      while (currentParts.length < 3) {
        currentParts.add(0);
      }
      while (minParts.length < 3) {
        minParts.add(0);
      }

      for (int i = 0; i < 3; i++) {
        if (currentParts[i] < minParts[i]) {
          return true;
        } else if (currentParts[i] > minParts[i]) {
          return false;
        }
      }
      return false;
    } catch (e) {
      debugPrint('Version comparison error: $e');
      return false;
    }
  }
}

class UpdateInfo {
  final bool needsUpdate;
  final bool forceUpdate;
  final String currentVersion;
  final String minVersion;
  final String storeUrl;

  UpdateInfo({
    required this.needsUpdate,
    required this.forceUpdate,
    required this.currentVersion,
    required this.minVersion,
    required this.storeUrl,
  });
}

final remoteConfigServiceProvider = Provider<RemoteConfigService>((ref) {
  return RemoteConfigService();
});
