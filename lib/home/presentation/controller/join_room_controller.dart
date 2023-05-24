import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gdscvit_icebreaker/authentication/repository/auth_repository.dart';
import 'package:gdscvit_icebreaker/authentication/repository/firebase_auth_repository.dart';
import 'package:gdscvit_icebreaker/room/repository/firebase_room_repository.dart';
import 'package:gdscvit_icebreaker/room/repository/room_repository.dart';

class JoinRoomController extends StateNotifier<AsyncValue<String>> {
  JoinRoomController({
    required this.roomRepository,
    required this.authRepository,
  }) : super(const AsyncData<String>(""));
  final RoomRepository roomRepository;
  final AuthRepository authRepository;

  Future<void> joinRoom({
    required String roomId,
  }) async {
    state = const AsyncLoading<String>();
    state = await AsyncValue.guard<String>(() async {
      final userId = authRepository.currentUser!.uid;
      await roomRepository.joinRoom(
        roomId: roomId,
        userId: userId,
        roomOwner: false,
        name: authRepository.currentUser!.displayName.toString(),
      );
      return roomId;
    });
  }
}

final joinRoomControllerProvider =
    StateNotifierProvider.autoDispose<JoinRoomController, AsyncValue<String>>(
  (ref) {
    return JoinRoomController(
      roomRepository: ref.watch(firebaseRoomRepositoryProvider),
      authRepository: ref.watch(firebaseAuthRepositoryProvider),
    );
  },
);
