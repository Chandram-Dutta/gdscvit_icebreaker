import 'package:cloud_firestore/cloud_firestore.dart';

abstract class RoomRepository {
  Future<String> createRoom({required String roomType});
  Future<void> joinRoom({
    required String roomId,
    required String userId,
    required bool roomOwner,
    required String name,
  });
  Future<void> leaveRoom({required String roomId, required String userId});
  Query<Map<String, dynamic>> getRoomUsers({required String roomId});

  Stream<String> getJoinable({required String roomId});

  Stream<DocumentSnapshot> getRoomState({required String roomId});
}
