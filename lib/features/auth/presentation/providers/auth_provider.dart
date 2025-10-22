import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/dependency_injection/injection.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  FutureOr<User?> build() async {
    // Get current user on startup
    final authRepo = ref.read(authRepositoryProvider);
    final result = await authRepo.getCurrentUser();
    
    return result.fold(
      (failure) => null,
      (user) => user,
    );
  }

  Future<bool> login(String email, String password) async {
    state = const AsyncValue.loading();
    
    final authRepo = ref.read(authRepositoryProvider);
    final result = await authRepo.login(email, password);
    
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (user) {
        state = AsyncValue.data(user);
        return true;
      },
    );
  }

  Future<bool> register({
    required String email,
    required String password,
    required String name,
    String? phone,
    String? school,
    String? branch,
  }) async {
    state = const AsyncValue.loading();
    
    final authRepo = ref.read(authRepositoryProvider);
    final result = await authRepo.register(
      email: email,
      password: password,
      name: name,
      phone: phone,
      school: school,
      branch: branch,
    );
    
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (user) {
        state = AsyncValue.data(user);
        return true;
      },
    );
  }

  Future<void> logout() async {
    final authRepo = ref.read(authRepositoryProvider);
    await authRepo.logout();
    state = const AsyncValue.data(null);
  }

  Future<void> refreshToken() async {
    final authRepo = ref.read(authRepositoryProvider);
    await authRepo.refreshToken();
  }
}

// Provider for checking if user is authenticated
@riverpod
bool isAuthenticated(Ref ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.maybeWhen(
    data: (user) => user != null,
    orElse: () => false,
  );
}

// Auth repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return getIt<AuthRepository>();
});