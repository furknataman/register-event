import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/auth_response.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  );

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final result = await _remoteDataSource.login(email, password);
      
      // Save user data locally
      await _localDataSource.saveUser(result);
      await _localDataSource.saveToken(result.token);
      if (result.refreshToken != null) {
        await _localDataSource.saveRefreshToken(result.refreshToken!);
      }
      
      return Right(result.user.toDomain());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String name,
    String? phone,
    String? school,
    String? branch,
  }) async {
    try {
      final result = await _remoteDataSource.register(
        email: email,
        password: password,
        name: name,
        phone: phone,
        school: school,
        branch: branch,
      );
      
      // Save user data locally
      await _localDataSource.saveUser(result);
      await _localDataSource.saveToken(result.token);
      if (result.refreshToken != null) {
        await _localDataSource.saveRefreshToken(result.refreshToken!);
      }
      
      return Right(result.user.toDomain());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Try to logout from server
      try {
        await _remoteDataSource.logout();
      } catch (e) {
        // Continue with local logout even if server logout fails
      }
      
      // Clear local data
      await _localDataSource.clearUser();
      await _localDataSource.clearToken();
      await _localDataSource.clearRefreshToken();
      
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to logout: $e'));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      // Check if we have a valid token first
      final token = await _localDataSource.getToken();
      if (token == null) {
        return const Right(null);
      }
      
      // Try to get user from local storage first
      final localUser = await _localDataSource.getUser();
      if (localUser != null) {
        return Right(localUser);
      }
      
      // If no local user, try to fetch from server
      final result = await _remoteDataSource.getCurrentUser();
      await _localDataSource.saveUser(result);
      
      return Right(result.user.toDomain());
    } on AuthException {
      // Token might be expired, clear local data
      await _localDataSource.clearUser();
      await _localDataSource.clearToken();
      await _localDataSource.clearRefreshToken();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to get current user: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final token = await _localDataSource.getToken();
      return Right(token != null);
    } catch (e) {
      return Left(ServerFailure('Failed to check login status: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> refreshToken() async {
    try {
      final refreshToken = await _localDataSource.getRefreshToken();
      if (refreshToken == null) {
        return Left(AuthFailure('No refresh token available'));
      }
      
      final result = await _remoteDataSource.refreshToken(refreshToken);
      
      // Save new tokens
      await _localDataSource.saveToken(result.token);
      if (result.refreshToken != null) {
        await _localDataSource.saveRefreshToken(result.refreshToken!);
      }
      
      return const Right(null);
    } on AuthException catch (e) {
      // Refresh token is invalid, clear all tokens
      await _localDataSource.clearToken();
      await _localDataSource.clearRefreshToken();
      await _localDataSource.clearUser();
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to refresh token: $e'));
    }
  }
}