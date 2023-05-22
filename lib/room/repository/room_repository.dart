import 'package:cloud_firestore/cloud_firestore.dart';

abstract class RoomRepository {
  Future<String> createRoom({required String roomType});
  Future<void> joinRoom(
      {required String roomId,
      required String userId,
      required bool roomOwner});
  Future<void> leaveRoom({required String roomId, required String userId});
  Stream<QuerySnapshot> getRoomUsers({required String roomId});
}
