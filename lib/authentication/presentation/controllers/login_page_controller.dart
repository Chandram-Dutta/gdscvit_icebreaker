import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gdscvit_icebreaker/authentication/repository/auth_repository.dart';
import 'package:gdscvit_icebreaker/authentication/repository/firebase_auth_repository.dart';

class LoginPageController extends StateNotifier<AsyncValue<void>> {
  LoginPageController({required this.authRepository})
      : super(const AsyncData<void>(null));
  final AuthRepository authRepository;

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(
      () => authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      ),
    );
  }

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(
      () => authRepository.createUserWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
      ),
    );
  }
}

final loginPageControllerProvider =
    StateNotifierProvider.autoDispose<LoginPageController, AsyncValue<void>>(
  (ref) {
    return LoginPageController(
      authRepository: ref.watch(firebaseAuthRepositoryProvider),
    );
  },
);
