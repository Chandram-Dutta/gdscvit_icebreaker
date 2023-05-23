import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gdscvit_icebreaker/game/repository/game_repository.dart';

class FirebaseGameRepository extends GameRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late CollectionReference _roomCollection;

  FirebaseGameRepository() {
    _roomCollection = _firestore.collection('rooms');
  }

  @override
  Future<void> changeJoinable({
    required String roomId,
    required String roomState,
  }) async {
    await _roomCollection.doc(roomId).update({
      'room_state': roomState,
    });
  }

  @override
  Future changeNextChoosable({
    required String roomId,
  }) async {
    final nameOfUsers = [];
    final idOfUsers = [];
    final choosableId = await _roomCollection
        .doc(roomId)
        .get()
        .then((value) => value.get('choosable_id'));
    final users = await _roomCollection.doc(roomId).collection('users').get();
    for (var element in users.docs) {
      nameOfUsers.add(element.data()['name']);
    }
    for (var element in users.docs) {
      idOfUsers.add(element.data()['id']);
    }
    int indexes = 0;
    if (choosableId == '') {
      await _roomCollection.doc(roomId).update({
        'choosable_id': idOfUsers[0],
        'choosable_index': 0,
        'choosable_name': nameOfUsers[0],
      });
    } else {
      indexes = idOfUsers.indexOf(choosableId);
      if (indexes + 1 == idOfUsers.length) {
        await _roomCollection.doc(roomId).update({
          'room_state': 'ended',
        });
      } else {
        await _roomCollection.doc(roomId).update({
          'choosable_id': idOfUsers[(indexes + 1)],
          'choosable_index': indexes + 1,
          'choosable_name': nameOfUsers[(indexes + 1)],
        });
      }
    }
  }

  @override
  Future<void> changePrompt({
    required String roomId,
    required String prompt,
  }) async {
    await _roomCollection.doc(roomId).update({
      'present_prompt': prompt,
    });
  }
}

final firebaseGameRepositoyProvider = Provider<GameRepository>((ref) {
  return FirebaseGameRepository();
});
