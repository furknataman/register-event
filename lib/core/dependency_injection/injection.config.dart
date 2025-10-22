// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:autumn_conference/core/dependency_injection/core_module.dart'
    as _i294;
import 'package:autumn_conference/core/errors/error_handler.dart' as _i733;
import 'package:autumn_conference/core/network/api_client.dart' as _i42;
import 'package:autumn_conference/core/network/network_info.dart' as _i896;
import 'package:autumn_conference/core/storage/secure_storage.dart' as _i991;
import 'package:autumn_conference/core/utils/logger.dart' as _i387;
import 'package:autumn_conference/features/auth/data/datasources/auth_local_datasource.dart'
    as _i384;
import 'package:autumn_conference/features/auth/data/datasources/auth_remote_datasource.dart'
    as _i719;
import 'package:autumn_conference/features/auth/data/repositories/auth_repository_impl.dart'
    as _i687;
import 'package:autumn_conference/features/auth/domain/repositories/auth_repository.dart'
    as _i696;
import 'package:autumn_conference/features/events/data/datasources/event_local_datasource.dart'
    as _i127;
import 'package:autumn_conference/features/events/data/datasources/event_remote_datasource.dart'
    as _i490;
import 'package:autumn_conference/features/events/data/repositories/event_repository_impl.dart'
    as _i59;
import 'package:autumn_conference/features/events/domain/repositories/event_repository.dart'
    as _i953;
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:logger/logger.dart' as _i974;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final connectivityModule = _$ConnectivityModule();
    final coreModule = _$CoreModule();
    gh.lazySingleton<_i895.Connectivity>(() => connectivityModule.connectivity);
    gh.lazySingleton<_i387.AppLogger>(() => _i387.AppLogger());
    gh.lazySingleton<_i991.SecureStorage>(() => _i991.SecureStorage());
    gh.lazySingleton<_i361.Dio>(() => coreModule.dio);
    gh.lazySingleton<_i558.FlutterSecureStorage>(
        () => coreModule.secureStorage);
    await gh.lazySingletonAsync<_i460.SharedPreferences>(
      () => coreModule.sharedPreferences,
      preResolve: true,
    );
    gh.lazySingleton<_i974.Logger>(() => coreModule.logger);
    gh.lazySingleton<_i384.AuthLocalDataSource>(
        () => _i384.AuthLocalDataSourceImpl());
    gh.lazySingleton<_i896.NetworkInfo>(
        () => _i896.NetworkInfoImpl(gh<_i895.Connectivity>()));
    gh.lazySingleton<_i127.EventLocalDataSource>(
        () => _i127.EventLocalDataSourceImpl(gh<_i387.AppLogger>()));
    gh.lazySingleton<_i733.ErrorHandler>(
        () => _i733.ErrorHandler(gh<_i387.AppLogger>()));
    gh.factory<_i42.ApiClient>(() => _i42.ApiClient(
          gh<_i361.Dio>(),
          gh<_i558.FlutterSecureStorage>(),
          gh<_i974.Logger>(),
        ));
    gh.lazySingleton<_i719.AuthRemoteDataSource>(
        () => _i719.AuthRemoteDataSourceImpl(
              gh<_i42.ApiClient>(),
              gh<_i387.AppLogger>(),
            ));
    gh.lazySingleton<_i696.AuthRepository>(() => _i687.AuthRepositoryImpl(
          gh<_i719.AuthRemoteDataSource>(),
          gh<_i384.AuthLocalDataSource>(),
        ));
    gh.lazySingleton<_i490.EventRemoteDataSource>(
        () => _i490.EventRemoteDataSourceImpl(
              gh<_i42.ApiClient>(),
              gh<_i991.SecureStorage>(),
            ));
    gh.lazySingleton<_i953.EventRepository>(() => _i59.EventRepositoryImpl(
          gh<_i490.EventRemoteDataSource>(),
          gh<_i127.EventLocalDataSource>(),
        ));
    return this;
  }
}

class _$ConnectivityModule extends _i896.ConnectivityModule {}

class _$CoreModule extends _i294.CoreModule {}
