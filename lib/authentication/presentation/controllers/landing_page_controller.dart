import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gdscvit_icebreaker/authentication/repository/auth_repository.dart';
import 'package:gdscvit_icebreaker/authentication/repository/firebase_auth_repository.dart';

class LandingPageController extends StateNotifier<AsyncValue<void>> {
  LandingPageController({required this.authRepository})
      : super(const AsyncData<void>(null));
  final AuthRepository authRepository;

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(
      () => authRepository.signInWithGoogle(),
    );
  }
}

final landingPageControllerProvider =
    StateNotifierProvider.autoDispose<LandingPageController, AsyncValue<void>>(
  (ref) {
    return LandingPageController(
      authRepository: ref.watch(firebaseAuthRepositoryProvider),
    );
  },
);
