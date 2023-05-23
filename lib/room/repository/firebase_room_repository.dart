import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gdscvit_icebreaker/room/repository/room_repository.dart';

class FirebaseRoomRepository extends RoomRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late CollectionReference _roomCollection;

  FirebaseRoomRepository() {
    _roomCollection = _firestore.collection('rooms');
  }

  @override
  Future<String> createRoom({required String roomType}) async {
    final id = Random().nextInt(9999999) + 1000000;
    await _roomCollection.doc(id.toString()).set({
      'id': id,
      'type': roomType,
      'createdAt': FieldValue.serverTimestamp(),
      'joinable': true,
      'prompt': '',
    });
    return id.toString();
  }

  @override
  Future<void> joinRoom({
    required String roomId,
    required String userId,
    required bool roomOwner,
    required String name,
  }) async {
    final noOfUsers = await _roomCollection
        .doc(roomId)
        .collection('users')
        .get()
        .then((value) => value.docs.length);
    if (noOfUsers < 4) {
      _roomCollection.doc(roomId).collection('users').doc(userId).set({
        'id': userId,
        'joinedAt': FieldValue.serverTimestamp(),
        'choose': false,
        'roomOwner': roomOwner,
        'name': name,
      });
      if (noOfUsers == 3) {
        await _roomCollection.doc(roomId).update({
          'joinable': false,
        });
      }
    } else {
      throw Exception('Room is full');
    }
  }

  @override
  Future<void> leaveRoom({
    required String roomId,
    required String userId,
  }) async {
    if (await _roomCollection
            .doc(roomId)
            .collection('users')
            .get()
            .then((value) => value.docs.length) ==
        1) {
      await _roomCollection.doc(roomId).delete();
    } else {
      if (await _roomCollection
              .doc(roomId)
              .collection('users')
              .doc(userId)
              .get()
              .then((value) => value.data()!['roomOwner']) ==
          true) {
        final users = await _roomCollection
            .doc(roomId)
            .collection('users')
            .get()
            .then((value) => value.docs);
        if (users.length > 1) {
          await _roomCollection
              .doc(roomId)
              .collection('users')
              .doc(users[1].id)
              .update({
            'roomOwner': true,
          });
        }
      }
      await _roomCollection
          .doc(roomId)
          .collection('users')
          .doc(userId)
          .delete();
    }
  }

  @override
  Query<Map<String, dynamic>> getRoomUsers({required String roomId}) {
    return _roomCollection.doc(roomId).collection('users').orderBy('joinedAt');
  }
}

final firebaseRoomRepositoryProvider = Provider<FirebaseRoomRepository>((ref) {
  return FirebaseRoomRepository();
});
