import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gdscvit_icebreaker/authentication/repository/auth_repository.dart';
import 'package:gdscvit_icebreaker/authentication/repository/firebase_auth_repository.dart';
import 'package:gdscvit_icebreaker/room/repository/firebase_room_repository.dart';
import 'package:gdscvit_icebreaker/room/repository/room_repository.dart';

class ChooseThemePageController extends StateNotifier<AsyncValue<String>> {
  ChooseThemePageController({
    required this.roomRepository,
    required this.authRepository,
  }) : super(const AsyncData<String>(""));
  final RoomRepository roomRepository;
  final AuthRepository authRepository;

  Future<void> createRoomAndAddUser({required String roomType}) async {
    state = const AsyncLoading<String>();
    state = await AsyncValue.guard<String>(() async {
      final roomId = await roomRepository.createRoom(
        roomType: roomType,
      );
      final userId = authRepository.currentUser!.uid;
      await roomRepository.joinRoom(
        roomId: roomId,
        userId: userId,
        roomOwner: true,
      );
      return roomId;
    });
  }
}

final chooseThemePageControllerProvider = StateNotifierProvider.autoDispose<
    ChooseThemePageController, AsyncValue<String>>(
  (ref) {
    return ChooseThemePageController(
      roomRepository: ref.watch(firebaseRoomRepositoryProvider),
      authRepository: ref.watch(firebaseAuthRepositoryProvider),
    );
  },
);
